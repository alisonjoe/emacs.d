;;; evil --- Support vi mode
;;; Commentary:
;;; Code:

(require-package 'evil)
(evil-mode 1)
(add-hook 'org-agenda-mode-hook 'evil-normalize-keymaps)
(evil-set-initial-state 'org-agenda-mode 'emacs)
(evil-set-initial-state 'org-mode 'emacs)
(provide 'init-evil-local)
;;; init-evil-local.el ends here
