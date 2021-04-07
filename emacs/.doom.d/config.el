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
;; + doom-molokai
;; + doom-dracula
(setq doom-theme 'doom-outrun-electric)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/repos/personal/logseq-vault")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Enable visual line mode for text files
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; Enable auto-fill-mode (auto-hard line wrap) for text files
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Use soft tabs
(setq-default indent-tabs-mode nil)

(setq projectile-project-search-path '("~/repos" "/Volumes/dav/notebook" "~/repos/personal/logseq-vault"))

(add-to-list 'auto-mode-alist '("\\.omnijs\\'" . js2-mode))

;; Configure Deft
(setq deft-extensions '("txt" "md" "org"))
(setq deft-directory "/Volumes/dav/notebook")
(setq deft-recursive t)
(setq deft-use-filename-as-title t)

(setq flycheck-markdown-mdl-style "~/.mdlrc")

;; Sort treemacs directory listing desc
(setq treemacs-sorting 'alphabetic-case-insensitive-desc)

(setq org-roam-directory "~/repos/personal/notebook-local-clone/notebook/roam")
(setq org-roam-dailies-directory "daily-notes")
(setq org-roam-dailies-capture-templates
      '(("d" "daily" entry #'org-roam-capture--get-point
         "* %?\n")))

;;(require 'org-roam-protocol)

;;(require 'simple-httpd)
;;(setq httpd-root "/var/www")
;;(httpd-start)

;;(use-package org-roam-server
;;  :ensure nil
;;  :load-path "~/www/org-roam-server")


;; Configure org-logseq
;;(use-package org-logseq
;;    :custom (org-logseq-dir "~/repos/personal/logseq-vault"))
(setq org-logseq-dir "~/repos/personal/logseq-vault")
;;(org-mode . ((eval org-logseq-mode 1)))

(load! "org-logseq")

;; Set go-to and go-back for org-logseq.
;; https://rameezkhan.me/adding-keybindings-to-doom-emacs/
(map! :leader
      (:prefix-map ("l" . "logseq")
       :desc "Open page link or block ID" "o" #'org-logseq-open-link
       :desc "Go back to last mark" "b" #'org-mark-ring-goto))

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
