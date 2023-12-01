(setq user-full-name ""
      user-mail-address "")

(setq doom-font (font-spec :family "Hasklug Nerd Font Mono" :size 15 :foundry 'ADBO :weight 'semi-bold :slant 'normal :width 'normal :spacing 100 :scalable 'true))
(setq doom-variable-pitch-font (font-spec :family "Hasklug Nerd font" :size 13))
(setq doom-serif-font (font-spec :family "Hasklug Nerd Font" :size 12))

(use-package! doom-themes
  :config
  (setq doom-theme 'doom-dracula)
  (setq doom-themes-treemacs-theme "doom-colors")
        (doom-themes-treemacs-config)
        (doom-themes-org-config))

(setq display-line-numbers-type t)
(setq which-key-max-description-length 34)

(add-hook 'after-init-hook (lambda ()
  (when (fboundp 'auto-dim-other-buffers-mode)
    (auto-dim-other-buffers-mode t))))

(setq projectile-project-search-path '("~/Skolrelaterat/Datorvetenskap/Code/" "~/Orgfiles/"))
(setq org-directory "~/Orgfiles/")

(setenv "PATH" (concat (getenv "PATH") ":/home/nicke/.ghcup/bin/"))
(setq exec-path (append exec-path '("/home/nicke/.ghcup/bin/")))

(setenv "JAVA_HOME" "/usr/lib/jvm/java-17-openjdk-amd64")
(setq lsp-java-java-path "/usr/lib/jvm/java-17-openjdk-amd64/bin/java")

(setenv "PATH" (concat (getenv "PATH") ":/usr/lib/erlang/bin"))
(setq exec-path (append exec-path '("/usr/lib/erlang/bin")))

;; Unsure if this function is working
(after! org
  (set-face-attribute 'org-level-1 nil :height 1.7)
  (set-face-attribute 'org-level-2 nil :height 1.6)
  (set-face-attribute 'org-level-3 nil :height 1.5)
  (set-face-attribute 'org-level-4 nil :height 1.4)
  (set-face-attribute 'org-level-5 nil :height 1.3)
  (setq org-hide-emphasis-markers t
        org-deadline-warning-days 31
        org-ellipsis " ▼ "))
  (setq org-agenda-custom-commands
      '(("v" "A better view"
         ((tags "CATEGORY=\"Schedule\""
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Schedule:"))))
         (agenda "")
         (alltodo ""))))

(use-package! org-bullets
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("λ" "◉" "○" "●" "○" "◆" "▶")))

(use-package! lsp-ui
  :config (setq lsp-ui-doc-enable t
                lsp-ui-doc-delay 2
                lsp-ui-doc-show-with-cursor t
                lsp-ui-doc-show-with-mouse t
                lsp-ui-doc-position 'top
                lsp-ui-peek-enable t
                lsp-ui-peek-show-directory t
                lsp-ui-imenu-auto-refresh t))
         ;; (setq lsp-ui-sideline-show-diagnostics t)
         ;; (setq lsp-ui-sideline-show-code-actions t)

(use-package! lsp-mode
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :config (setq lsp-completion-enable-additional-text-edit nil))

(use-package! dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))

(use-package! yasnippet
  :config (yas-global-mode))

(use-package! treemacs
  :config
  (setq treemacs-is-never-other-window t)
  (setq treemacs-follow-mode t))

(use-package! projectile
  :config (projectile-mode))

(use-package! helm
  :config
  (setq helm-mode t))

(use-package! lsp-java
  :config (add-hook 'java-mode-hook 'lsp))

(after! lsp-java
  (setq lsp-java-import-gradle-enabled t))

(use-package! lsp-haskell
  :after lsp-mode
  :config
  (setq lsp-haskell-plugin-ghcide-completions-config-auto-extend-on nil)
  (setq lsp-haskell-plugin-ghcide-type-lenses-global-on nil))

(after! flycheck
  (setq-default flycheck-disabled-checkers '(haskell-ghc))
  (flycheck-add-next-checker 'haskell-ghc '(warning . haskell-hlint)))

(use-package! haskell-mode
  :config
  (map! :map haskell-mode-map
        "C-c h" 'haskell-hoogle
        "C-c w" 'haskell-hoogle-lookup-from-website)

  ;; Set the Hoogle command to "hoogle"
  (setq haskell-hoogle-command "hoogle")
  (setq haskell-hoogle-lookup-from-website-command "hoogle web lookup"))

(setq +latex-viewers '(okular))

(use-package! flyspell
  :hook ((text-mode . flyspell-mode)
         (org-mode . flyspell-mode))
  :config
  (setq ispell-local-dictionary-alist
        '((nil "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-d" "en_US") nil utf-8)
          ("svenska" "[A-Za-zåäöÅÄÖéÉ]" "[^A-Za-zåäöÅÄÖéÉ]" "[']" nil ("-d" "svenska") nil utf-8)))
  (ispell-set-spellchecker-params))

(use-package! c3po
  :config
  (setq c3po-api-key "API-token"))

(map! :leader
      :desc "toggle treemacs"
      "o p" #'treemacs)
;; Bind projectile to "leader + o + o" (leader = SPC)
(map! :leader
      :map projectile-mode-map
      :desc "Open projectile"
      "o o" #'projectile-command-map)

(map! :leader
      :desc "Open c3po-dev"
      "o q" #'c3po-dev-chat)

(map! :leader
      :desc "Open c3po-chat"
      "o w" #'c3po-chat)

(map! :leader
      :desc "c3po reply"
      "v r" #'c3po-reply)

(map! :leader
      :desc "c3po explain"
      "v e" #'c3po-explain-code)

(map! :leader
      :desc "c3po summarize"
      "v s" #'c3po-summarize)

(map! :leader
      (:prefix ("o" . "imenu")
      :desc "Open imenu"
      "i i" #'lsp-ui-imenu))

(map! :leader
      (:prefix ("o" . "imenu")
       :desc "refresh imenu"
       "i r" #'lsp-ui-imenu--refresh))

(define-key evil-normal-state-map (kbd "M-j") 'evil-window-next)
(define-key evil-normal-state-map (kbd "M-J") 'evil-window-rotate-downwards)
(define-key evil-normal-state-map (kbd "M-k") 'evil-window-prev)
(define-key evil-normal-state-map (kbd "M-K") 'evil-window-rotate-upwards)
(define-key evil-normal-state-map (kbd "M-l") 'evil-window-increase-width)
(define-key evil-normal-state-map (kbd "M-h") 'evil-window-decrease-width)
(define-key evil-normal-state-map (kbd "M-+") 'evil-window-increase-height)
(define-key evil-normal-state-map (kbd "M--") 'evil-window-decrease-height)
(define-key evil-normal-state-map (kbd "M-C") 'evil-window-delete)
(define-key evil-normal-state-map (kbd "M-w 0") 'balance-windows)
