;;; chat-gpt --- Support chatgpt with shell
;;; Commentary:
;;; Code:
(require-package 'chatgpt-shell)
(require-package 'dall-e-shell)

(setenv "chatgpt-shell-additional-curl-options" "-x http://127.0.0.1:1087")
(setq chatgpt-shell-openai-key 'xxxxx)

(provide 'init-gpt-shell-local)
;;; init-gpt-shell-local.el ends here
