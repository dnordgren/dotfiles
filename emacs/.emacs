;; -*- mode: elisp -*-

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

(setq column-number-mode t)

(add-hook 'text-mode-hook 'auto-fill-mode)
(setq-default fill-column 120)

(package-initialize)

(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; Markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(custom-set-variables
  '(org-agenda-files (quote ("~/org/agenda.org" "~/org/rendezvous.org")))
  '(org-agenda-ndays 7)
  '(org-deadline-warning-days 14)
  '(org-agenda-show-all-dates t)
  '(org-agenda-skip-deadline-if-done t)
  '(org-agenda-skip-scheduled-if-done t)
  '(org-agenda-start-on-weekday nil)
  '(org-reverse-note-order t)
  '(org-fast-tag-selection-single-key (quote expert))
  '(package-selected-packages (quote (org)))
  '(custom-enabled-themes (quote (misterioso))))

;; Disable the splash screen (to enable it agin, replace the t with 0)
(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;;;; Org mode configuration
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))

(setq org-todo-keywords
  '((sequence "TODO(t)" "STARTED(s!)" "WAITING(w@/!)" "DELEGATED(g@)" "|" "DROPPED(x@)" "DONE(d!)")))

;; Configure org-capture
(setq org-default-notes-file (concat org-directory "~/org/commonplace.org"))
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
  '(("t" "TODO" entry (file+headline "~/org/agenda.org" "Inbox")
      "* TODO %?\n [%U]"
    ("c" "Commonplace" entry (file+datetree "~/org/commonplace.org")
      "* %?\n [%U]")))

(define-key mode-specific-map [?a] 'org-agenda)

(eval-after-load "org"
  '(progn
    (define-prefix-command 'org-todo-state-map)

    (define-key org-mode-map "\C-cx" 'org-todo-state-map)
    (define-key org-todo-state-map "d"
      #'(lambda nil (interactive) (org-todo "DONE")))
    (define-key org-todo-state-map "x"
      #'(lambda nil (interactive) (org-todo "DROPPED")))
    (define-key org-todo-state-map "g"
      #'(lambda nil (interactive) (org-todo "DELEGATED")))
    (define-key org-todo-state-map "w"
      #'(lambda nil (interactive) (org-todo "WAITING")))
    (define-key org-todo-state-map "s"
      #'(lambda nil (interactive) (org-todo "STARTED")))))

;;;; Theming
;; Monokai color theme
;; (load-theme 'monokai t)

;; Solarized color theme
(load-theme 'solarized-dark t)
;; Don't change the font for some headings and titles
(setq solarized-use-variable-pitch nil)

;; Custom font face in GUI
(custom-set-faces
  '(default ((t (:family "Fira Code" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))

;; Auto-reload buffers from changed files
(global-auto-revert-mode t)

;; Auto-save buffers to files on loss of focus
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

;; Display line numbers
(global-display-line-numbers-mode)
