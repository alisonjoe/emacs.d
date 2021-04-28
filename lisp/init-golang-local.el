;;; golang config --- Support golang
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

;; (setenv "GO111MODULE" "off")



(global-flycheck-mode)
(with-eval-after-load 'go-mode
  (autoload 'flycheck-get-checker-for-buffer "golint")
  (autoload 'flycheck-get-checker-for-buffer "govet")
  (autoload 'flycheck-get-checker-for-buffer "flycheck"))
;; 添加新的检测器
;; (add-to-list 'flycheck-checkers 'golangci-lint)
(setq flycheck-golangci-lint-config "~/.emacs.d/conf/.golangci.yml")
;; 设置timemout
(setq flycheck-golangci-lint-deadline "10m")
(eval-after-load 'flycheck
  '(add-hook '-mode-hook #'flycheck-golangci-lint-setup))
;; (eval-after-load 'flycheck
;;   '(add-hook 'flycheck-mode-hook 'flycheck-golangci-lint-setup))
;; skips 'vendor' directories and sets GO15VENDOREXPERIMENT=1
(setq flycheck-gometalinter-vendor t)
;; only show errors
;; (setq flycheck-gometalinter-errors-only t)
;; only run fast linters
;; (setq flycheck-gometalinter-fast t)
;; use in tests files
;; (setq flycheck-gometalinter-tests t)
;; disable linters
;; (setq flycheck-gometalinter-disable-linters '("gotype" "gocyclo"))
;; Only enable selected linters
;; (setq flycheck-gometalinter-disable-all t)
(setq flycheck-gometalinter-enable-linters '("golangci-lint"))
;; Set different deadline (default: 5s)
(setq flycheck-gometalinter-deadline "10s")
;; Use a gometalinter configuration file (default: nil)
(setq flycheck-gometalinter-config "~/.emacs.d/config/.gometalinter-config.json")
;; (setq flycheck-check-syntax-automatically '(mode-enabled save))
;; (setq flycheck-check-syntax-automatically '(add-hook save))


;;; C-c C-r注释未使用的引入
(add-hook 'go-mode-hook '(lambda ()
                           (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))

;; ;;; 跳转引入
(add-hook 'go-mode-hook '(lambda ()
                           (local-set-key (kbd "C-c C-g") 'go-goto-imports)))


;; How to set gofmt-args
;; I think gofmt-args is a list. Can you try again with (setq gofmt-args '("-local" "github.com"))?
;; https://github.com/dominikh/go-mode.el/issues/365
(setq gofmt-command "goimports")
(setq gofmt-args '("-local" "git.code.oa.com"))
(add-hook 'go-mode-hook '(lambda ()
                           (local-set-key (kbd "C-c C-f") 'gofmt)))

(add-hook 'before-save-hook 'gofmt-before-save)

(add-hook 'go-mode-hook '(lambda ()
                           (local-set-key (kbd "C-c C-k") 'godoc)))

(setq go-test-args "-gcflags=all=-l")

;; go auto comment
;; go get -u github.com/Gnouc/gocmt
(defun maple/go-auto-comment()
  (interactive)
  (setq gocmt (concat "gocmt -i " buffer-file-name))
  (shell-command-on-region
   (point-min) (point-max)
   gocmt))



;; 支持以下转换
;; snakecase：BaseDomain- >base_domain
;; camelcase：BaseDomain- >baseDomain
;; lispcase：BaseDomain- >base-domain
;; eg: (setq go-tag-args (list "-transform" "camelcase"))
(setq go-tag-args (list "-transform" "snakecase"))


(defun alison-go-tag-add (n)
  "Pelase select type for TRANSFORM."
  (interactive "xSelect transform 1->base_domain 2->baseDomain 3->base-domain 4->BaseDomain:")
  (setq selectForm (pcase n
                     (1 "snakecase")
                     (2 "camelcase")
                     (3 "lispcase")
                     (4 "keep")
                     ))
  (setq go-tag-args (list "-transform" selectForm)))


(with-eval-after-load 'go-mode
  (define-key go-mode-map (kbd "C-c t") #'go-tag-add)
  (define-key go-mode-map (kbd "C-c s") #'alison-go-tag-add)
  (define-key go-mode-map (kbd "C-c T") #'go-tag-remove))
;;
;; (go-guru-hl-identifier-mode)
;; (add-hook 'go-mode-hook #'go-guru-hl-identifier-mode)
;; (add-hook 'go-mode-hook 'go-eldoc-setup)
;; (set-face-attribute 'eldoc-highlight-function-argument nil
;;                     :underline t :foreground "green"
;;                     :weight 'bold)

;; (defun my-go-gen-test-setup ()
;;   "My keybindings for generating go tests."
;;   (interactive)
;;   (local-set-key (kbd "C-c C-g") #'go-gen-test-dwim))

;; (add-hook 'go-mode-hook #'my-go-gen-test-setup)

(provide 'init-golang-local)
;;; init-golang-local.el ends here
