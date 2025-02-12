;;; chat-gpt --- Support chatgpt with shell
;;; Commentary:
;;; Code:
(require-package 'gptel)

;; DeepSeek offers an OpenAI compatible API
(setq gptel-model   'deepseek-chat
        gptel-backend
        (gptel-make-openai "DeepSeek"       ;Any name you want
                :host "api.deepseek.com"
                :endpoint "/chat/completions"
                :stream t
                :key "sk-key"               ;can be a function that returns the key
                :models '(deepseek-chat deepseek-coder)))


(provide 'init-gptel-local)
;;; init-gptel-local.el ends here
