(set-frame-font "Meslo LG S DZ-11")

;; save edit place
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/saved-places")

;; tramp
(setq tramp-default-method "ssh")

;; Instant gratification for key strokes
(set 'echo-keystrokes -1)

;; Whitespace highlighting
(set 'whitespace-style '(trailing tab-mark face))
(global-whitespace-mode 1)

;; Magit - Git inside emacs is awesome -> `C-z s' or `M-x magit-status'
;; (setq magit-last-seen-setup-instructions "1.4.0") ; Hide message
;; (autoload 'magit-status "magit" nil t)

;; Auto Complete menus
(helm-mode 1)
(helm-autoresize-mode 1)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0.2)
(setq company-minimum-prefix-length 1)
(setq company-tooltip-align-annotations t)

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
(add-hook
 'c++-mode-hook
 '(lambda()
    ;; We could place some regexes into `c-mode-common-hook', but note that their evaluation order
    ;; matters.
    (font-lock-add-keywords
     nil '(;; complete some fundamental keywords
           ("\\<\\(void\\|unsigned\\|signed\\|char\\|short\\|bool\\|int\\|long\\|float\\|double\\)\\>" . font-lock-keyword-face)
           ;; namespace names and tags - these are rendered as constants by cc-mode
           ("\\<\\(\\w+::\\)" . font-lock-function-name-face)
           ;;  new C++11 keywords
           ("\\<\\(alignof\\|alignas\\|constexpr\\|decltype\\|noexcept\\|nullptr\\|static_assert\\|thread_local\\|override\\|final\\)\\>" . font-lock-keyword-face)
           ("\\<\\(char16_t\\|char32_t\\)\\>" . font-lock-keyword-face)
           ;; PREPROCESSOR_CONSTANT, PREPROCESSORCONSTANT
           ("\\<[A-Z]*_[A-Z_]+\\>" . font-lock-constant-face)
           ("\\<[A-Z]\\{3,\\}\\>"  . font-lock-constant-face)
           ;; hexadecimal numbers
           ("\\<0[xX][0-9A-Fa-f]+\\>" . font-lock-constant-face)
           ;; integer/float/scientific numbers
           ("\\<[\\-+]*[0-9]*\\.?[0-9]+\\([ulUL]+\\|[eE][\\-+]?[0-9]+\\)?\\>" . font-lock-constant-face)
           ;; c++11 string literals
           ;;       L"wide string"
           ;;       L"wide string with UNICODE codepoint: \u2018"
           ;;       u8"UTF-8 string", u"UTF-16 string", U"UTF-32 string"
           ("\\<\\([LuU8]+\\)\".*?\"" 1 font-lock-keyword-face)
           ;;       R"(user-defined literal)"
           ;;       R"( a "quot'd" string )"
           ;;       R"delimiter(The String Data" )delimiter"
           ;;       R"delimiter((a-z))delimiter" is equivalent to "(a-z)"
           ("\\(\\<[uU8]*R\"[^\\s-\\\\()]\\{0,16\\}(\\)" 1 font-lock-keyword-face t) ; start delimiter
           (   "\\<[uU8]*R\"[^\\s-\\\\()]\\{0,16\\}(\\(.*?\\))[^\\s-\\\\()]\\{0,16\\}\"" 1 font-lock-string-face t)  ; actual string
           (   "\\<[uU8]*R\"[^\\s-\\\\()]\\{0,16\\}(.*?\\()[^\\s-\\\\()]\\{0,16\\}\"\\)" 1 font-lock-keyword-face t) ; end delimiter

           ;; user-defined types (rather project-specific)
           ("\\<[A-Za-z_]+[A-Za-z_0-9]*_\\(type\\|ptr\\)\\>" . font-lock-type-face)
           ("\\<\\(xstring\\|xchar\\)\\>" . font-lock-type-face)))) t)

;; Default to c++11
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))

;; Auto insert main function
(add-hook 'find-file-hook (lambda () (when (and (stringp buffer-file-name)
                                           (let ((buf (file-name-nondirectory buffer-file-name)))
                                             (or (string-equal "main.c" buf)
                                                 (string-equal "main.cc" buf)))
                                           (equal (buffer-size) 0))
                                  (insert "int main() {\n\n}\n")
                                  (forward-line -2)
                                  (indent-for-tab-command))))

;; Auto include for `*.cc' files
(add-hook 'find-file-hook (lambda () (when (and (stringp buffer-file-name)
                                           (string-match "\\.cc\\'" buffer-file-name)
                                           (equal (buffer-size) 0))
                                  (let ((buf (file-name-nondirectory buffer-file-name)))
                                    (insert (concat "#include \""
                                                    (substring buf 0 (- (length buf) 3))
                                                    ".hh\"\n\n"))))))

