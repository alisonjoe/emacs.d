;;; dashboard --- Support dashboard
;;; Commentary:
;;; Code:

(require-package 'dashboard)

(dashboard-setup-startup-hook)

(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)
                        (registers . 5)))

(provide 'init-dashboard-local)
;;; init-dashboard-local.el ends here
