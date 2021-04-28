;;自动清除行位空格
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook 'whitespace-cleanup)
;;自动清除行之间的空白行
;;; (add-hook 'before-save-hook 'delete-blank-lines)
;;显示空格
(global-set-key [f1] 'whitespace-newline-mode)

(setq x-select-enable-clipboard t)

;; 内置的软件包管理器package.el在安装软件包时支持提前进行本机编译
(setq package-native-compile t)
;;; (native-compile-async "~/.emacs.d/elpa-28.0/" 'recursively)



(setq line-move-visual t)
(global-visual-line-mode t)

(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
                                        ;(org-display-inline-images)
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-nondirectory (buffer-file-name))
                  "_imgs/"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (unless (file-exists-p (file-name-directory filename))
    (make-directory (file-name-directory filename)))
                                        ; take screenshot
  (if (eq system-type 'darwin)
      (call-process "screencapture" nil nil nil "-i" filename))
  (if (eq system-type 'gnu/linux)
      (call-process "import" nil nil nil filename))
                                        ; insert into file if correctly taken
  (if (file-exists-p filename)
      (insert (concat "[[./" filename "]]")))
  )


(provide 'init-my-edit)