;; Auto include for `*.c' files
(add-hook 'find-file-hook (lambda () (when (and (stringp buffer-file-name)
                                           (string-match "\\.c\\'" buffer-file-name)
                                           (equal (buffer-size) 0))
                                  (let ((buf (file-name-nondirectory buffer-file-name)))
                                    (insert (concat "#include \""
                                                    (substring buf 0 (- (length buf) 2))
                                                    ".h\"\n\n"))))))

;; Auto insert header guard for `*.hh' files
(add-hook 'find-file-hook (lambda () (when (and (stringp buffer-file-name)
                                           (string-match "\\.hh\\'" buffer-file-name)
                                           (equal (buffer-size) 0))
                                  (let ((buf (file-name-nondirectory buffer-file-name)))
                                    (let ((i (concat (substring (upcase buf) 0
                                                                (- (length buf) 3))
                                                     "_H")))
                                      (insert (concat "#ifndef HEADER_GUARD_" i
                                                      "\n#define HEADER_GUARD_" i
                                                      "\n\n\n\n#endif\n"))
                                      (forward-line -3))))))

;; Auto insert header guard for `*.h' files
(add-hook 'find-file-hook (lambda () (when (and (stringp buffer-file-name)
                                           (string-match "\\.h\\'" buffer-file-name)
                                           (equal (buffer-size) 0))
                                  (let ((buf (file-name-nondirectory buffer-file-name)))
                                    (let ((i (concat (substring (upcase buf) 0
                                                                (- (length buf) 2))
                                                     "_H")))
                                      (insert (concat "#ifndef HEADER_GUARD_" i
                                                      "\n#define HEADER_GUARD_" i
                                                      "\n\n\n\n#endif\n"))
                                      (forward-line -3))))))

;; Auto Markdown header
(add-hook 'find-file-hook (lambda () (when (and (stringp buffer-file-name)
                                           (string-equal "README.md" (file-name-nondirectory buffer-file-name))
                                           (equal (buffer-size) 0))
                                  (let ((fn (file-name-directory buffer-file-name)))
                                    (insert (concat "# " (file-name-nondirectory
                                                         (substring fn 0 (- (length fn) 1)))
                                                    "\n\n\n"))
                                    (forward-line -1)))))

;; globally enable multiple cursors
(global-evil-mc-mode 1)

(c-set-offset 'case-label '+)
(c-set-offset 'innamespace 0)
;; cwarn to check for errors
(add-hook 'c-mode-hook 'cwarn-mode)
(add-hook 'c++-mode-hook 'cwarn-mode)
;; Preprocessor highlighting
(add-hook 'c-mode-hook 'preproc-font-lock-mode)
(add-hook 'c++-mode-hook 'preproc-font-lock-mode)
;; Disassemble c/c++ code
(define-key c-mode-base-map (kbd "C-c d") 'disaster)
(add-hook 'llvm-mode-hook 'demangle-mode)

;; Forth files
(autoload 'forth-mode "gforth.el")
(setq auto-mode-alist (cons '("\\.fs\\'" . forth-mode) auto-mode-alist))
(autoload 'forth-block-mode "gforth.el")
(setq auto-mode-alist (cons '("\\.fb\\'" . forth-block-mode) auto-mode-alist))
(add-hook 'forth-mode-hook (function (lambda () (setq forth-indent-level 4))))

;; elisp-format
(set 'elisp-format-column 80)

;; Haskell indentation
(add-hook 'haskell-mode-hook 'turn-on-hi2)

;; Rust
(add-hook 'rust-mode-hook
          '(lambda (racer-mode 1)
             (eldoc-mode 1)
             (company-mode 1)
             (local-set-key (kbd "C-,") 'racer-find-definition)))
(add-hook 'rust-mode-hook 'cargo-minor-mode)

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

;; Fill-Column Indicator for all files
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode)
(set 'fci-rule-width 2)
(set 'fci-rule-color "red")
(set 'fci-handle-truncate-lines nil)
;; disable for certain modes
(add-hook 'text-mode-hook 'turn-off-fci-mode)
(add-hook 'haskell-mode-hook 'turn-off-fci-mode)
(add-hook 'help-mode-hook 'turn-off-fci-mode)

;; Fill code
(add-hook 'c-mode-common-hook 'fillcode-mode)
(add-hook 'perl-mode-hook 'fillcode-mode)
(add-hook 'shell-script-mode-hook 'fillcode-mode)

;; Rainbow delimeters
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Highlight current line
(highlight-current-line-on t)

;; Highlight quoted
(add-hook 'lisp-mode-hook       'highlight-quoted-mode)
(add-hook 'emacs-lisp-mode-hook 'highlight-quoted-mode)

;; Paredit
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'evil-paredit-mode)

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
