;;; C-c commands
;; Show unsaved edits
(global-unset-key (kbd "C-c d"))
(global-set-key (kbd "C-c d") 'diff-buffer-with-current-file)
;; Show git status
(global-unset-key (kbd "C-c s"))
(global-set-key (kbd "C-c s") 'magit-status)
;; Terminal
(global-unset-key (kbd "C-c t"))
(global-set-key (kbd "C-c t") 'term)


;; Move current line (where Point is) down one
(global-unset-key (kbd "M-n"))
(global-set-key (kbd "M-n") 'move-line-down)
;; Move current line (where Point is) down one
(global-unset-key (kbd "M-p"))
(global-set-key (kbd "M-p") 'move-line-up)

;; rebind `C-,' to vim style `o'
;; rebind `C-.' to vim styoe `O'
(global-unset-key (kbd "C-,"))
(global-set-key (kbd "C-,")        'vim-style-o)

(global-unset-key (kbd "C-."))
(global-set-key (kbd "C-.")        'vim-style-capital-o)

;; Unbind `C-z' as its annoying
(global-unset-key (kbd "C-z"))

;; `C-a' bound to beginning of text (vim ^)
;; `C-S-a' bound to beginning of line (vim 0)
(global-unset-key (kbd "C-a"))
(global-set-key (kbd "C-a") 'beginning-of-line-text)
(global-unset-key (kbd "C-S-a"))
(global-set-key (kbd "C-S-a") 'move-beginning-of-line)

;; `C-k' acts `dd' instead of until end of line
;; `C-S-k' maintains old behavior
(global-set-key (kbd "C-k") 'kill-whole-line)
(global-set-key (kbd "C-S-k") 'kill-line)

;; `C-;' kills to start of text
;; `C-:' kills to start of line
(global-set-key (kbd "C-;") 'kill-start-of-text)
(global-set-key (kbd "C-:") 'kill-start-of-line)

;; Hyper modifiers that make life easier
(global-set-key (kbd "H-c") 'comment-line)
(global-set-key (kbd "H-u") 'uncomment-line)
(global-set-key (kbd "H-q") 'delete-window)
(global-set-key (kbd "H-v") 'split-window-right)
(global-set-key (kbd "H-h") 'split-window-below)

(provide 'init-mappings)
