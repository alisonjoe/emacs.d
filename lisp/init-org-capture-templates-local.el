;;; init-org-capture-templates-local.el --org-capture
;;; Commentary:
;;; Code:

;; (require-package 'auctex-latexmk)
;; (require-package 'org2ctex)
;; (require-package 'doct)
;; (require-package 'ob-go)
;; (auctex-latexmk-setup)
;; (setq org-plantuml-jar-path
;;       (expand-file-name "~/3rd/plantuml.jar"))

;; (setq auctex-latexmk-inherit-TeX-PDF-mode t)

;; ;; 导出pdf需要设置
;; ;; (org2ctex-toggle t)
;; ;; (setq org-latex-create-formula-image-program 'dvipng)    ;速度很快，但 *默认* 不支持中文
;; (setq org-latex-create-formula-image-program 'imagemagick)  ;速度较慢，但支持中文
;; ;; (setq org-format-latex-options
;; ;;             (plist-put org-format-latex-options :scale 2.0))      ;调整 LaTeX 预览图片的大小
;; ;; (setq org-format-latex-options
;; ;;             (plist-put org-format-latex-options :html-scale 2.5)) ;调整 HTML 文件中 LaTeX 图像的大小



;; (setq org-directory "~/GoogleCloudDrive/OrgFile/")
;; (setq org-default-notes-file "~/GoogleCloudDrive/OrgFile/note.org")
;; (setq org-capture-templates 'nil)

;; (defun transform-square-brackets-to-round-ones(string-to-transform)
;;   "Transforms [ into ( and ] into ), other chars left unchanged."
;;   (concat
;;    (mapcar #'(lambda (c) (if (equal c ?[) ?\( (if (equal c ?]) ?\) c))) string-to-transform))
;;   )

;; (setq org-capture-templates
;;       `(
;;         ("b" "Basic task for future review" entry
;;          (file+headline "tasks.org" "Basic tasks that need to be reviewed")
;;          "* %^{Title}\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%l")
;;         ("c" "Comment or write blog" entry
;;          (file+headline "tasks.org" "Writing list")
;;          "* WRITE %^{Title} :@priv:website:\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%l")
;;         ("d" "Docs")
;;         ("dn" "note or design document" entry
;;          (file+headline "notes.org" "note or design document")
;;          "* %^{Title} :@doc\nSCHEDULE: %^t\n:CAPTURED:%U\n")

;;         ("r" "Reply to an email" entry
;;          (file+headline "tasks.org" "Mail correspondence")
;;          "* TODO [#B] %:subject :mail:\nSCHEDULED: %t\n:PROPERTIES:\n:CONTEXT: %a\n:END:\n\n%i%?")

;;         ("p" "Protocol" entry (file+headline ,(concat org-directory "notes.org") "Inbox")
;;          "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
;;         ("L" "Protocol Link" entry (file+headline ,(concat org-directory "notes.org") "Inbox")
;;          "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]\n")
;;         ("t" "Task with a due date" entry
;;          (file+headline "tasks.org" "Task list with a date")
;;          "* %^{Scope of task||TODO|STUDY|MEET} %^{Title} %^g\nSCHEDULED: %^t\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?")
;;         ("w" "Work")
;;         ("wt" "Task or assignment" entry
;;          (file+headline "work.org" "Tasks and assignments")
;;          "* TODO [#A] %^{Title} :@work:\nSCHEDULED: %^t\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?")
;;         ("wm" "Meeting, event, appointment" entry
;;          (file+headline "work.org" "Meetings, events, and appointments")
;;          "* MEET [#A] %^{Title} :@work:\nSCHEDULED: %^T\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?")

;;         ("t" "Task with a due date" entry
;;          (file+headline "tasks.org" "Task list with a date")
;;          "* %^{Scope of task||TODO|STUDY|MEET} %^{Title} %^g\nSCHEDULED: %^t\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%?")

;;         ("r" "Reply to an email" entry
;;          (file+headline "tasks.org" "Mail correspondence")
;;          "* TODO [#B] %:subject :mail:\nSCHEDULED: %t\n:PROPERTIES:\n:CONTEXT: %a\n:END:\n\n%i%?")
;;         ("x" "blog" plain (file, (concat "~/GoogleCloudDrive/OrgFile/"
;;                                          (format-time-string "%Y-%m-%d.org")))
;;          ,(concat "#+startup:showall\n"
;;                   "#+options:toc:nil\n"
;;                   "#+begin_export html\n"
;;                   "---\n"
;;                   "layout: post\n"
;;                   "title:%^{title}\n"
;;                   "categories:%^{cate}\n"
;;                   "tags:%^{tag}\n"
;;                   "---\n"
;;                   "#+end_export\n"
;;                   "#+TOC:headlines 2\n"))
;;         ))





;; (add-to-list 'org-capture-templates
;;              `("x" "blog" plain (file, (concat "~/GoogleCloudDrive/OrgFile/"
;;                                                (format-time-string "%Y-%m-%d.org")))
;;                ,(concat "#+startup:showall\n"
;;                         "#+options:toc:nil\n"
;;                         "#+begin_export html\n"
;;                         "---\n"
;;                         "layout: post\n"
;;                         "title:%^{title}\n"
;;                         "categories:%^{cate}\n"
;;                         "tags:%^{tag}\n"
;;                         "---\n"
;;                         "#+end_export\n"
;;                         "#+TOC:headlines 2\n")))

;; (setq org-plantuml-jar-path
;;       (expand-file-name "~/.emacs.d/plantuml.jar"))

;; (defun org-babel-execute:plantuml (body params)
;;   "Execute a block of plantuml code with org-babel.
;; This function is called by `org-babel-execute-src-block'."
;;   (let* ((result-params (split-string (or (cdr (assoc :results params)) "")))
;;          (out-file (or (cdr (assoc :file params))
;;                        (error "PlantUML requires a \":file\" header argument")))
;;          (cmdline (cdr (assoc :cmdline params)))
;;          (in-file (org-babel-temp-file "plantuml-"))
;;          (java (or (cdr (assoc :java params)) ""))
;;          (cmd (if (string= "" org-plantuml-jar-path)
;;                   (error "`org-plantuml-jar-path' is not set")
;;                 (concat "java " java " -jar "
;;                         (shell-quote-argument
;;                          (expand-file-name org-plantuml-jar-path))
;;                         (if (string= (file-name-extension out-file) "svg")
;;                             " -tsvg" "")
;;                         (if (string= (file-name-extension out-file) "eps")
;;                             " -teps" "")
;;                         " -p " cmdline " < "
;;                         (org-babel-process-file-name in-file)
;;                         " > "
;;                         (org-babel-process-file-name out-file)))))
;;     (unless (file-exists-p org-plantuml-jar-path)
;;       (error "Could not find plantuml.jar at %s" org-plantuml-jar-path))
;;     (with-temp-file in-file (insert (concat "@startuml\n" body "\n@enduml")))
;;     (message "%s" cmd) (org-babel-eval cmd "")
;;     nil))




(provide 'init-org-capture-templates-local)
;;; init-org-capture-templates-local.el end here
