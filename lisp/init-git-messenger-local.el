;;; init-git-messenger-local.el ---  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(require-package 'git-messenger)
(require-package 'git-gutter)
(require-package 'transient)

(defvar my/magit-commit-type "" "存储选定的提交类型")
(defvar my/magit-commit-scope "" "存储选定的提交范围")
(defvar my/magit-commit-short-desc "" "存储简短的提交描述")
(defvar my/magit-commit-long-desc "" "存储详细的提交描述")
(defvar my/magit-commit-breaking-changes "" "存储破坏性变更")
(defvar my/magit-commit-closes-issues "" "存储关闭的问题")

(defun my/magit-get-commit-buffer ()
  "确保 `COMMIT_EDITMSG` 作为 commit message buffer 存在，并返回它的 buffer。"
  (let ((buffer (get-buffer "COMMIT_EDITMSG")))
    (unless buffer
      ;; 如果 buffer 不存在，手动打开 commit message
      (magit-commit-create)
      (setq buffer (get-buffer "COMMIT_EDITMSG")))
    buffer))


(defun my/magit-update-commit-message ()
  "实时更新 `COMMIT_EDITMSG` 中的提交信息，不清空已有 Git 自动生成的注释。"
  (let ((buffer (my/magit-get-commit-buffer)))
    (when buffer
      (with-current-buffer buffer
        (goto-char (point-min))

        ;; 确保第一行是 `feat(API): xxx`
        (if (re-search-forward "^[a-z]+([a-zA-Z-_]*): " nil t)
            (delete-region (line-beginning-position) (line-end-position))
          (goto-char (point-min))) ;; 没有 commit 标题时，回到开头

        ;; 插入标题
        (insert (format "%s(%s): %s\n\n" my/magit-commit-type my/magit-commit-scope my/magit-commit-short-desc))

        ;; 找到 Git 自动生成的注释的起始位置
        (let ((comment-start (save-excursion
                               (goto-char (point-max))
                               (if (re-search-backward "^# Please enter the commit message" nil t)
                                   (match-beginning 0)
                                 (point-max)))))
          ;; 清除标题和 Git 注释之间的所有内容
          (delete-region (point) comment-start)

          ;; 插入详细描述
          (unless (string-empty-p my/magit-commit-long-desc)
            (insert (format "%s\n\n" my/magit-commit-long-desc)))

          ;; 插入 `BREAKING CHANGE`
          (unless (string-empty-p my/magit-commit-breaking-changes)
            (insert (format "BREAKING CHANGE: %s\n\n" my/magit-commit-breaking-changes)))

          ;; 插入 `Closes:`
          (unless (string-empty-p my/magit-commit-closes-issues)
            (insert (format "Closes: %s\n" my/magit-commit-closes-issues))))

        ;; 确保 Git 注释部分仍然存在
        (goto-char (point-max))
        (unless (re-search-backward "^#" nil t)
          (insert "\n"))))))

(defun my/magit-has-staged-changes ()
  "检查是否有暂存的更改，返回 t 或 nil。"
  (eq (call-process "git" nil nil nil "diff" "--cached" "--exit-code") 1))

(defun my/magit-start-commit ()
  "确保当前缓冲区是 `COMMIT_EDITMSG` 且有暂存的更改后启动 `Conventional Commit` 交互。"
  (interactive)
  (unless (string= (buffer-name) "COMMIT_EDITMSG")
    (user-error "❌ 当前缓冲区不是 COMMIT_EDITMSG，请在提交缓冲区中执行此命令！"))
  (if (my/magit-has-staged-changes)
      (progn
        (magit-commit-create)  ;; 打开 `COMMIT_EDITMSG`
        (run-with-timer 0.5 nil #'transient-setup 'my/magit-commit-type-selection))  ;; 稍后启动 `transient`
    (message "❌ 没有暂存的更改，请先使用 `git add` 暂存文件！")))

(transient-define-prefix my/magit-commit-type-selection ()
  "选择 Conventional Commits 提交类型"
  [["选择提交类型"
    ("f" "✨ feat (新功能)"    (lambda () (interactive)
                                 (setq my/magit-commit-type "✨ feat")
                                 (my/magit-update-commit-message)
                                 (transient-setup 'my/magit-commit-scope-selection)))
    ("x" "🐛 fix (修复 bug)"   (lambda () (interactive)
                                 (setq my/magit-commit-type "🐛 fix")
                                 (my/magit-update-commit-message)
                                 (transient-setup 'my/magit-commit-scope-selection)))
    ("d" "📚 docs (文档变更)"  (lambda () (interactive)
                                 (setq my/magit-commit-type "📚 docs")
                                 (my/magit-update-commit-message)
                                 (transient-setup 'my/magit-commit-scope-selection)))
    ("s" "🎨 style (格式修改)" (lambda () (interactive)
                                 (setq my/magit-commit-type "🎨 style")
                                 (my/magit-update-commit-message)
                                 (transient-setup 'my/magit-commit-scope-selection)))
    ("r" "🔨 refactor (重构)"  (lambda () (interactive)
                                 (setq my/magit-commit-type "🔨 refactor")
                                 (my/magit-update-commit-message)
                                 (transient-setup 'my/magit-commit-scope-selection)))
    ("p" "🚀 perf (性能优化)"  (lambda () (interactive)
                                 (setq my/magit-commit-type "🚀 perf")
                                 (my/magit-update-commit-message)
                                 (transient-setup 'my/magit-commit-scope-selection)))
    ("t" "✅ test (添加测试)"  (lambda () (interactive)
                                 (setq my/magit-commit-type "✅ test")
                                 (my/magit-update-commit-message)
                                 (transient-setup 'my/magit-commit-scope-selection)))
    ("c" "🔧 chore (其他修改)" (lambda () (interactive)
                                 (setq my/magit-commit-type "🔧 chore")
                                 (my/magit-update-commit-message)
                                 (transient-setup 'my/magit-commit-scope-selection)))]])

(transient-define-prefix my/magit-commit-scope-selection ()
  "选择提交范围并直接进入简短描述输入"
  [["选择提交范围"
    ("m" "models" (lambda () (interactive)
                    (setq my/magit-commit-scope "models")
                    (my/magit-update-commit-message)
                    (my/magit-commit-short-desc)))
    ("a" "api"    (lambda () (interactive)
                    (setq my/magit-commit-scope "api")
                    (my/magit-update-commit-message)
                    (my/magit-commit-short-desc)))
    ("u" "utils"  (lambda () (interactive)
                    (setq my/magit-commit-scope "utils")
                    (my/magit-update-commit-message)
                    (my/magit-commit-short-desc)))
    ("o" "其他"   (lambda () (interactive)
                    (setq my/magit-commit-scope "other")
                    (my/magit-update-commit-message)
                    (my/magit-commit-short-desc)))]])

(defun my/magit-commit-short-desc ()
  "输入简短描述并进入详细描述步骤"
  (interactive)
  (setq my/magit-commit-short-desc (read-string "简短描述: "))
  (my/magit-update-commit-message)
  (my/magit-commit-long-desc))


(defun my/magit-commit-long-desc ()
  "输入详细描述并进入破坏性变更"
  (interactive)
  (setq my/magit-commit-long-desc (read-string "详细描述: "))
  (my/magit-update-commit-message)
  (my/magit-commit-breaking-changes))

(defun my/magit-commit-breaking-changes ()
  "输入破坏性变更并进入关联 Issue"
  (interactive)
  (setq my/magit-commit-breaking-changes (read-string "破坏性变更 (如果无，回车跳过): "))
  (my/magit-update-commit-message)
  (my/magit-commit-closes-issues))

(defun my/magit-commit-closes-issues ()
  "输入关联 Issue 并完成提交"
  (interactive)
  (setq my/magit-commit-closes-issues (read-string "Closes: "))
  (my/magit-update-commit-message)
  (transient-quit-one))


(global-set-key (kbd "C-c g") #'my/magit-start-commit)

(provide 'init-git-messenger-local)
