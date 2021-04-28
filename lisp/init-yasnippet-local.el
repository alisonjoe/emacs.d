;;; yasnippet --- Support yasnippet
;;; Commentary:
;;; Code:


(require-package 'yasnippet)
(require-package 'yasnippet-snippets)

;; add yasnippet local
(setq yas-snippet-dirs 
	  '("~/.emacs.d/snippets"))


(yas-global-mode 1)


(provide 'init-yasnippet-local)
;;; init-yasnippet-local.el ends here
