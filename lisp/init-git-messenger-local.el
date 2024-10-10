;;; init-git-messenger-local.el ---  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'git-messenger)
(require-package 'git-gutter)

(global-set-key (kbd "C-x v p") 'git-messenger:popup-message)

;; Use magit-show-commit for showing status/diff commands
(custom-set-variables
 '(git-messenger:use-magit-popup t))

(global-git-gutter-mode t)


(provide 'init-git-messenger-local)
;;; init-git-messenger-local.el ends here
