;;; loding file
;;; Commentary:
;;; Code:


(setq GoogleCloudPath "~/GoogleCloudDrive/")
;; 所有文件及路径
;; (directory-files-recursively GoogleCloudPath "" t)
;; 所有文件
;; (directory-files-recursively GoogleCloudPath "" nil)
;; 匹配带有xxx的文件
;; (directory-files-recursively GoogleCloudPath "Wesee" nil)


;;(when (file-exists-p GoogleCloudPath)
;;  (setq org-agenda-files (append (directory-files-recursively (concat GoogleCloudPath  "Agenda") "\\.org$" nil)
;;                                 (directory-files-recursively (concat GoogleCloudPath  "Note") "\\.org$" nil)
;;                                 (directory-files-recursively (concat GoogleCloudPath  "Novel") "\\.org$" nil)
;;                                 (directory-files-recursively (concat GoogleCloudPath  "OrgFile") "\\.org$" nil))))

(provide 'init-agenda-file-local)
;;; init-agenda-file-local.el ends here
