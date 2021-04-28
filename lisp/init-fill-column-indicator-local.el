;;; fill-column-indicator --- Support fill column
;;; Commentary:
;;; Code:

(require-package 'fill-column-indicator)
(setq global-visual-line-mode t)
(setq fci-rule-column 80) ;; 80 个字节处画竖线
(setq fci-rule-color "orange") ;; 竖线为黄色
(setq fci-rule-width 4) ;; 竖线宽度为 4 个像素
(define-globalized-minor-mode  global-fci-mode fci-mode(lambda()(fci-mode 1)))
(global-fci-mode 1)
(provide 'init-fill-column-indicator-local)
;;; init-fill-column-indicator-local.el ends here
