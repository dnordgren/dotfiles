;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Derek Nordgren"
      user-mail-address "derek.nordgren@protonmail.com")

(setq doom-font (font-spec :family "iA Writer Duo S" :size 16))

;; See themes: https://github.com/hlissner/emacs-doom-themes
;; Favorites:
;; + doom-city-lights http://citylights.xyz/
;; + doom-laserwave https://github.com/Jaredk3nt/laserwave
;; + doom-nord / doom-nord-light https://www.nordtheme.com/
;; + doom-outrun-electric https://github.com/samrap/outrun-theme-vscode
;; + doom-molokai
;; + doom-moonlight
;; + doom-nova
;; + doom-old-hope ; star wars theme
;; + doom-peacock
;; + doom-plain ; grayscale
;; + doom-rouge
;; + doom-dracula
;; + doom-monokai-spectrum https://monokai.pro/sublime-text
;; + doom-xcode
;; + doom-rouge https://github.com/josefaidt/rouge-theme
;; + doom-sourcerer
(setq doom-theme 'doom-monokai-spectrum)

(setq display-line-numbers-type t)

;; Enable auto-fill-mode (auto-hard line wrap) for text files
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Enable visual line mode for text files
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; Use soft tabs
(setq-default indent-tabs-mode nil)

(setq projectile-project-search-path '("~/repos" "/Volumes/dav/notebook" "~~/Library/Mobile Documents/iCloud~md~obsidian/Documents/logseq-vault"))

(add-to-list 'auto-mode-alist '("\\.omnijs\\'" . js2-mode))

;; Configure Deft
(setq deft-extensions '("txt" "md" "org"))
(setq deft-directory "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/logseq-vault")
(setq deft-recursive t)
(setq deft-use-filename-as-title t)

(setq flycheck-markdown-mdl-style "~/.mdlrc")

;; Sort treemacs directory listing desc
(setq treemacs-sorting 'alphabetic-case-insensitive-desc)

(setq org-directory "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/logseq-vault")
(setq org-agenda-files (directory-files-recursively "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/logseq-vault/pages/" "\\.org$"))
(setq org-archive-location "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/logseq-vault/archive/2021.fyq2.archive.org::datetree/* Completed Tasks")
(after! org
  (setq org-agenda-files
    '(directory-files-recursively "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/logseq-vault/pages")))

;;(setq org-roam-dailies-directory "daily-notes")
;;(setq org-roam-dailies-capture-templates
;;      '(("d" "daily" entry #'org-roam-capture--get-point
;;         "* %?\n")))

;; Configure org-logseq
(setq org-logseq-dir "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/logseq-vault")
(load! "org-logseq")

;; Set go-to and go-back for org-logseq.
;; https://rameezkhan.me/adding-keybindings-to-doom-emacs/
(map! :leader
      (:prefix-map ("l" . "logseq")
       :desc "Open page link or block ID" "o" #'org-logseq-open-link
       :desc "Go back to last mark" "b" #'org-mark-ring-goto))

;;;; Configure Rust IDE
;; Configure Racer
;; per https://github.com/racer-rust/emacs-racer
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

(add-hook 'racer-mode-hook #'company-mode)
(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
