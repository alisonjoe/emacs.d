;;; undo-tree --- Suprrot undo tree
;;; Commentary:
;;; Code:

(require-package 'undo-tree)

(setq undo-tree-history-directory-alist
      `(("." . ,(concat user-emacs-directory "undo-tree-history"))))

(setq undo-tree-auto-save-history nil)

(global-undo-tree-mode)
(provide 'init-undo-tree-local)
;;; init-undo-tree-local.el ends here
