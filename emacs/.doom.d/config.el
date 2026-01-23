;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Derek Nordgren"
      user-mail-address "derek.nordgren@protonmail.com")

(setq doom-font (font-spec :family "Berkeley Mono" :size 14))

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
;; + doom-plain      ; grayscale
;; + doom-plain-dark ; grayscale
;; + doom-rouge
;; + doom-dracula
;; + doom-monokai-spectrum https://monokai.pro/sublime-text
;; + doom-xcode
;; + doom-rouge https://github.com/josefaidt/rouge-theme
;; + doom-sourcerer - fav!
;; + doom-monokai-spectrum
;; + doom-homage-white ; plain/retro theme
;; + doom-homage-black ; plain/retro theme
;; + doom-ir-black     ; plain/retro theme, slightly bolder than homage
;; + doom-gruvbox
;; + doom-gruvbox-light
;; + doom-pine ; green-tinged gruvbox
(setq doom-theme 'doom-sourcerer)

;;;; Editor preferences

;; Disable Alt-3 as £ to support hash on British keyboard.
(define-key key-translation-map (kbd "M-3") (kbd "#"))

;; This determines the style of line numbers in effect.
;; If set to t, line numbers are normal.
;; If set to `nil', line numbers are disabled.
;; For relative line numbers, set this to 'relative.
(setq display-line-numbers-type 'relative)

;; Enable auto-fill-mode (auto-hard line wrap) for text files
;; use M-q to reformat just the current block of text
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
;; Enable visual line mode for text files
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; Use soft tabs
(setq-default indent-tabs-mode nil
              tab-width 4)

(add-to-list 'auto-mode-alist '("\\.omnijs\\'" . js2-mode))

;; Set up vector search from vaults
(defun vault-vector-search ()
  "Search the vault using the local vector database."
  (interactive)
  (let* ((query (read-string "Vector Search: "))
         ;; Robust project root finding
         (root (or (and (bound-and-true-p projectile-mode)
                        (projectile-project-root))
                   (and (fboundp 'project-root)
                        (project-root (project-current)))
                   default-directory))
         (venv-python (expand-file-name ".venv/bin/python3" root))
         ;; Use venv python if exists, otherwise fallback to system python
         (python (if (file-exists-p venv-python) venv-python "python3"))
         (script (expand-file-name "scripts/vectorize.py" root))
         (command (format "%s %s search %s --limit 20 --json"
                          (shell-quote-argument python)
                          (shell-quote-argument script)
                          (shell-quote-argument query))))

    (if (not (file-exists-p script))
        (message "Error: scripts/vectorize.py not found at %s" script)
      (message "Searching...")
      (let ((json-str (shell-command-to-string command)))
        (condition-case err
            (let* ((results (json-parse-string json-str :object-type 'alist))
                   (candidates (mapcar (lambda (item)
                                         (let ((path (alist-get 'path item))
                                               (content (alist-get 'content item))
                                               (line (alist-get 'line item)))
                                           (cons (format "%s:%s | %s..."
                                                         (file-name-nondirectory path)
                                                         line
                                                         (substring content 0 (min 80 (length content))))
                                                 (list path line))))
                                       results)))
              (if (null candidates)
                  (message "No results found.")
                (let ((selection (completing-read "Results: " candidates)))
                  (when selection
                    (let* ((data (cdr (assoc selection candidates)))
                           (file (nth 0 data))
                           (line (nth 1 data)))
                      (if (file-exists-p file)
                          (progn
                            (find-file file)
                            (when line
                              (goto-char (point-min))
                              (forward-line (1- line))))
                        (message "File not found: %s" file)))))))
          (json-parse-error
           (message "Error parsing JSON output: %s. Raw output: %s" err json-str)))))))

;; Map the key
(map! :leader
      :prefix "n"
      :desc "Vector Search" "V" #'vault-vector-search)

;;;; Set up Doom-Gemini (Doom Claude Code) integration
(use-package! agent-shell
  :config
  ;; Optional: Inherit your shell environment (PATH, etc.)
  (setq agent-shell-process-environment
        (agent-shell-make-environment-variables :inherit-env t))

  ;; For Gemini CLI:
  ;; Ensure you have run `gcloud auth login` or set GOOGLE_API_KEY in your shell
  (setq agent-shell-google-authentication
        (agent-shell-google-make-authentication :login t))

  ;; For Claude Code:
  ;; Ensure you have run `claude login` in your terminal first
  (setq agent-shell-anthropic-claude-authentication
        (agent-shell-anthropic-make-authentication :login t)))
;; Use Olivetti to control window margins for a nice writing environment
;; GitHub rnkn/olivetti
(use-package olivetti
  :hook (text-mode . olivetti-mode)
  :config
  (setq olivetti-body-width 140))

;; use auto-dark to dynamically swap theme based on system night/day setting
(use-package! auto-dark
  :after doom-ui
  :config
  (setq! auto-dark-dark-theme 'doom-homage-black
         auto-dark-light-theme 'doom-homage-white) (auto-dark-mode))

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

;; Load nvm and use default Node version
(use-package! exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "NVM_DIR")))

;; Markdown linting
(setq flycheck-markdown-mdl-style "~/.mdlrc")

;; Rust IDE
;; Configure Racer per https://github.com/racer-rust/emacs-racer
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)

;; Web development
;; Set up eglot web lang server
(set-eglot-client! 'web-mode '("vscode-html-language-server" "--stdio"))
;; Use web mode rather than HTML/CSS/JS modes
;; this helps with text prediction
(use-package! web-mode
  :mode "\\.html\\'")
;; Disable eldoc as it's annoying in web-mode
(global-eldoc-mode -1)

;; enable matchit
;; (use % to navigate to matching tags in e.g. HTML)
(after! evil-matchit
  (global-evil-matchit-mode 1))

;;; magit configuration
;; enable git commit signing with gpg in magit (see git blame on this commit)
(after! epa
  (pinentry-start))

;; configure suffixes to allow choosing gpg key at commit-time
;; https://github.com/magit/magit/issues/3771#issuecomment-477589185
(setq transient-default-level 5)

;;;; org-mode configuration

(setq org-directory "~/vaults/working-notes")

;; (setq org-archive-location "~/vaults/working-notes/archive/2023/2023-q3-archive/2023.q3.archive.org::datetree/* Completed Tasks")

;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      '(:link t :tags t :maxlevel 3 :scope file))

;; Ignore broken links during org-mode export (mark)
(setq org-export-with-broken-links t)

;;; Configure clock reporting in org-mode

;; set time format to hh:mm - doesn't work
;; (setq org-duration-format 'h:mm)

;; from http://mpas.github.io/posts/2021/03/16/2021-03-16-time-tracking-with-org-mode-and-sum-time-per-tag/
(defun convert-org-clocktable-time-to-hhmm (time-string)
  "Converts a time string to HH:MM"
  (if (> (length time-string) 0)
      (progn
        (let* ((s (s-replace "*" "" time-string))
               (splits (split-string s ":"))
               (hours (car splits))
               (minutes (car (last splits)))
               )
          (if (= (length hours) 1)
              (format "0%s:%s" hours minutes)
            (format "%s:%s" hours minutes))))
    time-string))

;;;; Configure mu4e
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
