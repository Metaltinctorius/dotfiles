;; Doom Emacs configuration


(setq user-full-name ""
      user-mail-address "")

;; ---------Fonts--------
(setq doom-font (font-spec :family "Hasklug Nerd Font Mono" :size 15 :foundry 'ADBO :weight 'semi-bold :slant 'normal :width 'normal :spacing 100 :scalable 'true))
(setq doom-variable-pitch-font (font-spec :family "Hasklug Nerd font" :size 13))
(setq doom-serif-font (font-spec :family "Hasklug Nerd Font" :size 12))


;; ------- Loading the themes ------
(use-package! doom-themes
  :config
  (setq doom-theme 'doom-dracula))

(setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config)

;; ----- Projectile project paths -------
(setq projectile-project-search-path '("~/Skolrelaterat/Datorvetenskap/Code/" "~/Orgfiles/"))

;; ------ PATHS for certain plugins -----
;; Being explicit here to secure that emacs is looking for executables in these folders
(setenv "PATH" (concat (getenv "PATH") ":/home/nicke/.ghcup/bin/"))
(setq exec-path (append exec-path '("/home/nicke/.ghcup/bin/")))

(setenv "JAVA_HOME" "/usr/lib/jvm/java-17-openjdk-amd64")
(setq lsp-java-java-path "/usr/lib/jvm/java-17-openjdk-amd64/bin/java")


(setenv "PATH" (concat (getenv "PATH") ":/usr/lib/erlang/bin"))
(setq exec-path (append exec-path '("/usr/lib/erlang/bin")))




;; ------ Org-mode settings --------

;; --Org-agenda custom view---
(setq org-agenda-custom-commands
      '(("v" "A better view"
         ((tags "CATEGORY=\"Schedule\""
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Schedule:"))))
         (agenda "")
         (alltodo ""))))

;; -- Org directories --
(setq org-directory "~/Orgfiles/")
;;(setq org-agenda-files '("~/Orgfiles/deadlines.org"))

;; Days before scheduled tasks show up in org-agenda
(setq org-deadline-warning-days 31)

;; Hide bold, italics, color markers in the org documents
(setq org-hide-emphasis-markers t)

;; Headline size
(after! org
  (set-face-attribute 'org-level-1 nil :height 1.4)
  (set-face-attribute 'org-level-2 nil :height 1.2)
  (set-face-attribute 'org-level-3 nil :height 1.1)
  (set-face-attribute 'org-level-4 nil :height 1.0)
  (set-face-attribute 'org-level-5 nil :height 0.9))

;; List bullet symbols
(use-package! org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("λ" "◉" "○" "●" "○" "◆" "▶")))


;; ---- Show row numbers
(setq display-line-numbers-type t)

;; ---- Enable lsp-ui to show for hover frame info ----
(use-package! lsp-ui
  :config (setq lsp-ui-doc-enable t)
          (setq lsp-ui-doc-delay 2)
          (setq lsp-ui-doc-show-with-cursor t)
          (setq lsp-ui-doc-show-with-mouse t)
          (setq lsp-ui-doc-position 'top)
         ;; (setq lsp-ui-sideline-show-diagnostics t)
         ;; (setq lsp-ui-sideline-show-code-actions t)
          (setq lsp-ui-peek-enable t)
          (setq lsp-ui-peek-show-directory t)
          (setq lsp-ui-imenu-auto-refresh t))


;; ------ My custom configurations of certain packages --------
(use-package! yasnippet
  :config (yas-global-mode))
;;
(use-package! lsp-mode
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :config (setq lsp-completion-enable-additional-text-edit nil))
;;
(use-package! which-key
  :config (which-key-mode))
;;
(use-package! lsp-java
  :config (add-hook 'java-mode-hook 'lsp))
;; Debugger mode in Java
(use-package! dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))
;;
(use-package! dap-java)

;;
(use-package! projectile
  :config (projectile-mode))

(use-package! treemacs
  :config
  (setq treemacs-is-never-other-window t)
  (setq treemacs-follow-mode t))

(use-package! helm
  :config
  (setq helm-mode t))

(after! lsp-java
  (setq lsp-java-import-gradle-enabled t))

(use-package! lsp-haskell
  :after lsp-mode
  :config
  (setq lsp-haskell-plugin-ghcide-completions-config-auto-extend-on nil)
  (setq lsp-haskell-plugin-ghcide-type-lenses-global-on nil))

;; ---- Dim non-active buffers -----
;; Copied from web to enable buffer mode on startup
(add-hook 'after-init-hook (lambda ()
  (when (fboundp 'auto-dim-other-buffers-mode)
    (auto-dim-other-buffers-mode t))))

;; -------Enable Flyspell for certain buffers on startup----------
(use-package! flyspell
  :hook ((text-mode . flyspell-mode)
         (org-mode . flyspell-mode))
  :config
  (setq ispell-local-dictionary-alist
        '((nil "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-d" "en_US") nil utf-8)
          ("svenska" "[A-Za-zåäöÅÄÖéÉ]" "[^A-Za-zåäöÅÄÖéÉ]" "[']" nil ("-d" "svenska") nil utf-8)))
  (ispell-set-spellchecker-params))

;; --- OpenAI integration ----
(use-package! c3po
  :config
  (setq c3po-api-key "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"))

;; --- Use hlint instead of ghc for syntax checking---
;;  Advantage: giving more tips of what is wrong
(after! flycheck
  (setq-default flycheck-disabled-checkers '(haskell-ghc))
  (flycheck-add-next-checker 'haskell-ghc '(warning . haskell-hlint)))


;; -------Keybindings-------
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




;; --- hoogle keybind for info in buffer from point----
;; -- Also applies web-lookup in a new buffer with another keybind---

(use-package! haskell-mode
  :config
  (map! :map haskell-mode-map
        "C-c h" 'haskell-hoogle
        "C-c w" 'haskell-hoogle-lookup-from-website)

  ;; Set the Hoogle command to "hoogle"
  (setq haskell-hoogle-command "hoogle")
  (setq haskell-hoogle-lookup-from-website-command "hoogle web lookup"))


;; WINDOW NAVIGATING KEYBINDINGS --  SIMULATING XMONAD
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



  ;; --- Showcase of a regular emacs config, above is shown how the same configuration is setup in doom emacs----
;;(require 'haskell-mode)
;;(define-key haskell-mode-map "\C-ch" 'haskell-hoogle)
;(setq haskell-hoogle-command "hoogle"

;; ---- Does not seem to work anymore -----
;;(use-package! vterm
;;  :config
;;  (defun my-vterm-keybindings ()
;;    (map! :map vterm-mode-map
;;          "C-c k" #'vterm-send-interrupt
;;          "<C-backspace>" #'vterm-send-interrupt
;;          "C-c C-k" #'vterm-send-kill))

;;  (add-hook 'vterm-mode-hook #'my-vterm-keybindings))
