;;; autoload.el --- Autoloaded custom functions -*- lexical-binding: t; -*-
;;
;; Functions defined here are lazily loaded when called, improving startup time.

;;;###autoload
(defun my-move-line-up ()
  "Move the current line up."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

;;;###autoload
(defun my-move-line-down ()
  "Move the current line down."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

;;;###autoload
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
