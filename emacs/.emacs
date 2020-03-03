;; -*- mode: elisp -*-

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

(setq column-number-mode t)

(package-initialize)

(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(custom-set-variables
  '(org-agenda-files (quote ("~/todo.org" "~/inbox.org")))
  '(org-default-notes-file "~/notes.org")
  '(org-agenda-ndays 7)
  '(org-deadline-warning-days 14)
  '(org-agenda-show-all-dates t)
  '(org-agenda-skip-deadline-if-done t)
  '(org-agenda-skip-scheduled-if-done t)
  '(org-agenda-start-on-weekday nil)
  '(org-reverse-note-order t)
  '(org-fast-tag-selection-single-key (quote expert))
  '(org-remember-store-without-prompt t)
  '(org-remember-templates
    (quote ((116 "* TODO %?\n  %u" "~/todo.org" "Tasks")
      (110 "* %u %?" "~/notes.org" "Notes"))))
  '(remember-annotation-functions (quote (org-remember-annotation)))
  '(remember-handler-functions (quote (org-remember-handler)))
  '(package-selected-packages (quote (org))))
(custom-set-faces)

;; Disable the splash screen (to enable it agin, replace the t with 0)
(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;;;; Org mode configuration
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))

(setq org-todo-keywords
  '((sequence "TODO" "STARTED" "DONE")))

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(define-key mode-specific-map [?a] 'org-agenda)

(eval-after-load "org"
  '(progn
    (define-prefix-command 'org-todo-state-map)

    (define-key org-mode-map "\C-cx" 'org-todo-state-map)
    (define-key org-todo-state-map "x"
      #'(lambda nil (interactive) (org-todo "DONE")))
    (define-key org-todo-state-map "c"
      #'(lambda nil (interactive) (org-todo "CANCELLED")))
    (define-key org-todo-state-map "m"
      #'(lambda nil (interactive) (org-todo "MOVED")))
    (define-key org-todo-state-map "f"
      #'(lambda nil (interactive) (org-todo "DEFERRED")))
    (define-key org-todo-state-map "l"
      #'(lambda nil (interactive) (org-todo "DELEGATED")))
    (define-key org-todo-state-map "w"
      #'(lambda nil (interactive) (org-todo "WAITING")))
    (define-key org-todo-state-map "s"
      #'(lambda nil (interactive) (org-todo "STARTED")))))

(require 'remember)

(add-hook 'remember-mode-hook 'org-remember-apply-template)

(define-key global-map [(control meta ?r)] 'remember)

;;;; Color theming
;; Monokai
(load-theme 'monokai t)

