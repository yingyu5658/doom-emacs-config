;;(setq doom-theme 'catppuccin)
;;(setq catppuccin-flavor 'frappe) ;; or 'latte, 'macchiato, or 'mocha
;; (setq doom-theme 'doom-one)
;; 背景透明
;;(add-to-list 'default-frame-alist '(alpha . (95 . 95)))

;; FUCK IT DOOM-DASHBOARD
;; Dashboard Banner
(setq +doom-dashboard-banner-file "~/.config/doom/img/banner.png")

;; dashboard
;;(dashboard-setup-startup-hook)

;;(setq dashboard-startup-banner 'logo)
;;(setq dashboard-banner-logo-title "Welcome to Verdant's Emacs World!!!")
;; 居中
;;(setq dashboard-center-content t)
;;(setq dashboard-vertically-center-content t)
;; 循环导航
;;(setq dashboard-navigation-cycle t)

;;(setq display-line-numbers-type t)

;; 主题
(setq doom-theme 'modus-vivendi)
;;(setq doom-theme 'doom-old-hope)
;;(setq doom-theme 'doom-xcode)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; 让 org 插入日期时使用英文
(setq system-time-locale "C")

;; 个人信息设置
(setq user-full-name "Verdant"
      user-email-address "i@glowisle.me")

;; 启动时全屏
(add-hook 'window-setup-hook #'toggle-frame-maximized)

;; 字体设置
(setq doom-font (font-spec :family "FiraMono Nerd Font" :size 18 :weight 'semi-light))

;; EAF
(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-application-framework/")
(require 'eaf)
;;(require 'eaf-pdf-viewer)
;;(require 'eaf-org-previewer)
;;(require 'eaf-image-viewer)
(require 'eaf-browser)
;;(require 'eaf-markdown-previewer)


;; Go语言配置
(after! go-mode
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook #'gofmt-before-save))

;; 公司模式配置
(after! company
  ;; 停止输入后多久自动弹出补全（单位：秒，0.2表示200毫秒）
  (setq company-idle-delay 0.05)  ;; 稍微调大一点，0.01太敏感了
  ;; 输入多少个字符后开始触发补全（1表示输入第一个字符就可能触发）
  (setq company-minimum-prefix-length 1))

;; 环境变量设置
(setenv "GOPATH" (expand-file-name "~/go"))
(setenv "PATH" (concat (getenv "PATH") ":" (expand-file-name "~/go/bin")))

;; Hugo博客配置

;; 确保 Go 相关路径被识别
(after! lsp-mode
  (setq lsp-go-gopls-path "/home/yingyu5658/go/bin/gopls"))

;; 添加执行路径
(add-to-list 'exec-path "/home/yingyu5658/go/bin")
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/go/bin"))
(add-to-list 'exec-path "/usr/local/go/bin")

;; org-bullets 设置
(setq org-bullets-bullet-list '("☰" "☷" "☯" "☭"))
(setq org-ellipsis " ▼ ")
(add-hook 'org-mode-hook 'org-bullets-mode)

(after! mu4e
  ;; 基本设置
  (setq mu4e-maildir "~/mail"     ; 邮件目录
        mu4e-get-mail-command "mbsync -a"  ; 接收邮件命令
        mu4e-update-interval 300  ; 自动更新间隔（秒）
        mu4e-view-show-images t   ; 显示图片
        mu4e-compose-signature "Best regards.\nVerdant") ; 邮件签名

  ;; 使用 msmtp 发送邮件
  (setq message-send-mail-function 'message-send-mail-with-sendmail
        sendmail-program "/usr/bin/msmtp"
        sendmail-arguments '("--read-envelope-from" "--read-recipients"))


  (setq mu4e-contexts
        (list
         (make-mu4e-context
          :name "GlowIsle"
          :match-func (lambda (msg)
                        (when msg
                          (string-match-p "^/GlowIsle" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "i@glowisle.me")  ; 确保这里正确
                  (user-full-name    . "Verdant")
                  (smtpmail-smtp-server . "smtp.qiye.aliyun.com")
                  (smtpmail-smtp-service . 465)
                  (smtpmail-stream-type . starttls)))))
  )

;; vterm 和 treemacs 键位配置冲突修复
(map! :leader "o t" nil)
;; 绑定 SPC o v 到正确的 vterm 函数（根据第一步的结果替换函数名）
(map! :leader
      :desc "打开 vterm 终端"
      "o v"  ; SPC o v
      #'+vterm/toggle)

;; treemacs 键位配置
(map! :leader "o p" nil)
(map! :leader
      :desc "打开Treemacs Buffer"
      "e"
      #'+treemacs/toggle)

(map! :leader
      :desc "切换 Treemacs Buffer"
      "1"
      #'treemacs-select-window)

;; vterm 配置
(setq vterm-max-scrollback 10000)

;; 关闭除 LSP 以外的补全
(add-hook 'c-mode-hook
          (lambda ()
            (setq-local company-backends '(company-capf))))
(add-hook 'c++-mode-hook
          (lambda ()
            (setq-local company-backends '(company-capf))))

(defun alpha ()
  "切换当前窗口的透明度 (95% / 100%)"
  (interactive)
  (let* ((current-alpha (frame-parameter nil 'alpha))
         (current-value (cond
                         ((numberp current-alpha) current-alpha)
                         ((consp current-alpha) (car current-alpha))
                         (t 100))) ; 默认值
         (new-alpha (if (or (= current-value 100) (eq current-alpha t))
                        '(95 . 95)  ; 如果当前是100%或不透明，则设为半透明
                      '(100 . 100)))) ; 否则设为不透明
    (set-frame-parameter nil 'alpha new-alpha)
    (message "透明度已设为: %s" new-alpha)))

(repeat-mode +1)

(defun publish-blog()
  (interactive)
  ;; 暂存修改
  (magit-stage-modified)
  (sit-for 0.2)

  (magit-commit-create)
  )


;; telega
(after! telega
  (setq telega-proxies
        (list '(:server "127.0.0.1" :port 1089 :enable t
                :type (:@type "proxyTypeSocks5"))))
  (setq telega-root-mode-hook nil))

;; 插入图片
(defun insert-image-from-R2 ()
  (interactive)
  (insert "![](https://images.glowisle.me/)"))
;; 插入链接
(defun insert-url ()
  (interactive)
  (insert "[]()"))

(map! :leader
      :desc "插入链接"
      "i u"
      #'insert-url)


(map! :leader
      :desc "插入图片"
      "i i"
      #'insert-image-from-R2)
