;;; yasnippet --- Support yasnippet
;;; Commentary:
;;; Code:


(require-package 'yasnippet)
(require-package 'yasnippet-snippets)

;; add yasnippet local
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
        "~/.emacs.d/personal_snippets"))



;; (yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(yas-global-mode 1)


(provide 'init-yasnippet-local)
;;; init-yasnippet-local.el ends here
