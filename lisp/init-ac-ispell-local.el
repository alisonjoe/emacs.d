;;; init-ac-ispell-local.el --- ispell support -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'ac-ispell)

;; Completion words longer than 4 characters
(custom-set-variables
  '(ac-ispell-requires 4)
  '(ac-ispell-fuzzy-limit 2))

(eval-after-load "auto-complete"
                 '(progn
                    (ac-ispell-setup)))

(setq ispell-dictionary "en_US")
(setq ispell-alternate-dictionary "en_US")
(add-hook 'git-commit-mode-hook 'ac-ispell-ac-setup)
(add-hook 'mail-mode-hook 'ac-ispell-ac-setup)
(add-hook 'go-mode-hook 'ac-ispell-ac-setup)


(provide 'init-ac-ispell-local)
;;; init-ac-ispell-local.el ends here
