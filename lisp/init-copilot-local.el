;;; init-copilot-local.el --- Support copilot
;;; Commentary:
;;; Code:

(add-to-list 'load-path
             (expand-file-name (concat user-emacs-directory "lisp/copilot.el")))
(require 'copilot)

;; Copilot automatically provide completions
(add-hook 'prog-mode-hook 'copilot-mode)

;; Complete by copilot first, then auto-complete
(defun my-tab ()
  (interactive)
  (or (copilot-accept-completion)
      (ac-expand nil)))

(with-eval-after-load 'auto-complete
  ;; Disable inline preview
  (setq ac-disable-inline t)
  ;; Show menu if have only one candidate
  (setq ac-candidate-menu-min 0))

(setq copilot-max-characters 1000000) ;; 增大为 1,000,000

(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)

;; Bind `my-tab` function to TAB key in prog-mode
(add-hook 'prog-mode-hook
          (lambda ()
            (local-set-key (kbd "TAB") 'my-tab)
            (local-set-key (kbd "<tab>") 'my-tab)))

(defun maybe-disable-copilot ()
  "Disable Copilot if the buffer is too large."
  (when (> (buffer-size) copilot-max-characters)
    (copilot-mode -1)
    (message "Copilot disabled due to large buffer size.")))

(add-hook 'copilot-mode-hook 'maybe-disable-copilot)


(provide 'init-copilot-local)
;;; init-copilot-local.el ends here
