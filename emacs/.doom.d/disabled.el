;;; disabled.el --- Disabled configuration kept for reference -*- lexical-binding: t; -*-
;;
;; This file contains configuration that has been disabled but kept for reference.

;;;; mu4e Email Configuration
;; https://emacs.stackexchange.com/a/46171
;;(setq mu4e-mu-binary "/usr/local/bin/mu")
;;(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
;;(require 'mu4e)

;; Get mail
;;(setq
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
;;)

;; Send mail
;; (setq message-send-mail-function 'smtpmail-send-it
;; smtpmail-auth-credentials "~/.authinfo"
;; smtpmail-smtp-server "127.0.0.1"
;; smtpmail-stream-type 'starttls
;; smtpmail-smtp-service 1025)

;; (add-to-list 'gnutls-trustfiles (expand-file-name "~/.ssh/protonbridge.pem"))

;;;; Olivetti Configuration (Centered Writing Mode)
;; Use Olivetti to control window margins for a nice writing environment
;; GitHub rnkn/olivetti
;; (use-package olivetti
;;  :hook (text-mode . olivetti-mode)
;;  :config
;;  (setq olivetti-body-width 140))

;;;; org-mode Archive Location
;; (setq org-archive-location "~/vaults/working-notes/archive/2023/2023-q3-archive/2023.q3.archive.org::datetree/* Completed Tasks")

;;;; Auto-fill Mode (Hard Line Wrapping)
;; Enable auto-fill-mode (auto-hard line wrap) for text files
;; use M-q to reformat just the current block of text
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
