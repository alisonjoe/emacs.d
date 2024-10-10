;;; init-lsp-mode-local.el --- Support lsp-mode
;;; Commentary:
;;; Code:

(require-package 'lsp-mode)
(require-package 'lsp-ivy)
(require-package 'lsp-treemacs)
(require-package 'dap-mode)
(require-package 'helm-lsp)
(require-package 'projectile)

;; 设置在需要时才启动 LSP
(defun my/lsp-init-on-demand ()
  "Initialize LSP mode on demand."
  (when (and (buffer-file-name)
             (buffer-live-p (current-buffer))
             (not (lsp-workspaces)))
    (condition-case err
        (lsp-deferred)
      (error (message "Error initializing LSP: %s" (error-message-string err))))))

;; 在需要时启动 LSP
(dolist (hook '(find-file-hook))
  (add-hook hook 'my/lsp-init-on-demand))

;; 延迟恢复的缓冲区加载
(setq desktop-restore-eager 5)

;; 提高恢复速度
(setq desktop-restore-frames nil)
(setq desktop-restore-reuses-frames t)

;; 启动相应 mode 时启动 yasnippet
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

;; 优化垃圾回收和进程输出读取
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
     ("gopls.usePlaceholders" t t)))
  (setq lsp-language-id-configuration (append lsp-language-id-configuration
                                              '((emacs-lisp-mode . "emacs-lisp")))))

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

;; 确保 projectile 用于管理项目切换
(projectile-mode +1)

;; 跟踪上一个项目
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
