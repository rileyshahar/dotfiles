(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package straight
  :custom
  (straight-use-package-by-default t))

(use-package general
  :config
  (general-evil-setup t))

(general-auto-unbind-keys)

(general-create-definer rs/leader-def
  :keymaps 'normal
  :prefix ",")

(general-create-definer rs/local-leader-def
  :keymaps 'normal
  :prefix "\\")

(rs/leader-def
  "bp" '(previous-buffer :wk "previous buffer"))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode)
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

(general-define-key
 :keymaps 'evil-insert-state-map
 (general-chord "jk") '(evil-normal-state :wk "exit insert mode"))

(use-package key-chord
  :config
  (key-chord-mode 1))

(setq key-chord-two-keys-delay 0.5)
(setq key-chord-safety-interval-backward 0.0) ; always interpret a key as starting a chord
(setq key-chord-safety-interval-forward 0.0)  ; always immediately execute a chord which completes

(use-package which-key)
(which-key-mode)

(defun rs/org-mode-setup ()
  (org-indent-mode))

(use-package org
  :hook (org-mode . rs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾") ; sets symbol for collapsed headers
  (setq org-return-follows-link t))

(general-def org-mode-map
 "RET" '(org-return :wk "return"))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(use-package org-autolist
  :hook (org-mode . org-autolist-mode))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

(use-package toc-org
    :commands toc-org-enable
    :hook (org-mode . toc-org-enable))

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

(set-face-attribute 'default nil :font "MesloLGS Nerd Font 11")

(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)

(global-display-line-numbers-mode 1)

(setq visible-bell t)                                   ; set visual instead of audio bell
(doom-themes-visual-bell-config)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Make ESC quit prompts

(use-package bug-hunter)

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))
