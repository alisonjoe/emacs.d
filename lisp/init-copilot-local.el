;;; init-copilot-local  --- Support copilot
;;; Commentary:
;;; Code:

(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp/copilot.el")))
(require 'copilot)
;; copilot automatically provide completions
(add-hook 'prog-mode-hook 'copilot-mode)

; complete by copilot first, then auto-complete
(defun my-tab ()
  (interactive)
  (or (copilot-accept-completion)
      (ac-expand nil)))

(with-eval-after-load 'auto-complete
  ; disable inline preview
  (setq ac-disable-inline t)
  ; show menu if have only one candidate
  (setq ac-candidate-menu-min 0))
  
(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

(provide 'init-copilot-local)
;;; init-copilot-local.el ends here
