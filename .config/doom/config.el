(defvar doom/frame-transparency '(100 . 100))
;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha doom/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,doom/frame-transparency))

(map! :leader
      (:prefix ("b" . "buffer")
       :desc "List bookmarks" "L" #'list-bookmarks
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))

(setq centaur-tabs-set-bar 'over
      centaur-tabs-set-icons t
      centaur-tabs-gray-out-icons 'buffer
      centaur-tabs-height 24
      centaur-tabs-set-modified-marker t
      centaur-tabs-style "slant"
      centaur-tabs-modified-marker "•")
(map! :leader
      :desc "Toggle tabs on/off" "t c" #'centaur-tabs-local-mode)

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))
(evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(setq doom-modeline-icon t
      doom-gruvbox-dark-variant "hard"
      doom-theme 'doom-gruvbox)
(map! :leader
      :desc "Load new theme" "t h" #'counsel-load-theme)

(require 'emms-setup)
(require 'emms-info)
(require 'emms-cue)
(require 'emms-mode-line)
(require 'emms-playing-time)
(emms-all)
(emms-default-players)
(emms-mode-line 1)
(emms-playing-time 1)
(setq emms-source-file-default-directory "~/Music"
      emms-playlist-buffer-name "*Music*"
      emms-info-asynchronously t
      emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
(map! :leader
      (:prefix ("a" . "emms")
       :desc "Go to emms playlist" "a" #'emms-playlist-mode-go
       :desc "Emms pause track" "x" #'emms-pause
       :desc "Emms stop track" "s" #'emms-stop
       :desc "Emms play previous track" "p" #'emms-previous
       :desc "Emms play next track" "n" #'emms-next))

(map! :leader
      (:prefix ("e" . "evaluate/eww")
       :desc "Evaluate elisp in buffer" "b" #'eval-buffer
       :desc "Evaluate defun" "d" #'eval-defun
       :desc "Evaluate elisp expression" "e" #'eval-expression
       :desc "Evaluate last sexpression" "l" #'eval-last-sexp
       :desc "Evaluate elisp in region" "r" #'eval-region))

(setq browse-url-browser-function 'eww-browse-url)
(map! :leader
      (:prefix ("e" . "evaluate/Eww")
       :desc "Eww web browser" "w" #'eww
       :desc "Eww reload page" "R" #'eww-reload
       :desc "Seach web for text in region" "s" #'eww-search-words
       :desc "Copy URL to clipboard" "c" #'eww-copy-page-url))

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 12)
      doom-variable-pitch-font (font-spec :family "DejaVuSerif" :size 12)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 17))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))
(setq all-the-icons-scale-factor 1.2)

(require 'ivy-posframe)
(setq ivy-posframe-display-functions-alist
      '((swiper                     . ivy-posframe-display-at-point)
        (complete-symbol            . ivy-posframe-display-at-point)
        (counsel-M-x                . ivy-display-function-fallback)
        (counsel-esh-history        . ivy-posframe-display-at-window-center)
        (counsel-describe-function  . ivy-display-function-fallback)
        (counsel-describe-variable  . ivy-display-function-fallback)
        (counsel-find-file          . ivy-display-function-fallback)
        (counsel-recentf            . ivy-display-function-fallback)
        (counsel-register           . ivy-posframe-display-at-frame-bottom-window-center)
        (dmenu                      . ivy-posframe-display-at-frame-top-center)
        (nil                        . ivy-posframe-display))
      ivy-posframe-height-alist
      '((swiper . 20)
        (dmenu . 20)
        (t . 10)))
(ivy-posframe-mode 1) ; 1 enables posframe-mode, 0 disables it.

(map! :leader
      (:prefix ("w i" . "ivy")
       :desc "Push view" "p" #'ivy-push-view
       :desc "Switch view" "s" #'ivy-switch-view
       :desc "Pop view" "P" #'ivy-pop-view))

(setq display-line-numbers-type 'relative)
(map! :leader
      :desc "Toggle truncate lines" "t t" #'toggle-truncate-lines)

(require 'smtpmail)
(after! mu4e
  (setq mu4e-maildir "~/.local/share/mail"
        mu4e-get-mail-command "mbsync -c ~/.config/mbsync/mbsyncrc -a"
       mu4e-update-interval (* 10 60))

  (setq mu4e-contexts
        (list
         ;; Personal account
         (make-mu4e-context
          :name "Personal"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/Personal" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "adamson.dom@gmail.com")
                  (user-full-name    . "Dominic Adamson")
                  (mu4e-compose-signature . "Dominic Adamson via GMail")
                  (smtpmail-smtp-server  . "smtp.gmail.com")
                  (smtpmail-smtp-service . 587)
                  (mu4e-drafts-folder  . "/Personal/[Gmail]/Drafts")
                  (mu4e-sent-folder  . "/Personal/[Gmail]/Sent Mail")
                  (mu4e-refile-folder  . "/Personal/[Gmail]/All Mail")
                  (mu4e-trash-folder  . "/Personal/[Gmail]/Trash")))

         ;; School account
         (make-mu4e-context
          :name "School"
          :match-func
          (lambda (msg)
            (when msg
              (string-prefix-p "/SLCC" (mu4e-message-field msg :maildir))))
          :vars '((user-mail-address . "dadam126@bruinmail.slcc.edu")
                  (user-full-name    . "Dominic Adamson")
                  (mu4e-compose-signature . "Dominic Adamson\n Sent from mozilla thunderbird\n")
                  (smtpmail-smtp-server  . "smtp.gmail.com")
                  (smtpmail-smtp-service . 587)
                  (mu4e-drafts-folder  . "/SLCC/[Gmail]/Drafts")
                  (mu4e-sent-folder  . "/SLCC/[Gmail]/Sent Mail")
                  (mu4e-refile-folder  . "/SLCC/[Gmail]/All Mail")
                  (mu4e-trash-folder  . "/SLCC/[Gmail]/Trash")))))

  (setq mu4e-maildir-shortcuts
        '(("/Personal/Inbox"             . ?i)
          ("/Personal/[Gmail]/Sent Mail" . ?s)
          ("/Personal/[Gmail]/Trash"     . ?t)
          ("/Personal/[Gmail]/Drafts"    . ?d)
          ("/Personal/[Gmail]/All Mail"  . ?a)

          ("/SLCC/Inbox"                 . ?k)
          ("/SLCC/[Gmail]/Sent Mail"     . ?w)
          ("/SLCC/[Gmail]/Trash"         . ?g)
          ("/SLCC/[Gmail]/Drafts"        . ?e)
          ("/SLCC/[Gmail]/All Mail"      . ?q))))

(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil
        doom-themes-neotree-file-icons t))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Toggle neotree file viewer"
      "t n" #'neotree-toggle)

(defun doom/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-ui-mode 1)
  (lsp-headerline-breadcrumb-mode 1)
  (lsp-ui-peek-enable 1)
  (setq lsp-ui-sideline-show-hover t))

(use-package! lsp-mode
  :hook (lsp-mode . doom/lsp-mode-setup))

(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package! company
  :after lsp-mode
  :hook ((lsp-mode . company-mode)
         (emacs-lisp-mode . company-mode))
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
   ("<tab>" . company-complete-selection))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1))

(setq projectile-project-search-path '("~/Documents/code/" "~/.config/"))

(map! :leader
      (:prefix ("-" . "open file")
       :desc "Edit agenda file" "a" #'(lambda () (interactive) (find-file "~/Documents/org/agenda.org"))
       :desc "Edit doom config.org" "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
       :desc "Edit eshell aliases" "e" #'(lambda () (interactive) (find-file "~/.config/doom/aliases"))
       :desc "Edit doom init.el" "i" #'(lambda () (interactive) (find-file "~/.config/doom/init.el"))
       :desc "Edit doom packages.el" "p" #'(lambda () (interactive) (find-file "~/.config/doom/packages.el"))))

(require 'ox-groff)

(defun doom/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.15)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch)
  (setq visual-fill-column-width 170
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

;; This is needed as of Org 9.2
(add-to-list 'org-modules 'org-tempo t)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(after! org
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
  (add-hook 'org-mode-hook 'doom/org-font-setup)
  (setq org-directory "~/Documents/org/"
        org-agenda-files '("~/Documents/org/agenda.org")
        +org-capture-todo-file "agenda.org"
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-log-done 'time
        org-log-done 'note
        org-journal-dir "~/Documents/org/journal/"
        org-journal-date-format "%B %d, %Y (%A)"
        org-journal-file-format "%Y-%m-%d.org"
        org-hide-emphasis-markers t
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
        '((sequence
           "TODO(t)"           ; A task that is ready to tackle
           "SCHOOL(s)"         ; School related assignments
           "PROJ(p)"           ; A project that contains other tasks
           "WAIT(w)"           ; Something is holding up this task
           "|"                 ; The pipe necessary to separate "active" states and "inactive" states
           "DONE(d)"           ; Task has completed
           "CANCELLED(c)" )))) ; Task has cancelled

(map! :leader
      (:prefix ("r" . "registers")
       :desc "Copy to register" "c" #'copy-to-register
       :desc "Frameset to register" "f" #'frameset-to-register
       :desc "Insert contents of register" "i" #'insert-register
       :desc "Jump to register" "j" #'jump-to-register
       :desc "List registers" "l" #'list-registers
       :desc "Number to register" "n" #'number-to-register
       :desc "Interactively choose a register" "r" #'counsel-register
       :desc "View a register" "v" #'view-register
       :desc "Window configuration to register" "w" #'window-configuration-to-register
       :desc "Increment register" "+" #'increment-register
       :desc "Point to register" "SPC" #'point-to-register))

(setq shell-file-name "/bin/zsh"
      eshell-aliases-file "~/.config/doom/aliases"
      eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("bash" "htop" "ssh" "zsh")
      vterm-max-scrollback 5000)
(map! :leader
      :desc "Counsel eshell history"
      "e h" #'counsel-esh-history)

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window"
      "b c" #'clone-indirect-buffer-other-window)

(map! :leader
      :desc "Winner redo" "w <right>" #'winner-redo
      :desc "Winner undo" "w <left>" #'winner-undo)

(global-evil-quickscope-always-mode 1)

(setq ispell-dictionary "en")

(setq auth-sources '("~/.authinfo.gpg"))
(defun lookup-password (&rest keys)
  (let ((result (apply #'auth-source-search keys)))
    (if result
        (funcall (plist-get (car result) :secret))
      nil)))
