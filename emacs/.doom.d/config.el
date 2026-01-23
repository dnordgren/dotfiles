;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;
;; Configuration Sections:
;; 1. Personal Information & Appearance
;; 2. Editor Preferences
;; 3. UI Enhancements
;; 4. Extensions Configuration
;; 5. IDE Configuration
;; 6. org-mode Configuration
;; 7. Version Control
;; 8. Custom Functions & Tools
;; 9. AI Integration

;;;; 1. Personal Information & Appearance

(setq user-full-name "Derek Nordgren"
      user-mail-address "derek.nordgren@protonmail.com")

(setq doom-font (font-spec :family "Berkeley Mono" :size 14))

;; Theme selection handled by auto-dark (see section 3)
;; See full list: https://github.com/doomemacs/themes
;; Favorites: doom-sourcerer, doom-nord, doom-homage-white/black, doom-gruvbox, doom-dracula

;;;; 2. Editor Preferences

;; Line numbers
(setq display-line-numbers-type 'relative)

;; Indentation
(setq-default indent-tabs-mode nil
              tab-width 4)

;; Text mode behavior
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; File associations
(add-to-list 'auto-mode-alist '("\\.omnijs\\'" . js2-mode))

;; Keybindings
;; Disable Alt-3 as £ to support hash on British keyboard
(define-key key-translation-map (kbd "M-3") (kbd "#"))

;; Line movement keybindings (functions defined in autoload.el)
(map! :ni "M-<up>"   #'my-move-line-up
      :ni "M-<down>" #'my-move-line-down)

;;;; 3. UI Enhancements

;; Auto-dark: dynamically swap theme based on system night/day setting
(use-package! auto-dark
  :after doom-ui
  :config
  (setq! auto-dark-dark-theme 'doom-homage-black
         auto-dark-light-theme 'doom-homage-white)
  (auto-dark-mode 1))

;;;; 4. Extensions Configuration

;; Projectile
;; Note: Add your project directories to projectile-project-search-path
;; Example: (setq projectile-project-search-path '("~/repos" "~/projects"))

;; Deft (note search)
;; Note: Configure deft-directory to point to your notes directory
(setq deft-extensions '("txt" "md" "org")
      deft-recursive t
      deft-use-filename-as-title t)

;; Treemacs
(setq treemacs-sorting 'alphabetic-case-insensitive-desc)

;; Evil-matchit (use % to navigate matching tags in HTML, etc.)
(after! evil-matchit
  (global-evil-matchit-mode 1))

;;;; 5. IDE Configuration

;;; Node.js / JavaScript
;; Load nvm and use default Node version
(use-package! exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "NVM_DIR"))

;;; Markdown
;; Markdown linting
(setq flycheck-markdown-mdl-style "~/.mdlrc")

;;; Web Development
;; Set up eglot web lang server
(set-eglot-client! 'web-mode '("vscode-html-language-server" "--stdio"))

;; Use web-mode for HTML files (better for mixed HTML/CSS/JS)
(use-package! web-mode
  :mode "\\.html\\'")

;; Disable eldoc in web-mode (can be noisy)
(add-hook 'web-mode-hook (lambda () (eldoc-mode -1)))

;;;; 6. org-mode Configuration

;; Note: Set org-directory to your notes/org files location
;; Example: (setq org-directory "~/Documents/org")

;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
      '(:link t :tags t :maxlevel 3 :scope file))

;; Ignore broken links during org-mode export
(setq org-export-with-broken-links t)

;;;; 7. Version Control

;; Magit: enable git commit signing with gpg
(after! epa
  (pinentry-start))

;; Configure suffixes to allow choosing gpg key at commit-time
;; https://github.com/magit/magit/issues/3771#issuecomment-477589185
(setq transient-default-level 5)

;;;; 8. Custom Functions & Tools

;; Vault vector search keybinding (function defined in autoload.el)
(map! :leader
      :prefix "n"
      :desc "Vector Search" "V" #'vault-vector-search)

;;;; 9. AI Integration

;; Agent-shell: Doom-Gemini and Claude Code integration
(use-package! agent-shell
  :config
  ;; Inherit shell environment (PATH, etc.)
  (setq agent-shell-process-environment
        (agent-shell-make-environment-variables :inherit-env t))

  ;; For Gemini CLI: ensure you have run `gcloud auth login` or set GOOGLE_API_KEY
  (setq agent-shell-google-authentication
        (agent-shell-google-make-authentication :login t))

  ;; For Claude Code: ensure you have run `claude login` in your terminal first
  (setq agent-shell-anthropic-claude-authentication
        (agent-shell-anthropic-make-authentication :login t)))
