{-# OPTIONS_GHC -Wno-orphans             #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# LANGUAGE InstanceSigs       #-}
{-# LANGUAGE TypeApplications   #-}
{-# LANGUAGE TupleSections      #-}
{-# LANGUAGE LambdaCase         #-}
module OrgMode where

import XMonad.Prelude hiding ((!?))
import XMonad.Prompt.OrgMode

import qualified Data.Map.Strict as Map

import Data.Map.Strict (Map, (!), (!?))
import Test.Hspec
import Test.Hspec.QuickCheck
import Test.QuickCheck


spec :: Spec
spec = do
  prop "prop_encodeLinearity" prop_encodePreservation
  prop "prop_decodeLinearity" prop_decodePreservation

  -- Checking for regressions
  describe "pInput" $ do
    it "works with todo +d 22 january 2021" $ do
      pInput "todo +d 22 ja 2021"
        `shouldBe` Just
          ( Deadline
              "todo"
              (Time {date = Date (22, Just 1, Just 2021), tod = Nothing})
          )
    it "works with todo +d 22 01 2022" $ do
      pInput "todo +d 22 01 2022"
        `shouldBe` Just
          ( Deadline
              "todo"
              (Time {date = Date (22, Just 1, Just 2022), tod = Nothing})
          )
    it "works with todo +d 1 01:01" $ do
      pInput "todo +d 1 01:01"
        `shouldBe` Just
          ( Deadline
              "todo"
              (Time {date = Date (1, Nothing, Nothing), tod = Just $ TimeOfDay 1 1})
          )

  context "+d +d f" $ do
    it "encode" $ prop_encodePreservation (OrgMsg "+d +d f")
    it "decode" $ prop_decodePreservation (Deadline "+d" (Time {date = Next Friday, tod = Nothing}))
  context "+d f 1 +d f" $ do
    it "encode" $ prop_encodePreservation (OrgMsg "+d f 1 +d f")
    it "decode" $ prop_decodePreservation (Deadline "+d f 1" (Time {date = Next Friday, tod = Nothing}))

-- | Parsing preserves all info that printing does.
prop_encodePreservation :: OrgMsg -> Property
prop_encodePreservation (OrgMsg s) = pInput s === (pInput . ppNote =<< pInput s)

-- | Printing preserves all info that parsing does.
prop_decodePreservation :: Note -> Property
prop_decodePreservation n = Just (ppNote n) === (fmap ppNote . pInput $ ppNote n)

------------------------------------------------------------------------
-- Pretty Printing

ppNote :: Note -> String
ppNote = \case
  Scheduled str t -> str <> " +s " <> ppTime t
  Deadline  str t -> str <> " +d " <> ppTime t
  NormalMsg str   -> str

ppTime :: Time -> String
ppTime (Time d t) = ppDate d <> ppTOD t
 where
  ppTOD :: Maybe TimeOfDay -> String
  ppTOD = maybe "" ((' ' :) . show)

  ppDate :: Date -> String
  ppDate dte = case days !? dte of
    Just v  -> v
    Nothing -> case d of -- only way it can't be in the map
      Date (d', mbM, mbY) -> show d'
                          <> maybe "" ((' ' :) . (months !)) mbM
                          <> maybe "" ((' ' :) . show)       mbY

------------------------------------------------------------------------
-- Arbitrary Instances

-- | An arbitrary (correct) message string.
newtype OrgMsg = OrgMsg String
  deriving (Show)

instance Arbitrary OrgMsg where
  arbitrary :: Gen OrgMsg
  arbitrary = OrgMsg <$>
    randomString <<>> elements [" +s ", " +d ", ""] <<>> dateGen <<>> hourGen
   where
    dateGen :: Gen String
    dateGen = oneof
      [ pure $ days ! Today
      , pure $ days ! Tomorrow
      , elements $ (days !) . Next <$> [Monday .. Sunday]
      , rNat                                                   -- 17
      , unwords <$> sequenceA [rNat, monthGen]                 -- 17 jan
      , unwords <$> sequenceA [rNat, monthGen, rYear]          -- 17 jan 2021
      , unwords <$> traverse (fmap show) [rNat, rMonth]        -- 17 01
      , unwords <$> traverse (fmap show) [rNat, rMonth, rYear] -- 17 01 2021
      ]
     where
      rNat, rYear, rMonth :: Gen String
      rNat   = show <$> posInt
      rMonth = show <$> posInt `suchThat` (<= 12)
      rYear  = show <$> posInt `suchThat` (>  25)

      monthGen :: Gen String
      monthGen = elements $ Map.elems months

    hourGen :: Gen String
    hourGen = oneof
      [ pure " " <<>> (pad <$> hourInt) <<>> pure ":" <<>> (pad <$> minuteInt)
      , pure ""
      ]
     where
      pad :: Int -> String
      pad n = (if n <= 9 then "0" else "") <> show n

instance Arbitrary Note where
  arbitrary :: Gen Note
  arbitrary = do
    msg <- randomString
    t   <- arbitrary
    elements [Scheduled msg t, Deadline msg t, NormalMsg msg]

instance Arbitrary Time where
  arbitrary :: Gen Time
  arbitrary = Time <$> arbitrary <*> arbitrary

instance Arbitrary Date where
  arbitrary :: Gen Date
  arbitrary = oneof
    [ pure Today
    , pure Tomorrow
    , Next . toEnum <$> choose (0, 6)
    , do d <- posInt
         m <- mbPos `suchThat` (<= Just 12)
         Date . (d, m, ) <$> if   isNothing m
                             then pure Nothing
                             else mbPos `suchThat` (>= Just 25)
    ]

instance Arbitrary TimeOfDay where
  arbitrary :: Gen TimeOfDay
  arbitrary = TimeOfDay <$> hourInt <*> minuteInt

------------------------------------------------------------------------
-- Util

randomString :: Gen String
randomString = listOf arbitraryPrintableChar <<>> (noSpace <&> (: []))
 where
  noSpace :: Gen Char
  noSpace = arbitraryPrintableChar `suchThat` (/= ' ')

days :: Map Date String
days = Map.fromList
  [ (Today, "tod"), (Tomorrow, "tom"), (Next Monday, "m"), (Next Tuesday, "tu")
  , (Next Wednesday, "w"), (Next Thursday, "th"), (Next Friday, "f")
  , (Next Saturday,"sa"), (Next Sunday,"su")
  ]

months :: Map Int String
months = Map.fromList
  [ (1, "ja"), (2, "f"), (3, "mar"), (4, "ap"), (5, "may"), (6, "jun")
  , (7, "jul"), (8, "au"), (9, "s"), (10, "o"), (11, "n"), (12, "d")
  ]

posInt :: Gen Int
posInt = getPositive <$> arbitrary @(Positive Int)

hourInt :: Gen Int
hourInt = posInt `suchThat` (<= 23)

minuteInt :: Gen Int
minuteInt = posInt `suchThat` (<= 59)

mbPos :: Num a => Gen (Maybe a)
mbPos = fmap (fromIntegral . getPositive) <$> arbitrary @(Maybe (Positive Int))

infixr 6 <<>>
(<<>>) :: (Applicative f, Monoid a) => f a -> f a -> f a
(<<>>) = liftA2 (<>)
