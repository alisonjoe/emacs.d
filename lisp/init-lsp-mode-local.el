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

;; 辅助工具
(use-package lsp-ivy :ensure t)
(use-package lsp-treemacs :ensure t)
(use-package helm-lsp :ensure t)
(use-package yasnippet
  :ensure t
  :config (yas-global-mode 1))

;; 调试工具
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-ui-mode)
  (dap-tooltip-mode)
  (tooltip-mode 1)
  (dap-ui-controls-mode 1))

;; 通用设置
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      lsp-idle-delay 0.1
      lsp-log-io nil
      lsp-auto-guess-root t
      lsp-enable-text-document-color t
      treemacs-space-between-root-nodes nil)


;; LSP 模式及其依赖
(use-package lsp-mode
  :ensure t
  :hook ((python-mode
          c++-mode
          c-mode
          rust-mode
          html-mode
          js-mode
          typescript-mode
          json-mode
          yaml-mode
          dockerfile-mode
          shell-mode
          css-mode
          elisp-mode
          go-mode
          protobuf-mode) . lsp-deferred)
  :commands lsp-deferred
  :config
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (lsp-treemacs-sync-mode 1)
  ;; 自定义设置
  (lsp-register-custom-settings
   '(("gopls.completeUnimported" t t)
     ("gopls.staticcheck" t t)
     ("gopls.usePlaceholders" t t)))        )


;; 支持 protobuf-mode
(use-package protobuf-mode
        :ensure t
        :mode ("\\.proto\\'" . protobuf-mode)
        :config
        (add-hook 'protobuf-mode-hook 'lsp-deferred))

;; 注册 Protobuf 的 bufls 支持
(use-package lsp-mode
  :config
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "bufls")
    :major-modes '(protobuf-mode)
    :server-id 'bufls)))

;; 各语言调试后端
(use-package dap-go
  :ensure nil
  :after dap-mode
  :config
  (setq dap-go-dlv-path (executable-find "dlv")))

(use-package dap-cpptools
  :ensure nil
  :after dap-mode
  :config
  (setq dap-cpptools-debug-path (executable-find "OpenDebugAD7")))

(use-package dap-python
  :ensure nil
  :after dap-mode
  :config
  (setq dap-python-debugger 'debugpy)
  (setq dap-python-executable "python3")) ;; 根据需要调整路径

;; Projectile 支持
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  ;; 追踪项目切换
  (defvar my/last-project nil)
  (defun my/switch-project-hook ()
    "关闭上一个项目的 LSP 工作空间。"
    (when (and my/last-project
               (not (string= my/last-project (projectile-project-root))))
      (lsp-workspace-shutdown))
    (setq my/last-project (projectile-project-root)))
  (add-hook 'projectile-after-switch-project-hook 'my/switch-project-hook))

;; 动态启用/禁用鼠标功能
(defun enable-mouse ()
  "启用鼠标操作功能。"
  (xterm-mouse-mode 1)
  (message "Mouse enabled for debugging."))

(defun disable-mouse ()
  "禁用鼠标操作功能。"
  (xterm-mouse-mode -1)
  (message "Mouse disabled after debugging."))

(add-hook 'dap-session-created-hook #'enable-mouse)
(add-hook 'dap-terminated-hook #'disable-mouse)

(setq large-file-warning-threshold (* 1 1024 1024)) ;; 超过 1MB 文件时触发警告

(defun my/skip-large-files ()
  "在打开大文件时禁用不必要的功能。"
  (when (> (buffer-size) large-file-warning-threshold)
    (setq buffer-read-only t) ;; 设置为只读
    (fundamental-mode)))     ;; 切换到基础模式

(add-hook 'find-file-hook 'my/skip-large-files)

(defvar my/desktop-restoring nil
  "标记是否正在进行 Desktop 恢复。")

(defun my/desktop-read-start ()
  "标记 Desktop 恢复开始。"
  (setq my/desktop-restoring t))

(defun my/desktop-read-end ()
  "标记 Desktop 恢复结束。"
  (setq my/desktop-restoring nil))

(add-hook 'desktop-before-read-hook 'my/desktop-read-start)
(add-hook 'desktop-after-read-hook 'my/desktop-read-end)

(defun my/disable-lsp-during-desktop-restore (orig-fun &rest args)
  "在 Desktop 恢复期间禁用 LSP。"
  (if my/desktop-restoring
      (let ((find-file-hook nil)) ;; 暂时禁用 find-file-hook
        (apply orig-fun args))
    (apply orig-fun args)))

(advice-add 'desktop-read :around #'my/disable-lsp-during-desktop-restore)



(provide 'init-lsp-mode-local)
;;; init-lsp-mode-local.el ends here
