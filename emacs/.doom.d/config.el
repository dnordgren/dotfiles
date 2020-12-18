;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Derek Nordgren"
      user-mail-address "derek.nordgren@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Fira Code" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; See themes: https://github.com/hlissner/emacs-doom-themes
;; Favorites:
;; + doom-city-lights http://citylights.xyz/
;; + doom-laserwave https://github.com/Jaredk3nt/laserwave
;; + doom-nord / doom-nord-light https://www.nordtheme.com/
;; + doom-outrun-electric https://github.com/samrap/outrun-theme-vscode
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "/Volumes/dav/notebook/org")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Enable visual line mode for text files
;; (add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; Enable auto-fill-mode (auto-hard line wrap) for text files
(add-hook 'text-mode-hook 'turn-on-auto-fill)

(setq projectile-project-search-path '("~/repos" "/Volumes/dav/notebook"))

(add-to-list 'auto-mode-alist '("\\.omnijs\\'" . js2-mode))

;; Configure Deft
(setq deft-extensions '("txt" "md" "org"))
(setq deft-directory "/Volumes/dav/notebook")
(setq deft-recursive t)
(setq deft-use-filename-as-title t)

;; Save open buffers on loss of focus
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

(setq org-roam-directory "/Volumes/dav/notebook/roam")
(setq org-roam-dailies-directory "daily-notes")
(setq org-roam-dailies-capture-templates
      '(("d" "daily" entry #'org-roam-capture--get-point
         "* %?\n")))

(def-package! tide
  :init
  (defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

  ;; aligns annotation to the right hand side
  (setq company-tooltip-align-annotations t)

  ;; formats the buffer before saving
  (add-hook 'before-save-hook 'tide-format-before-save)

  (add-hook 'typescript-mode-hook #'setup-tide-mode))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
