;;; init-protobuf-mode-local.el ---
;;; Commentary:
;;; Code:
(require-package 'protobuf-mode)


(defconst my-protobuf-style
  '((c-basic-offset . 2)
    (indent-tabs-mode . nil)))

(add-hook 'protobuf-mode-hook
          (lambda () (c-add-style "my-style" my-protobuf-style t)))

(provide 'init-protobuf-mode-local)
;;; init-protobuf-mode-local.el ends here
