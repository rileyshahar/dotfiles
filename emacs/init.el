(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("org" . "https://orgmode.org/elpa/")
                        ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
; always ensure packages are loaded
(setq use-package-always-ensure t)

(use-package general
  :config
  (general-evil-setup t))

(general-create-definer rs/leader-def
  :prefix ",")

(general-create-definer rs/local-leader-def
  :prefix "\\")

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode)
  (define-key evil-insert-state-map (kbd "<C-return>") 'evil-normal-state)
  (evil-set-undo-system 'undo-redo))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

; vim-surround for evil mode
(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package key-chord
  :config
  (key-chord-mode 1))

(setq key-chord-two-keys-delay 0.5)
(setq key-chord-safety-interval-backward 0.0) ; always interpret a key as starting a chord
(setq key-chord-safety-interval-forward 0.0)  ; always immediately execute a chord which completes
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-mode 1)

(defun rs/org-mode-setup ()
  (org-indent-mode))

(use-package org
  :hook (org-mode . rs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-return-follows-link t))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

; auto continue lists
(use-package org-autolist
  :hook (org-mode . org-autolist-mode))

; completion
(use-package vertico
  :config
  (vertico-mode))

; order completions
(use-package orderless
  :config
  (setq completion-styles '(orderless)))

; annotate completions
(use-package marginalia
  :config
  (marginalia-mode))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; disable visible scrollbar
(tool-bar-mode -1)          ; disable the toolbar
(tooltip-mode -1)           ; disable tooltips
(menu-bar-mode -1)          ; disable the menu bar
(set-fringe-mode 0)         ; disable padding

; theme
(use-package doom-themes)
(load-theme 'doom-one t)

; dependency: icons
(use-package all-the-icons)

; prettier modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode))

(set-face-attribute 'default nil :font "MesloLGS Nerd Font 11")

(global-display-line-numbers-mode 1)

(setq visible-bell t)                                   ; set visual instead of audio bell
(doom-themes-visual-bell-config)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Make ESC quit prompts

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
