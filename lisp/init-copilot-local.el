;;; init-copilot-local.el --- Support copilot
;;; Commentary:
;;; Code:

(add-to-list 'load-path
        (expand-file-name (concat user-emacs-directory "lisp/copilot.el")))
(require 'copilot)

(use-package editorconfig
        :ensure t
        :config
        (editorconfig-mode 1))

;; 最大字符限制
(defvar copilot-max-characters 5000
        "The maximum number of characters in a buffer before disabling Copilot.")

(defun maybe-disable-copilot ()
        "Disable Copilot if the buffer size exceeds `copilot-max-characters`."
        (if (> (buffer-size) copilot-max-characters)
                (progn
                        (copilot-mode -1)
                        (message "Copilot disabled for large buffer (%d characters)." (buffer-size)))
                (copilot-mode 1))) ;; 启用 Copilot，确保小文件可以正常运行

;; 在 prog-mode 中动态检测文件大小
(add-hook 'prog-mode-hook 'maybe-disable-copilot)

;; 完成顺序：优先使用 Copilot，其次是 auto-complete
(defun my-tab ()
        "Try accepting Copilot completion; fallback to auto-complete."
        (interactive)
        (or (copilot-accept-completion)
                (ac-expand nil)))

;; 禁用 auto-complete 的 inline 提示
(with-eval-after-load 'auto-complete
        (setq ac-disable-inline t)
        (setq ac-candidate-menu-min 0))

;; 绑定 TAB 键
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

(add-hook 'prog-mode-hook
        (lambda ()
                (local-set-key (kbd "TAB") 'my-tab)
                (local-set-key (kbd "<tab>") 'my-tab)))

(provide 'init-copilot-local)
;;; init-copilot-local.el ends here
