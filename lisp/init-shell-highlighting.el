(defun sh-script-extra-font-lock-match-var-in-double-quoted-string (limit)
  "Search for variables in double-quoted strings."
  (let (res)
    (while
        (and (setq res (progn (if (eq (get-byte) ?$) (backward-char))
                              (re-search-forward
                               "[^\\\\]\\$\\({#?\\)?\\([[:alpha:]_][[:alnum:]_]*\\|[-#?@!]\\|[[:digit:]]+\\)"
                               limit t)))
             (not (eq (nth 3 (syntax-ppss)) ?\")))) res))

(defvar sh-script-extra-font-lock-keywords
  '((sh-script-extra-font-lock-match-var-in-double-quoted-string
     (2 font-lock-variable-name-face prepend))))

(defun sh-script-extra-font-lock-activate ()
  (interactive)
  (font-lock-add-keywords nil sh-script-extra-font-lock-keywords)
  (if (fboundp 'font-lock-flush)
      (font-lock-flush)
    (when font-lock-mode (with-no-warnings (font-lock-fontify-buffer)))))

(add-hook 'sh-mode-hook     'sh-script-extra-font-lock-activate)
(add-hook 'perl-mode-hook   'sh-script-extra-font-lock-activate)
(add-hook 'python-mode-hook 'sh-script-extra-font-lock-activate)

(provide 'init-shell-highlighting)