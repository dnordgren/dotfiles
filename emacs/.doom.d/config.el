;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Derek Nordgren"
      user-mail-address "derek.nordgren@protonmail.com")

(setq doom-font (font-spec :family "iA Writer Duo S" :size 16))

;; See themes: https://github.com/hlissner/emacs-doom-themes
;; Favorites:
;; + doom-ayu-light
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
;; + doom-monokai-spectrum
(setq doom-theme 'doom-xcode)

;;;; Editor preferences

(setq display-line-numbers-type t)

;; Enable auto-fill-mode (auto-hard line wrap) for text files
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Enable visual line mode for text files
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; Use soft tabs
(setq-default indent-tabs-mode nil)

(add-to-list 'auto-mode-alist '("\\.omnijs\\'" . js2-mode))

;;;; Extensions configuration

;; Configure projectile
(setq projectile-project-search-path '("~/repos" "~/vaults/working-notes"))

;; Configure Deft
(setq deft-extensions '("txt" "md" "org"))
(setq deft-directory "~/vaults/working-notes")
(setq deft-recursive t)
(setq deft-use-filename-as-title t)

;; Sort treemacs directory listing desc
(setq treemacs-sorting 'alphabetic-case-insensitive-desc)

;;;; IDE configuration

;; Markdown linting
(setq flycheck-markdown-mdl-style "~/.mdlrc")

;; Rust IDE
;; Configure Racer per https://github.com/racer-rust/emacs-racer
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)

;;;; org-mode configuration

(setq org-directory "~/vaults/working-notes")

(setq org-archive-location "~/vaults/working-notes/archive/2022.fyq4.archive.org::datetree/* Completed Tasks")

;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      '(:link t :tags t :maxlevel 4 :block thisweek :scope file))

;; Ignore broken links during org-mode export (mark)
(setq org-export-with-broken-links t)

;; Configure org-logseq
;;(setq org-logseq-dir "~/vaults/working-notes")
;;(load! "org-logseq")

;; Set go-to and go-back for org-logseq.
;; https://rameezkhan.me/adding-keybindings-to-doom-emacs/
(map! :leader
      (:prefix-map ("l" . "logseq")
       :desc "Open page link or block ID" "o" #'org-logseq-open-link
       :desc "Go back to last mark" "b" #'org-mark-ring-goto))

;;;; Configure mu4e
;; https://emacs.stackexchange.com/a/46171
;;(setq mu4e-mu-binary "/usr/local/bin/mu")
;;(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
;;(require 'mu4e)

;; Get mail
(setq
;; this setting allows to re-sync and re-index mail
;; by pressing U
;;mu4e-get-mail-command "mbsync protonmail"
;;mu4e-change-filenames-when-moving t   ; needed for mbsync
;;mu4e-update-interval 120              ; update every 2 minutes
;;mue4e-headers-skip-duplicates  t
;;mu4e-view-show-images t
;;mu4e-view-show-addresses t
;;mu4e-compose-format-flowed nil
;;mu4e-date-format "%y/%m/%d"
;;mu4e-headers-date-format "%Y/%m/%d"
;;mu4e-attachments-dir "~/Desktop"
;;mu4e-maildir       "~/mail/protonmail"   ;; top-level Maildir
;; note that these folders below must start with /
;; the paths are relative to maildir root
;;mu4e-refile-folder "/Archive"
;;mu4e-sent-folder   "/Sent"
;;mu4e-drafts-folder "/Drafts"
;;mu4e-trash-folder  "/Trash"
)

;; Send mail
(setq message-send-mail-function 'smtpmail-send-it
smtpmail-auth-credentials "~/.authinfo"
smtpmail-smtp-server "127.0.0.1"
smtpmail-stream-type 'starttls
smtpmail-smtp-service 1025)

;; (add-to-list 'gnutls-trustfiles (expand-file-name "~/.ssh/protonbridge.pem"))
