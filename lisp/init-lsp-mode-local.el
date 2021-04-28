;;; lsp-mode -- Support lsp-mode
;;; Commentary:
;;; Code:

(require-package 'lsp-mode)
(require-package 'lsp-ui)
(require-package 'lsp-ivy)
(require-package 'lsp-treemacs)
(require-package 'dap-mode)
(require-package 'helm-lsp)
;; (require-package 'company-lsp)
;; (require-package 'project)
;; (require-package 'eglot)


(lsp-treemacs-sync-mode 1)

(setq lsp-auto-guess-root t)

(setq lsp-enable-text-document-color t)

(add-hook 'go-mode-hook #'lsp-deferred)
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


(setq lsp-ui-sideline-ignore-duplicate t)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)


(setq lsp-enable-indentation t)
(setq lsp-ui-mode t)
(setq lsp-ui-doc-enable nil)
(setq lsp-ui-doc-header t)
(setq lsp-ui-doc-include-signature t)
(setq lsp-ui-doc-position 'top) ;; top, bottom, or at-point
;; (setq lsp-ui-doc-max-width 120)
;; (setq lsp-ui-doc-max-height 60)
(setq lsp-ui-doc-use-childframe t)
(setq lsp-ui-doc-use-webkit t)
;; 增大垃圾回收的阈值，提高整体性能（内存换效率）
(setq gc-cons-threshold (* 8192 8192))
;; 增大同LSP服务器交互时的读取文件的大小
(setq read-process-output-max (* 1024 1024 1280)) ;; 1280MB

;; (setq lsp-enable-snippet t)
;; (setq lsp-keep-workspace-alive t)
;; (setq lsp-enable-xref t)
;; (setq lsp-enable-imenu t)
;; (setq lsp-enable-completion-at-point nil)

(setq lsp-clients-python-command "${HOME}/.local/bin/pyls")
(setq lsp-clients-rust-command "${HOME}/.cargo/bin/rls")
(setq lsp-clients-go-command "${HOME}/3rd/gopath/bin/gopls")

;; (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-deferred-ui-peek-find-definitions)
;; (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-deferred-ui-peek-find-references)

;; if you want to change prefix for lsp-mode keybindings.
;; (setq lsp-keymap-prefix "s-l")

;; (setq lsp-eldoc-enable-hover nil)
(setq lsp-eldoc-render-all t)

(add-hook 'dap-stopped-hook
               (lambda (arg) (call-interactively #'dap-hydra)))



(provide 'init-lsp-mode-local)
;;; init-lsp-mode-local.el ends here
