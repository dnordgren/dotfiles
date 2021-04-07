;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Derek Nordgren"
      user-mail-address "derek.nordgren@protonmail.com")

(setq doom-font (font-spec :family "Fira Code" :size 16))

;; See themes: https://github.com/hlissner/emacs-doom-themes
;; Favorites:
;; + doom-city-lights http://citylights.xyz/
;; + doom-laserwave https://github.com/Jaredk3nt/laserwave
;; + doom-nord / doom-nord-light https://www.nordtheme.com/
;; + doom-outrun-electric https://github.com/samrap/outrun-theme-vscode
;; + doom-molokai
;; + doom-dracula
(setq doom-theme 'doom-outrun-electric)

(setq display-line-numbers-type t)

;; Enable auto-fill-mode (auto-hard line wrap) for text files
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Enable visual line mode for text files
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

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

(setq org-directory "~/repos/personal/logseq-vault")

(setq org-roam-directory "~/repos/personal/notebook-local-clone/notebook/roam")
(setq org-roam-dailies-directory "daily-notes")
(setq org-roam-dailies-capture-templates
      '(("d" "daily" entry #'org-roam-capture--get-point
         "* %?\n")))

;; Configure org-logseq
(setq org-logseq-dir "~/repos/personal/logseq-vault")
(load! "org-logseq")

;; Set go-to and go-back for org-logseq.
;; https://rameezkhan.me/adding-keybindings-to-doom-emacs/
(map! :leader
      (:prefix-map ("l" . "logseq")
       :desc "Open page link or block ID" "o" #'org-logseq-open-link
       :desc "Go back to last mark" "b" #'org-mark-ring-goto))
