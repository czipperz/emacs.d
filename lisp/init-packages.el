(set-frame-font "Meslo LG S DZ-11")

;; Magit - Git inside emacs is awesome -> `C-z s' or `M-x magit-status'
(setq magit-last-seen-setup-instructions "1.4.0") ; Hide message
(autoload 'magit-status "magit" nil t)

;; Auto Complete menus
(helm-mode 1)
(helm-autoresize-mode 1)
(add-hook 'after-init-hook 'global-company-mode)

;; Auto Complete for text
;(ac-config-default)

;; Auto match parens (highlight)
(show-smartparens-global-mode)

;; Line numbers
(global-linum-mode)
;; Fringe style for graphical mode
(set-fringe-style 0)
(setq linum-format "%d")

;; 4 spaces for c languages
(setq c-basic-offset 4
      c-default-style "stroustrup")
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))
(c-set-offset 'case-label '+)

;; cwarn to check for errors
(add-hook 'c-mode-hook 'cwarn-mode)

;; Preprocessor highlighting
(add-hook 'c++-mode-hook 'preproc-font-lock-mode)

;; Haskell indentation
(add-hook 'haskell-mode-hook 'turn-on-hi2)

;; Yasnippet
;; (yas-global-mode 1)

(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))
            (ibuffer-do-sort-by-vc-status)))

(setq ibuffer-formats '((mark modified read-only vc-status-mini
                              " "
                              (name 18 18 :left :elide)
                              " "
                              (size 9 -1 :right)
                              " "
                              (mode 16 16 :left :elide)
                              " "
                              (vc-status 16 16 :left)
                              " "
                              filename-and-process)))

;; Rainbow delimeters
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Highlight current line
(highlight-current-line-on t)

;; Highlight quoted
(add-hook 'lisp-mode-hook       'highlight-quoted-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-quoted-mode)

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'toggle-word-wrap)

;; Markdown config
(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Chrome edit server
(when (daemonp)
  (edit-server-start)
  (message "Edit Server for Chrome up"))

(put 'set-goal-column 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(add-hook 'after-init-hook 'global-flycheck-mode)

(projectile-global-mode)
(setq projectile-keymap-prefix (kbd "C-c p"))

(global-ede-mode)

(provide 'init-packages)
