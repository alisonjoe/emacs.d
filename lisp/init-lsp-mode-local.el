;;; init-lsp-mode-local.el --- Support lsp-mode
;;; Commentary:
;;; Code:

(require-package 'lsp-mode)
(require-package 'lsp-ivy)
(require-package 'lsp-treemacs)
(require-package 'dap-mode)
(require-package 'helm-lsp)
(require-package 'projectile)

(dolist (hook '(python-mode-hook
                c++-mode-hook
                c-mode-hook
                rust-mode-hook
                html-mode-hook
                js-mode-hook
                typescript-mode-hook
                json-mode-hook
                yaml-mode-hook
                dockerfile-mode-hook
                shell-mode-hook
                css-mode-hook
                elisp-mode-hook
                go-mode-hook))
  (add-hook hook #'lsp-deferred)
  (add-hook hook #'yas-minor-mode))

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1
      lsp-log-io t)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode)
  (lsp-register-custom-settings
   '(("gopls.completeUnimported" t t)
     ("gopls.staticcheck" t t)
     ("gopls.usePlaceholders" t t))))

(lsp-treemacs-sync-mode t)

(setq lsp-auto-guess-root t)
(setq lsp-enable-text-document-color t)

(defun company-yasnippet/disable-after-dot (fun command &optional arg &rest _ignore)
  (if (eq command 'prefix)
      (let ((prefix (funcall fun 'prefix)))
        (when (and prefix (not (eq (char-before (- (point) (length prefix))) ?.)))
          prefix))
    (funcall fun command arg)))

(advice-add #'company-yasnippet :around #'company-yasnippet/disable-after-dot)

;; Ensure projectile is used to manage project switching
(projectile-mode +1)

;; Track the previous project
(defvar my/last-project nil)

(defun my/switch-project-hook ()
  "Hook to run when switching projects with projectile."
  (when (and my/last-project
             (not (string= my/last-project (projectile-project-root))))
    (lsp-workspace-shutdown))
  (setq my/last-project (projectile-project-root)))

(add-hook 'projectile-after-switch-project-hook 'my/switch-project-hook)

(provide 'init-lsp-mode-local)
;;; init-lsp-mode-local.el ends here
