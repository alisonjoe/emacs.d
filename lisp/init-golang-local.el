;;; init-golang-local.el --- Support golang
;;; Commentary:
;;; Code:

(require 'package)

(eval-when-compile
  (require 'use-package))

;; 强制禁用全局加载
(setq-default go-mode-hook nil)
(setq-default lsp-mode-hook nil)
;; 配置 Go 相关包
(use-package go-mode
  :ensure t
  :mode "\\.go\\'"
  :hook ((go-mode . gorepl-mode)
         (go-mode . go-eldoc-setup)
         (go-mode . go-guru-hl-identifier-mode))
  :bind (("C-c C-r" . go-remove-unused-imports)
         ("C-c C-g" . go-goto-imports)
         ("C-c C-f" . gofmt)
         ("C-c C-k" . godoc))
  :config
  (setq gofmt-command "goimports"))


(use-package go-tag
  :ensure t
  :bind (("C-c t" . go-tag-add)
         ("C-c s" . alison-go-tag-add)
         ("C-c T" . go-tag-remove))
  :config
  (setq go-tag-args (list "-transform" "snakecase")))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq flycheck-golangci-lint-config "~/.emacs.d/conf/.golangci.yml"
        flycheck-golangci-lint-deadline "10m"
        flycheck-gometalinter-vendor t
        flycheck-gometalinter-enable-linters '("golangci-lint")
        flycheck-gometalinter-deadline "10s"
        flycheck-gometalinter-config "~/.emacs.d/config/.gometalinter-config.json")
  (eval-after-load 'flycheck
    '(add-hook 'go-mode-hook #'flycheck-golangci-lint-setup)))
(add-hook 'go-mode-hook (lambda () (flymake-mode -1)))


(use-package go-gen-test
  :ensure t)

(use-package gotest
  :ensure t
  :config
  (setq go-test-args "-gcflags=all=-l"))

(use-package go-dlv
  :ensure t)

(use-package gorepl-mode
  :ensure t
  :hook (go-mode . gorepl-mode))

(use-package go-eldoc
  :ensure t
  :hook (go-mode . go-eldoc-setup))

(use-package go-guru
  :ensure t
  :hook (go-mode . go-guru-hl-identifier-mode))

(use-package go-stacktracer
  :ensure t)

(use-package go-fill-struct
  :ensure t)

(use-package go-impl
  :ensure t)

(use-package go-imports
  :ensure t)

(use-package golint
  :ensure t)

(use-package go-gopath
  :ensure t)

(use-package flycheck-golangci-lint
  :ensure t)

(use-package flycheck-gometalinter
  :ensure t)

(defun my-gofmt-s-r ()
  "Run gofmt with -s and -r 'interface{} -> any' on the current buffer if it's a Go file."
  (when (eq major-mode 'go-mode)
    (shell-command-to-string (format "gofmt -s -r 'interface{} -> any' -w %s" (buffer-file-name)))
    (revert-buffer t t t)))

(defun my-gofmt-and-goimports ()
  "Run gofmt with -s and -r 'interface{} -> any', then run goimports if it's a Go file."
  (when (eq major-mode 'go-mode)
    (my-gofmt-s-r)
    (gofmt)
    (save-buffer))) ;; 保存文件

(defun my-gofmt-and-goimports-after-save ()
  "Run gofmt and goimports after saving the file."
  (add-hook 'after-save-hook #'my-gofmt-and-goimports nil t))

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'my-gofmt-and-goimports-after-save nil t)))




(defun run-go-mod-tidy ()
  "Run `go mod tidy` synchronously in the current project if it's a Go file."
  (when (eq major-mode 'go-mode)
    (let ((default-directory (file-name-directory buffer-file-name)))
      (call-process "go" nil nil nil "mod" "tidy"))))




;; (defun maple/go-auto-comment ()
;;   "Automatically add comments to Go code using gocmt and GPTel."
;;   (interactive)
;;   (let ((gocmt-command (concat "gocmt -i " buffer-file-name)))
;;     (shell-command-on-region (point-min) (point-max) gocmt-command)
;;     ;; Call gptel-send-region to generate comments using GPT
;;     (gptel-send-region (point-min) (point-max))))


(defun maple/go-auto-comment ()
  "Automatically add comments to Go code using gocmt and GPTel."
  (interactive)
  (let ((gocmt-command (concat "gocmt -i " buffer-file-name)))
    (shell-command-on-region (point-min) (point-max) gocmt-command)
    ;; 使用 GPTel 包生成评论
    (let ((comment-prompt (concat "Please add comments to the following Go code:\n\n"
                                  (buffer-substring-no-properties (point-min) (point-max)))))
      (gptel-send
       comment-prompt
       (lambda (response)
         (message "comment-prompt: %s\ngpt-response: %s" comment-prompt response)
         (save-excursion
           (goto-char (point-max))
           (insert "\n\n" response)))))))

;; 绑定函数到快捷键或添加到 Go 模式钩子中
(add-hook 'go-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-c") 'maple/go-auto-comment)))

(defun alison-go-tag-add (n)
  "Please select type for TRANSFORM."
  (interactive "nSelect transform 1->base_domain 2->baseDomain 3->base-domain 4->BaseDomain: ")
  (setq go-tag-args (list "-transform"
                          (pcase n
                            (1 "snakecase")
                            (2 "camelcase")
                            (3 "lispcase")
                            (4 "keep")))))

(message "init-golang-local loaded successfully!")
(provide 'init-golang-local)
;;; init-golang-local.el ends here
