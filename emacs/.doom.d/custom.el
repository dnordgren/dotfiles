(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval progn
      (set-formatter! 'markdownlint-fix
       '("npx" "markdownlint-cli2" "--fix" "--" filepath)
       :modes
       '(markdown-mode gfm-mode))
      (defun +hudl/archive-tasks nil
       (interactive)
       (let
           ((default-directory
             (doom-project-root)))
         (async-shell-command "node scripts/archive_tasks.js" "*hudl-archive*")))
      (map! :leader :desc "Archive tasks" "p A" #'+hudl/archive-tasks)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
