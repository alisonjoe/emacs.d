;;; undo-tree --- Suprrot undo tree
;;; Commentary:
;;; Code:

(require-package 'undo-tree)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
(setq undo-tree-auto-save-history t)
(global-undo-tree-mode)
(provide 'init-undo-tree-local)
;;; init-undo-tree-local.el ends here
