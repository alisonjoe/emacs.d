;;; auto-complete --- auto-complete mode
;;; Commentary:
;;; Code:

(require-package 'auto-complete)
(require-package 'go-autocomplete)

(require 'auto-complete-config)
(ac-config-default)
;; Just ignore case
(setq ac-ignore-case t)
;; Ignore case if completion target string doesn't include upper characters
(setq ac-ignore-case 'smart)
;; Distinguish case
(setq ac-ignore-case nil)


(set-face-background 'ac-candidate-face "lightgray")
(set-face-underline 'ac-candidate-face "darkgray")
(set-face-background 'ac-selection-face "steelblue")

(setq-default ac-sources '(ac-source-words-in-all-buffer))
(provide 'init-auto-complete-local)
;;; init-auto-complete-local.el ends here
