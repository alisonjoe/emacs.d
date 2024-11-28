;;; lsp-mode -- Support lsp-mode
;;; Commentary:
;;; Code:

(require-package 'lsp-mode)
(require-package 'lsp-ivy)
(require-package 'lsp-treemacs)
(require-package 'dap-mode)
(require-package 'helm-lsp)
;; (require-package 'project)
;; (require-package 'eglot)

(add-hook 'python-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook #'lsp-deferred)
(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'rust-mode-hook #'lsp-deferred)
(add-hook 'html-mode-hook #'lsp-deferred)
(add-hook 'js-mode-hook #'lsp-deferred)
(add-hook 'typescript-mode-hook #'lsp-deferred)
(add-hook 'json-mode-hook #'lsp-deferred)
(add-hook 'yaml-mode-hook #'lsp-deferred)
(add-hook 'dockerfile-mode-hook #'lsp-deferred)
(add-hook 'shell-mode-hook #'lsp-deferred)
(add-hook 'css-mode-hook #'lsp-deferred)
(add-hook 'elisp-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'yas-minor-mode)

;; Company mode
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))

(lsp-treemacs-sync-mode t)

(setq lsp-auto-guess-root t)
(setq lsp-enable-text-document-color t)

(defun company-yasnippet/disable-after-dot (fun command &optional arg &rest _ignore)
  (if (eq command 'prefix)
      (let ((prefix (funcall fun 'prefix)))
        (when (and prefix (not
                           (eq
                            (char-before (- (point) (length prefix)))
                            ?.)))
          prefix))
    (funcall fun command arg)))

(advice-add #'company-yasnippet :around #'company-yasnippet/disable-after-dot)


;; (setq lsp-clients-python-command "${HOME}/.local/bin/pyls")
;; (setq lsp-clients-rust-command "${HOME}/.cargo/bin/rls")



(provide 'init-lsp-mode-local)
;;; init-lsp-mode-local.el ends here
