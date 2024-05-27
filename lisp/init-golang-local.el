;;; init-golang-local.el --- Support golang
;;; Commentary:
;;; Code:

(require-package 'go-mode)
(require-package 'go-tag)
(require-package 'go-stacktracer)
(require-package 'go-errcheck)
(require-package 'go-fill-struct)
(require-package 'go-impl)
(require-package 'go-imports)
(require-package 'go-guru)
(require-package 'go-eldoc)
(require-package 'go-gen-test)
(require-package 'gotest)
(require-package 'go-projectile)
(require-package 'golint)
(require-package 'go-gopath)
(require-package 'flycheck-golangci-lint)
(require-package 'flycheck-gometalinter)
(require-package 'go-dlv)
(require-package 'gorepl-mode)

(ac-config-default)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(global-flycheck-mode)
(with-eval-after-load 'go-mode
  (autoload 'flycheck-get-checker-for-buffer "golint")
  (autoload 'flycheck-get-checker-for-buffer "govet")
  (autoload 'flycheck-get-checker-for-buffer "flycheck"))

(setq flycheck-golangci-lint-config "~/.emacs.d/conf/.golangci.yml")
(setq flycheck-golangci-lint-deadline "10m")
(eval-after-load 'flycheck
  '(add-hook 'go-mode-hook #'flycheck-golangci-lint-setup))

(setq flycheck-gometalinter-vendor t)
(setq flycheck-gometalinter-enable-linters '("golangci-lint"))
(setq flycheck-gometalinter-deadline "10s")
(setq flycheck-gometalinter-config "~/.emacs.d/config/.gometalinter-config.json")

(add-hook 'go-mode-hook '(lambda ()
                           (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
                           (local-set-key (kbd "C-c C-g") 'go-goto-imports)
                           (local-set-key (kbd "C-c C-f") 'gofmt)
                           (local-set-key (kbd "C-c C-k") 'godoc)))

(setq gofmt-command "goimports")
(setq gofmt-args '("-local" "git.code.oa.com"))

(defun run-go-mod-tidy ()
  "Run `go mod tidy` in the current project."
  (when (string-equal major-mode 'go-mode)
    (shell-command "go mod tidy")))

(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'before-save-hook 'run-go-mod-tidy)

(setq go-test-args "-gcflags=all=-l")

(defun maple/go-auto-comment()
  (interactive)
  (setq gocmt (concat "gocmt -i " buffer-file-name))
  (shell-command-on-region (point-min) (point-max) gocmt))

(setq go-tag-args (list "-transform" "snakecase"))

(defun alison-go-tag-add (n)
  "Please select type for TRANSFORM."
  (interactive "xSelect transform 1->base_domain 2->baseDomain 3->base-domain 4->BaseDomain:")
  (setq selectForm (pcase n
                     (1 "snakecase")
                     (2 "camelcase")
                     (3 "lispcase")
                     (4 "keep")))
  (setq go-tag-args (list "-transform" selectForm)))

(with-eval-after-load 'go-mode
  (define-key go-mode-map (kbd "C-c t") #'go-tag-add)
  (define-key go-mode-map (kbd "C-c s") #'alison-go-tag-add)
  (define-key go-mode-map (kbd "C-c T") #'go-tag-remove))

(provide 'init-golang-local)
;;; init-golang-local.el ends here

