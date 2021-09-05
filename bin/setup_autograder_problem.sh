#!/bin/bash

set -e

cp -r "$HOME"/code/python/autograder-old/*/"$1" .
cd "$1"
mv test.py soln.py
cp -r ../../template/samples .
