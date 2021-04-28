;;; c-mode --- Support c c++ mode
;;; Commentary:
;;; Code:


(require-package 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(provide 'init-c-mode-local)
;;; init-c-mode-local.el ends here
