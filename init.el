;; default

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (tango-dark)))
 '(inhibit-startup-screen t)
 '(org-startup-truncated nil)
 '(package-selected-packages
   (quote
    (flycheck terraform-mode multiple-cursors use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-block ((t (:background "#1e2424"))))
 '(org-block-begin-line ((t (:underline "#181c1c" :foreground "#465252" :background "#181c1c"))))
 '(org-block-end-line ((t (:overline "#181c1c" :foreground "#465252" :background "#181c1c")))))





;; Package manager
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Use package install
(dolist (package '(use-package))
  (unless (package-installed-p package)
    (package-install package)))

;; Move backups
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

;; Disable toolbar (copy, paste etc)
(tool-bar-mode -1)


;; Interactive commands (maybe replace with helm)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(ido-mode t)

;; Multiple cursors
(use-package multiple-cursors
  :ensure t)


(global-set-key (kbd "C-\"") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-?") 'mc/mark-all-like-this)

;; TODO org fix shift select with CUA conflict


;; Terraform and HCL
(use-package terraform-mode
  :ensure t)
(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

(use-package hcl-mode
  :ensure t)


;; (custom-set-variables
;;  '(hcl-indent-level 4))




;; Auto indent every 10 secs
;; (defun indent-org-block-automatically ()
;;   (when (org-in-src-block-p)
;;    (org-edit-special)
;;     (indent-region (point-min) (point-max))
;;     (org-edit-src-exit)))

;; (run-at-time 1 10 'indent-org-block-automatically)

;; Auto indent when paste
(defun indent-org-block ()
  ;; (when (org-in-src-block-p)
  (org-edit-special)
  (indent-region (point-min) (point-max))
  (org-edit-src-exit))

(defun paste-with-indent ()
  (interactive)
  (when (region-active-p)
  (call-interactively 'delete-region))
  (call-interactively 'cua-paste)
  (indent-org-block))


(define-key cua--cua-keys-keymap (kbd "C-v") 'paste-with-indent)


;; Maybe assign to all
;; (use-package org
;;   :bind (:map org-mode-map
;; 	      ("C-v" . paste-with-indent)))



;; (defvar indent-paste-mode
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map (kbd "C-p") 'some-function)
;;     map)
;;   "indent-paste-mode keymap.")

;; (define-minor-mode indent-paste-mode
;;   "A minor mode so that my key settings override annoying major modes."
;;   :init-value t
;;   :lighter " my-keys")

;; (indent-paste-mode 1)

;; (define-key (org-mode-map
;;   (kbd "<tab>") #'udf/indent-org-block)


;; Aggressive Indent Mode
;; (use-package aggressive-indent
;;   :ensure t)

;; (global-aggressive-indent-mode 1)


;; Org mode
;; Shift select org
(setq org-support-shift-select t)

;; Open all titles
;(setq org-startup-folded nil)

;; Org source code colour
(require 'color)




;; Syntax checker (may need fixing on mac)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))



;; Word wrap

;; (toggle-truncate-lines -1)
;; (setq-default truncate-lines nil)
;; (setq truncate-partial-width-windows nil)
;; (add-hook 'org-mode-hook 'toggle-truncate-lines-off)

;;(add-hook 'hack-local-variables-hook #'toggle-truncate-lines-off)

;; Numbered lines
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
