;;; chat-gpt --- Support chatgpt with shell
;;; Commentary:
;;; Code:
(require-package 'gptel)


;; OPTIONAL configuration
(setq
 gptel-model "gpt-3.5-turbo"
 gptel-backend (gptel-make-azure "Azure-1"
                 :protocol "https"
                 :host "chataiwho.openai.azure.com"
                 :endpoint "/openai/deployments/alison-azure/chat/completions?api-version=2023-05-15"
                 :stream t
                 :key "be727c6906d5447798647babf95c03ad"
                 :models '("gpt-3.5-turbo" "gpt-4"))
 )

(provide 'init-gptel-local)
;;; init-gptel-local.el ends here
