;;; init-org-download-local.el --org-image
;;; Commentary:
;;; Code:
(require-package 'org-download)


(add-hook 'org-mode-hook 'org-download-enable)
(setq-default org-download-image-dir "~/GoogleCloudDrive/ORGIMG")

(provide 'init-org-download-local)
