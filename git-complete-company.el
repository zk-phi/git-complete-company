(require 'git-complete)
(require 'company)

(defgroup git-complete-company nil
  "git-complete interface for company."
  :group 'git-complete-company)

(defcustom git-complete-company-manual-only t
  "When non-nil, git-complete-company backends only works when
  `company-explicit-action-p' is non-nil."
  :group 'git-complete-company
  :type 'boolean)

(defun git-complete-company--post-completion (arg)
  (let ((newline (string-match "\n" arg)))
    (when newline
      (funcall indent-line-function))
    (when git-complete-enable-autopair
      (save-excursion
        (git-complete--insert-close-paren-if-needed arg newline)))))

(defvar git-complete-company-whole-line-candidates nil)
(defun git-complete-company-whole-line-backend (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'git-complete-company-whole-line-backend))
    (prefix (and (derived-mode-p 'prog-mode)
                 (or (company-explicit-action-p) (not git-complete-company-manual-only))
                 (setq git-complete-company-whole-line-candidates
                       (git-complete--collect-whole-line-candidates
                        (git-complete--normalize-query (buffer-substring (point-at-bol) (point)))))
                 (buffer-substring (save-excursion (back-to-indentation) (point)) (point))))
    (require-match t)
    (sorted t)
    (post-completion (git-complete-company--post-completion arg))
    (candidates git-complete-company-whole-line-candidates)))

(defvar git-complete-company-omni-candidates nil)
(defun git-complete-company-omni-backend (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'git-complete-company-omni-backend))
    (prefix (and (derived-mode-p 'prog-mode)
                 (or (company-explicit-action-p) (not git-complete-company-manual-only))
                 (let* ((bol (point-at-bol))
                        (next-line-p (looking-back "^[\s\t]*" bol))
                        (no-leading-whitespaces (looking-back "[\s\t]" bol)))
                   (setq git-complete-company-omni-candidates
                         (git-complete--collect-omni-candidates
                          (save-excursion
                            (when next-line-p (forward-line -1) (end-of-line))
                            (git-complete--normalize-query (buffer-substring (point-at-bol) (point))))
                          next-line-p no-leading-whitespaces)))
                 ""))
    (require-match t)
    (sorted t)
    (post-completion (git-complete-company--post-completion arg))
    (candidates git-complete-company-omni-candidates)))

(provide 'git-complete-company)
