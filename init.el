(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (tango-dark)))
 '(inhibit-startup-screen t)
 '(lsp-terraform-enable-logging nil)
 '(lsp-terraform-server "/usr/bin/terraform-ls")
 '(package-selected-packages
   (quote
    (yasnippet-snippets dap-mode lsp-ui yasnippet which-key use-package terraform-mode multiple-cursors magit dumb-jump bash-completion auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;PACKAGE MANAGER
;; Package manager
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Use package install
(dolist (package '(use-package))
  (unless (package-installed-p package)
    (package-install package)))
;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; LOOK
(tool-bar-mode -1)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)


;;;;;;;;;;;;;;

;;;;;;;;;;;;;; SORT and EASE OF USE

;; Move backups
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))


;; y and n
(fset 'yes-or-no-p 'y-or-n-p)


;;whichkey
(use-package which-key
  :ensure t)
(which-key-mode)
;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;; NAVIGATION

(global-set-key (kbd "M-RET") 'newline)

;; Open file
(global-set-key [f2] 'find-file)

;; Open file in new window
(global-set-key [f3] 'find-file-other-window)

;; Close window

(global-set-key (kbd "C-<end>") 'kill-buffer-and-window)
(global-set-key (kbd "C-<home>") 'kill-this-buffer)
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;Dumb Jump
;; (use-package xref
;;   :ensure t)

(use-package dumb-jump
  :bind (("C-=" . dumb-jump-go-other-window)
	 ([f12] . dumb-jump-go )
	 ([f11] . dumb-jump-back))
  :ensure t)

;; (add-to-list 'xref-backend-functions 'dumb-jump-xref-activate t)
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;IDO
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(ido-mode t)
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;; registers

(global-set-key [f4] 'jump-to-register)
(set-register ?w '(file . "/home/dylan/Dev/work/defra/"))
(set-register ?d '(file . "/home/dylan/Dev/"))

;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; terminal

(defun term-other-window ()
  (interactive)
  (let ((buf (term "/bin/zsh")))
    (switch-to-buffer (other-buffer buf))
    (switch-to-buffer-other-window buf)))

(global-set-key [f1] 'term-other-window)

;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;AUTO FILES
;; Move backups
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))


;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;MUTLIPLE CURSORS
(use-package multiple-cursors
  :ensure t)


(global-set-key (kbd "C-\"") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)

(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-?") 'mc/mark-all-like-this)

;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;ORG MODE
;; Auto indent when paste
(defun paste-with-indent ()
  (interactive)
  (when (region-active-p)
  (call-interactively 'delete-region))
  (call-interactively 'cua-paste)
  (indent-org-block))

(define-key cua--cua-keys-keymap (kbd "C-v") 'paste-with-indent)
;; Shift select org
(setq org-support-shift-select t)


;; Org source code colour
(require 'color)
;;;;;;;;;;;;;;


;;;;;;;;;;;;;; README
;; README MODE

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
;;;;;;;;;;;;;;




;;;;;;;;;;;;;; LSP


(use-package lsp-mode
  :defer t
  :commands lsp
  :custom
  (lsp-keymap-prefix "C-x l")
  (lsp-auto-guess-root nil)
  (lsp-prefer-flymake nil) ; Use flycheck instead of flymake
  (lsp-enable-file-watchers nil)
  (lsp-enable-folding nil)
  (read-process-output-max (* 1024 1024))
  (lsp-keep-workspace-alive nil)
  (lsp-eldoc-hook nil)
  :config
  (lsp-register-client
  (make-lsp-client :new-connection (lsp-stdio-connection '("/usr/bin/terraform-ls" "serve"))
		    :major-modes '(terraform-mode)
		    :server-id 'terraform-lsp))
  :bind (:map lsp-mode-map ("C-c C-f" . lsp-format-buffer))
  :hook ((java-mode python-mode go-mode rust-mode
          js-mode js2-mode typescript-mode web-mode
          c-mode c++-mode objc-mode terraform-mode) . lsp-deferred)
  :config
  (defun lsp-update-server ()
    "Update LSP server."
    (interactive)
    ;; Equals to `C-u M-x lsp-install-server'
    (lsp-install-server t)))

;; (use-package lsp-mode
;;   :commands (lsp lsp-deferred)
;;   :init (setq lsp-keymap-prefix "C-c l")
;;   :config
;;   (lsp-enable-which-key-integration t)
;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-stdio-connection '("/usr/bin/terraform-ls" "serve"))
;;   ;; (make-lsp-client :new-connection (lsp-stdio-connection '("/home/dylan/terraform-lsp" "serve"))
;; 		    :major-modes '(terraform-mode)
;; 		    :server-id 'terraform-lsp)))
;; ;; (setq lsp-terraform-enable-logging t)
;; ;; (setq lsp-log-io nil)
;; ;; (setq lsp-modeline-diagnostics-enable t)

(use-package lsp-ui
  :ensure t
  ;; :requires flycheck
  ;; :after lsp-mode
  )
;; (setq lsp-ui-imenu-auto-refresh t)


;; ;; Dap Mode

;; (use-package dap-mode
;;   :ensure t)


;;;;;;;;;;;;;;; ;;COMPANY MODE
(use-package company
  :ensure t)
(add-hook 'after-init-hook 'global-company-mode)

;; Terraform

(use-package terraform-mode
  :ensure t
  ;; :hook (terraform-mode . lsp-deferred)
  )

(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

(use-package hcl-mode
  :ensure t)



;;;;;;;;;;;;;;



;; ;;;;;;;;;;;;;; FLYCHECK
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )

;; (flycheck-define-checker tflint
;;   "Terraform linter tflint"
;;   :command ("tflint"
;;             source-inplace)
;;   :error-parser flycheck-parse-checkstyle
;;   :error-filter flycheck-dequalify-error-ids
;;   :modes (terraform-mode))
;; (add-to-list 'flycheck-checkers 'tflint)


;;;;;;;;;;;;;;


;;;;;;;;;;;;;;; KILL WORD BACKSPACE


(defun aborn/backward-kill-word ()
  "Customize/Smart backward-kill-word."
  (interactive)
  (let* ((cp (point))
         (backword)
         (end)
         (space-pos)
         (backword-char (if (bobp)
                            ""           ;; cursor in begin of buffer
                          (buffer-substring cp (- cp 1)))))
    (if (equal (length backword-char) (string-width backword-char))
        (progn
          (save-excursion
            (setq backword (buffer-substring (point) (progn (forward-word -1) (point)))))
          (setq ab/debug backword)
          (save-excursion
            (when (and backword          ;; when backword contains space
                       (s-contains? " " backword))
              (setq space-pos (ignore-errors (search-backward " ")))))
          (save-excursion
            (let* ((pos (ignore-errors (search-backward-regexp "\n")))
                   (substr (when pos (buffer-substring pos cp))))
              (when (or (and substr (s-blank? (s-trim substr)))
                        (s-contains? "\n" backword))
                (setq end pos))))
          (if end
              (kill-region cp end)
            (if space-pos
                (kill-region cp space-pos)
              (backward-kill-word 1))))
      (kill-region cp (- cp 1)))         ;; word is non-english word
    ))

(global-set-key  [C-backspace]
            'aborn/backward-kill-word)

;;;;;;;;;;;;;;; END KILL WORD BACKSPACE

;;;;;;;;;;;;;;; YASnippet

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :init
  (use-package yasnippet-snippets :after yasnippet :ensure t)
  :hook ((prog-mode LaTeX-mode org-mode) . yas-minor-mode)
  :bind
  (:map yas-minor-mode-map ("C-c C-n" . yas-expand-from-trigger-key))
  (:map yas-keymap
        (("TAB" . smarter-yas-expand-next-field)
         ([(tab)] . smarter-yas-expand-next-field)))
  :config
  (yas-reload-all)
  (defun smarter-yas-expand-next-field ()
    "Try to `yas-expand' then `yas-next-field' at current cursor position."
    (interactive)
    (let ((old-point (point))
          (old-tick (buffer-chars-modified-tick)))
      (yas-expand)
      (when (and (eq old-point (point))
                 (eq old-tick (buffer-chars-modified-tick)))
        (ignore-errors (yas-next-field))))))

;;;;;;;;;;;;;;; END YASnippet




