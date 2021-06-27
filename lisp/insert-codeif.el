(defun insert-codeif-name-insert (arg)
  (interactive "p")

  )


(defconst codeif-api-url
  "https://searchcode.com/api/codesearch_I/?callback=searchcodeRequestVariableCallback&p=0&per_page=42&q=%s"
  "codeif api url")


(defun get-codeif-api-build-url (word)
  (format codeif-api-url (url-hexify-string word)))



(defun parse-codeif-retrieve-callback (&optional word)
    ;; Get translation.
    (message word))


(message "hello")




(defun query-name-codeif (w)
  (interactive "sPlease enter the variable name you want to query: ")
  (url-retrieve
   (get-codeif-api-build-url w)
   'parse-codeif-retrieve-callback
   (list w (current-buffer))))


(defun insert-translated-name-update-translation-in-buffer (word insert-buffer )
  (let ((result (insert-translated-name-convert-translation )))
    (save-excursion
      (with-current-buffer insert-buffer
        (let ((placeholder-point (gethash placeholder insert-translated-name-placeholder-hash)))
          (if placeholder-point
              (progn
                ;; Insert result at placeholder point .
                (goto-char placeholder-point)
                (insert result)

                ;; Remove placeholder from hash.
                (remhash placeholder insert-translated-name-placeholder-hash))
            (message (format "Something wrong that we can't found placeholder for %s: %s" word ))))))))


(with-temp-buffer
  (url-insert-file-contents
   "https://api.stackexchange.com/2.2/questions/12464?site=emacs")
  (let ((json-false :false))
    (json-read)))
