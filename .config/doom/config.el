;; [[file:../../../../tmp/config.org.TLC0fI::*OPTIONS][OPTIONS:1]]
(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space

(display-time-mode 1)                             ; Enable time in the mode-line

(if (equal "Battery status not available"
           (battery))
    (display-battery-mode 1)                        ; On laptops it's nice to know how much power you have
  (setq password-cache-expiry nil))               ; I can trust my desktops ... can't I? (no battery = desktop)

(global-subword-mode 1)                           ; Iterate through CamelCase words
(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")
;; OPTIONS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*WINDOWS][WINDOWS:1]]
(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))
(setq +ivy-buffer-preview t)
;; WINDOWS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*WINDOWS][WINDOWS:2]]
(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; Navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)
;; WINDOWS:2 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*FRAMES][FRAMES:1]]
(setq frame-title-format
      '(""
        (:eval
         (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?  buffer-file-name))
           "%b"))
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))
;; FRAMES:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*UI][UI:1]]
(defvar doom/frame-transparency '(100 . 100))
;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha doom/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,doom/frame-transparency))
(setq eros-eval-result-prefix "⟹ ")
;; UI:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*UI][UI:2]]
(setq doom-modeline-icon t
      doom-gruvbox-dark-variant "hard"
      doom-theme 'doom-gruvbox)
(map! :leader
      :desc "Load new theme" "t h" #'counsel-load-theme)
;; UI:2 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*UI][UI:3]]
(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
                                 '(coding-category-undecided coding-category-utf-8))
                           (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
                t)))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)
;; UI:3 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*EMOJI][EMOJI:1]]
(defvar emojify-disabled-emojis
  '(;; Org
    "◼" "☑" "☸" "⚙" "⏩" "⏪" "⬆" "⬇" "❓"
    ;; Terminal powerline
    "✔"
    ;; Box drawing
    "▶" "◀")
  "Charachters that should never be affected by `emojify-mode'.")

(defadvice! emojify-delete-from-data ()
  "Ensure `emojify-disabled-emojis' don't appear in `emojify-emojis'."
  :after #'emojify-set-emoji-data
  (dolist (emoji emojify-disabled-emojis)
    (remhash emoji emojify-emojis)))
(add-hook! '(mu4e-compose-mode org-msg-edit-mode circe-channel-mode) (emoticon-to-emoji 1))
;; EMOJI:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*SPLASH][SPLASH:1]]
(defvar fancy-splash-image-template
  (expand-file-name "misc/splash-images/blackhole-lines-template.svg" doom-private-dir)
  "Default template svg used for the splash image, with substitutions from ")
(defvar fancy-splash-image-nil
  (expand-file-name "misc/splash-images/transparent-pixel.png" doom-private-dir)
  "An image to use at minimum size, usually a transparent pixel")

(setq fancy-splash-sizes
      `((:height 500 :min-height 50 :padding (0 . 4) :template ,(expand-file-name "misc/splash-images/blackhole-lines-0.svg" doom-private-dir))
        (:height 440 :min-height 42 :padding (1 . 4) :template ,(expand-file-name "misc/splash-images/blackhole-lines-0.svg" doom-private-dir))
        (:height 400 :min-height 38 :padding (1 . 4) :template ,(expand-file-name "misc/splash-images/blackhole-lines-1.svg" doom-private-dir))
        (:height 350 :min-height 36 :padding (1 . 3) :template ,(expand-file-name "misc/splash-images/blackhole-lines-2.svg" doom-private-dir))
        (:height 300 :min-height 34 :padding (1 . 3) :template ,(expand-file-name "misc/splash-images/blackhole-lines-3.svg" doom-private-dir))
        (:height 250 :min-height 32 :padding (1 . 2) :template ,(expand-file-name "misc/splash-images/blackhole-lines-4.svg" doom-private-dir))
        (:height 200 :min-height 30 :padding (1 . 2) :template ,(expand-file-name "misc/splash-images/blackhole-lines-5.svg" doom-private-dir))
        (:height 100 :min-height 24 :padding (1 . 2) :template ,(expand-file-name "misc/splash-images/emacs-e-template.svg" doom-private-dir))
        (:height 0   :min-height 0  :padding (0 . 0) :file ,fancy-splash-image-nil)))

(defvar fancy-splash-sizes
  `((:height 500 :min-height 50 :padding (0 . 2))
    (:height 440 :min-height 42 :padding (1 . 4))
    (:height 330 :min-height 35 :padding (1 . 3))
    (:height 200 :min-height 30 :padding (1 . 2))
    (:height 0   :min-height 0  :padding (0 . 0) :file ,fancy-splash-image-nil))
  "list of plists with the following properties
  :height the height of the image
  :min-height minimum `frame-height' for image
  :padding `+doom-dashboard-banner-padding' to apply
  :template non-default template file
  :file file to use instead of template")

(defvar fancy-splash-template-colours
  '(("$colour1" . keywords) ("$colour2" . type) ("$colour3" . base5) ("$colour4" . base8))
  "list of colour-replacement alists of the form (\"$placeholder\" . 'theme-colour) which applied the template")

(unless (file-exists-p (expand-file-name "theme-splashes" doom-cache-dir))
  (make-directory (expand-file-name "theme-splashes" doom-cache-dir) t))

(defun fancy-splash-filename (theme-name height)
  (expand-file-name (concat (file-name-as-directory "theme-splashes")
                            theme-name
                            "-" (number-to-string height) ".svg")
                    doom-cache-dir))

(defun fancy-splash-clear-cache ()
  "Delete all cached fancy splash images"
  (interactive)
  (delete-directory (expand-file-name "theme-splashes" doom-cache-dir) t)
  (message "Cache cleared!"))

(defun fancy-splash-generate-image (template height)
  "Read TEMPLATE and create an image if HEIGHT with colour substitutions as
   described by `fancy-splash-template-colours' for the current theme"
  (with-temp-buffer
    (insert-file-contents template)
    (re-search-forward "$height" nil t)
    (replace-match (number-to-string height) nil nil)
    (dolist (substitution fancy-splash-template-colours)
      (goto-char (point-min))
      (while (re-search-forward (car substitution) nil t)
        (replace-match (doom-color (cdr substitution)) nil nil)))
    (write-region nil nil
                  (fancy-splash-filename (symbol-name doom-theme) height) nil nil)))

(defun fancy-splash-generate-images ()
  "Perform `fancy-splash-generate-image' in bulk"
  (dolist (size fancy-splash-sizes)
    (unless (plist-get size :file)
      (fancy-splash-generate-image (or (plist-get size :file)
                                       (plist-get size :template)
                                       fancy-splash-image-template)
                                   (plist-get size :height)))))

(defun ensure-theme-splash-images-exist (&optional height)
  (unless (file-exists-p (fancy-splash-filename
                          (symbol-name doom-theme)
                          (or height
                              (plist-get (car fancy-splash-sizes) :height))))
    (fancy-splash-generate-images)))

(defun get-appropriate-splash ()
  (let ((height (frame-height)))
    (cl-some (lambda (size) (when (>= height (plist-get size :min-height)) size))
             fancy-splash-sizes)))

(setq fancy-splash-last-size nil)
(setq fancy-splash-last-theme nil)
(defun set-appropriate-splash (&rest _)
  (let ((appropriate-image (get-appropriate-splash)))
    (unless (and (equal appropriate-image fancy-splash-last-size)
                 (equal doom-theme fancy-splash-last-theme)))
    (unless (plist-get appropriate-image :file)
      (ensure-theme-splash-images-exist (plist-get appropriate-image :height)))
    (setq fancy-splash-image
          (or (plist-get appropriate-image :file)
              (fancy-splash-filename (symbol-name doom-theme) (plist-get appropriate-image :height))))
    (setq +doom-dashboard-banner-padding (plist-get appropriate-image :padding))
    (setq fancy-splash-last-size appropriate-image)
    (setq fancy-splash-last-theme doom-theme)
    (+doom-dashboard-reload)))

(add-hook 'window-size-change-functions #'set-appropriate-splash)
(add-hook 'doom-load-theme-hook #'set-appropriate-splash)
;; SPLASH:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*DAEMON][DAEMON:1]]
(defun greedily-do-daemon-setup ()
  (require 'org)
  (when (require 'mu4e nil t)
    (setq mu4e-confirm-quit t)
    (setq +mu4e-lock-greedy t)
    (setq +mu4e-lock-relaxed t)
    (+mu4e-lock-add-watcher)
    (when (+mu4e-lock-available t)
      (mu4e~start)))
  (when (require 'elfeed nil t)
    (run-at-time nil (* 8 60 60) #'elfeed-update)))

(when (daemonp)
  (add-hook 'emacs-startup-hook #'greedily-do-daemon-setup))
;; DAEMON:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*BOOKMARKS AND BUFFERS][BOOKMARKS AND BUFFERS:1]]
(map! :leader
      (:prefix ("b" . "buffer")
       :desc "List bookmarks" "L" #'list-bookmarks
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))
;; BOOKMARKS AND BUFFERS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*CENTAUR-TABS][CENTAUR-TABS:1]]
(setq centaur-tabs-set-bar 'over
      centaur-tabs-set-icons t
      centaur-tabs-gray-out-icons 'buffer
      centaur-tabs-height 24
      centaur-tabs-set-modified-marker t
      centaur-tabs-style "slant"
      centaur-tabs-modified-marker "•")
(map! :leader
      :desc "Toggle tab locally" "t C" #'centaur-tabs-local-mode
      :desc "Toggle tabs on/off" "t c" #'centaur-tabs-mode)
;; CENTAUR-TABS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*DIRED][DIRED:1]]
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
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))
;; DIRED:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*EVALUATE ELISP EXPRESSIONS][EVALUATE ELISP EXPRESSIONS:1]]
(map! :leader
      (:prefix ("e" . "evaluate/eww")
       :desc "Evaluate elisp in buffer" "b" #'eval-buffer
       :desc "Evaluate defun" "d" #'eval-defun
       :desc "Evaluate elisp expression" "e" #'eval-expression
       :desc "Evaluate last sexpression" "l" #'eval-last-sexp
       :desc "Evaluate elisp in region" "r" #'eval-region))
;; EVALUATE ELISP EXPRESSIONS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*EWW][EWW:1]]
(setq browse-url-browser-function 'eww-browse-url)
(map! :leader
      (:prefix ("e" . "evaluate/Eww")
       :desc "Eww web browser" "w" #'eww
       :desc "Eww reload page" "R" #'eww-reload
       :desc "Seach web for text in region" "s" #'eww-search-words
       :desc "Copy URL to clipboard" "c" #'eww-copy-page-url))
;; EWW:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*FONTS][FONTS:1]]
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
;; FONTS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*IVY-POSFRAME][IVY-POSFRAME:1]]
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
;; IVY-POSFRAME:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*IVY KEYBINDINGS][IVY KEYBINDINGS:1]]
(map! :leader
      (:prefix ("w i" . "ivy")
       :desc "Push view" "p" #'ivy-push-view
       :desc "Switch view" "s" #'ivy-switch-view
       :desc "Pop view" "P" #'ivy-pop-view))
;; IVY KEYBINDINGS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*LINE SETTINGS][LINE SETTINGS:1]]
(setq display-line-numbers-type 'relative)
(map! :leader
      :desc "Toggle truncate lines" "t t" #'toggle-truncate-lines)
;; LINE SETTINGS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*MU4E][MU4E:1]]
(require 'smtpmail)
(after! mu4e
  (setq mu4e-root-maildir "~/.local/share/mail"
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
;; MU4E:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*NEOTREE][NEOTREE:1]]
(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil
        doom-themes-neotree-file-icons t))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Toggle neotree file viewer"
      "t n" #'neotree-toggle)
;; NEOTREE:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*LSP][LSP:1]]
(defun doom/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-ui-mode 1)
  (lsp-headerline-breadcrumb-mode 1)
  (lsp-ui-peek-enable 1)
  (setq lsp-ui-sideline-show-hover t))

(use-package! lsp-mode
  :hook (lsp-mode . doom/lsp-mode-setup))
;; LSP:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*LSP Servers][LSP Servers:1]]
(after! rustic
  (setq rustic-lsp-server 'rls))
(after! ccls
  (setq ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
  (set-lsp-priority! 'ccls 2))
;; LSP Servers:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*TREE-SITTER][TREE-SITTER:1]]
(use-package! tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
;; TREE-SITTER:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*COMPANY MODE][COMPANY MODE:1]]
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
  (company-show-numbers t)
  (company-idle-delay 0.2))

(setq-default history-length 1000
              prescient-history-length 1000
              yas-triggers-in-field t)
;; COMPANY MODE:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*PROJECTILE MODE][PROJECTILE MODE:1]]
(setq projectile-project-search-path '("~/Documents/code/" "~/.config/"))
;; PROJECTILE MODE:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*OPEN SPECIFIC FILES][OPEN SPECIFIC FILES:1]]
(map! :leader
      (:prefix ("-" . "open file")
       :desc "Edit agenda file" "a" #'(lambda () (interactive) (find-file "~/Documents/org/agenda.org"))
       :desc "Edit doom config.org" "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
       :desc "Edit eshell aliases" "e" #'(lambda () (interactive) (find-file "~/.config/doom/aliases"))
       :desc "Edit doom init.el" "i" #'(lambda () (interactive) (find-file "~/.config/doom/init.el"))
       :desc "Edit doom packages.el" "p" #'(lambda () (interactive) (find-file "~/.config/doom/packages.el"))))
;; OPEN SPECIFIC FILES:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*EXPORTERS][EXPORTERS:1]]
(require 'ox-groff)
(use-package! engrave-faces-latex
   :after ox-latex)
;; EXPORTERS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*UI][UI:1]]
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

(use-package! org-pretty-table
  :commands (org-pretty-table-mode global-org-pretty-table-mode))
;; UI:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*GENERAL SETUP][GENERAL SETUP:1]]
(after! org
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
  (add-hook 'org-mode-hook 'doom/org-font-setup)
  (setq org-directory "~/Documents/org/"
        org-use-property-inheritance t
        org-agenda-files '("~/Documents/org/agenda.org")
        +org-capture-todo-file "agenda.org"
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-log-done 'time
        org-log-done 'note
        org-list-allow-alphabetical t
        org-export-in-background t
        org-hide-emphasis-markers t
        org-catch-invisible-edits 'smart
        org-todo-keywords      ; This overwrites the default Doom org-todo-keywords
        '((sequence
           "TODO(t)"           ; A task that is ready to tackle
           "SCHOOL(s)"         ; School related assignments
           "PROJ(p)"           ; A project that contains other tasks
           "WAIT(w)"           ; Something is holding up this task
           "|"                 ; The pipe necessary to separate "active" states and "inactive" states
           "DONE(d)"           ; Task has completed
           "CANCELLED(c)"))) ; Task has cancelled
  (setq org-babel-default-header-args
        '((:session . "none")
          (:results . "replace")
          (:exports . "code")
          (:cache . "no")
          (:noweb . "no")
          (:hlines . "no")
          (:tangle . "no")
          (:comments . "link")))
  (remove-hook 'text-mode-hook #'visual-line-mode)
  (add-hook 'text-mode-hook #'auto-fill-mode)
  (add-hook 'org-mode-hook 'turn-on-flyspell)
  (map! :map evil-org-mode-map
        :after evil-org
        :n "g <up>" #'org-backward-heading-same-level
        :n "g <down>" #'org-forward-heading-same-level
        :n "g <left>" #'org-up-element
        :n "g <right>" #'org-down-element
        :n "g k" #'org-backward-heading-same-level
        :n "g j" #'org-forward-heading-same-level
        :n "g h" #'org-up-element
        :n "g l" #'org-down-element))
(use-package! org-chef
  :commands (org-chef-insert-recipe org-chef-get-recipe-from-url))
(use-package! org-ref
  :after org
  :config
  (setq org-ref-completion-library 'org-ref-ivy-cite))
;; GENERAL SETUP:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*LSP][LSP:1]]
(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (setq centaur-lsp 'lsp-mode)
  (cl-check-type lang stringp)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
         (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
         (let ((file-name (->> info caddr (alist-get :file))))
           (unless file-name
             (setq file-name (make-temp-file "babel-lsp-")))
           (setq buffer-file-name file-name)
           (lsp-deferred)))
       (put ',intern-pre 'function-documentation
            (format "Enable lsp-mode in the buffer of org source block (%s)."
                    (upcase ,lang)))
       (if (fboundp ',edit-pre)
           (advice-add ',edit-pre :after ',intern-pre)
         (progn
           (defun ,edit-pre (info)
             (,intern-pre info))
           (put ',edit-pre 'function-documentation
                (format "Prepare local buffer environment for org source block (%s)."
                        (upcase ,lang))))))))
(defvar org-babel-lang-list
  '("go" "python" "ipython" "bash" "sh"))
(dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))
;; LSP:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*REGISTERS][REGISTERS:1]]
(map! :leader
      (:prefix ("R" . "registers")
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
;; REGISTERS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*SHELLS][SHELLS:1]]
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
;; SHELLS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*SPLITS][SPLITS:1]]
(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window"
      "b c" #'clone-indirect-buffer-other-window)
;; SPLITS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*WINNER MODE][WINNER MODE:1]]
(map! :leader
      :desc "Winner redo" "w <right>" #'winner-redo
      :desc "Winner undo" "w <left>" #'winner-undo)
;; WINNER MODE:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*QUICKSCOPE][QUICKSCOPE:1]]
(global-evil-quickscope-always-mode 1)
;; QUICKSCOPE:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*SPELLCHECK][SPELLCHECK:1]]
(setq ispell-dictionary "en")
;; SPELLCHECK:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*PASSWORDS][PASSWORDS:1]]
(setq auth-sources '("~/.authinfo.gpg"))
(defun lookup-password (&rest keys)
  (let ((result (apply #'auth-source-search keys)))
    (if result
        (funcall (plist-get (car result) :secret))
      nil)))
;; PASSWORDS:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*SKELETOR][SKELETOR:1]]
(setq skeletor-project-directory "~/Documents/code"
      skeletor-user-directory "~/Documents/code/skeletons")
;; SKELETOR:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*SCREENKEY][SCREENKEY:1]]
(use-package! keycast
  :commands keycast-mode
  :config
  (define-minor-mode keycast-mode
    "Show current command and its key binding in the mode line."
    :global t
    (if keycast-mode
        (progn
          (add-hook 'pre-command-hook 'keycast--update t)
          (add-to-list 'global-mode-string '("" mode-line-keycast " ")))
      (remove-hook 'pre-command-hook 'keycast--update)
      (setq global-mode-string (remove '("" mode-line-keycast " ") global-mode-string))))
  (custom-set-faces!
    '(keycast-command :inherit doom-modeline-debug
                      :height 0.9)
    '(keycast-key :inherit custom-modified
                  :height 1.1
                  :weight bold)))
(use-package! gif-screencast
  :commands gif-screencast-mode
  :config
  (map! :map gif-screencast-mode-map
        :g "<f8>" #'gif-screencast-toggle-pause
        :g "<f9>" #'gif-screencast-stop)
  (setq gif-screencast-program "maim"
        gif-screencast-args `("--quality" "3" "-i" ,(string-trim-right
                                                     (shell-command-to-string
                                                      "xdotool getactivewindow")))
        gif-screencast-optimize-args '("--batch" "--optimize=3" "--usecolormap=/tmp/doom-color-theme"))
  (defun gif-screencast-write-colormap ()
    (f-write-text
     (replace-regexp-in-string
      "\n+" "\n"
      (mapconcat (lambda (c) (if (listp (cdr c))
                                 (cadr c))) doom-themes--colors "\n"))
     'utf-8
     "/tmp/doom-color-theme" ))
  (gif-screencast-write-colormap)
  (add-hook 'doom-load-theme-hook #'gif-screencast-write-colormap))
;; SCREENKEY:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*VERY LARGE FILES MODE][VERY LARGE FILES MODE:1]]
(use-package! vlf-setup
  :defer-incrementally vlf-tune vlf-base vlf-write vlf-search vlf-occur vlf-follow vlf-ediff vlf)
;; VERY LARGE FILES MODE:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*EMACS EVERYWHERE][EMACS EVERYWHERE:1]]
(when (daemonp)
  (require 'spell-fu)
  (setq emacs-everywhere-major-mode-function #'org-mode
        emacs-everywhere-frame-name-format "Edit ∷ %s — %s")
  (require 'emacs-everywhere))
;; EMACS EVERYWHERE:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*WHICH-KEY][WHICH-KEY:1]]
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))
;; WHICH-KEY:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*ZEN][ZEN:1]]
(setq +zen-text-scale 0.8)
;; ZEN:1 ends here

;; [[file:../../../../tmp/config.org.TLC0fI::*ZEN][ZEN:2]]
(defvar +zen-serif-p t
  "Whether to use a serifed font with `mixed-pitch-mode'.")
(after! writeroom-mode
  (defvar-local +zen--original-org-indent-mode-p nil)
  (defvar-local +zen--original-mixed-pitch-mode-p nil)
  (defvar-local +zen--original-solaire-mode-p nil)
  (defvar-local +zen--original-org-pretty-table-mode-p nil)
  (defun +zen-enable-mixed-pitch-mode-h ()
    "Enable `mixed-pitch-mode' when in `+zen-mixed-pitch-modes'."
    (when (apply #'derived-mode-p +zen-mixed-pitch-modes)
      (if writeroom-mode
          (progn
            (setq +zen--original-solaire-mode-p solaire-mode)
            (solaire-mode -1)
            (setq +zen--original-mixed-pitch-mode-p mixed-pitch-mode)
            (funcall (if +zen-serif-p #'mixed-pitch-serif-mode #'mixed-pitch-mode) 1))
        (funcall #'mixed-pitch-mode (if +zen--original-mixed-pitch-mode-p 1 -1))
        (when +zen--original-solaire-mode-p (solaire-mode 1)))))
  (pushnew! writeroom--local-variables
            'display-line-numbers
            'visual-fill-column-width
            'org-adapt-indentation
            'org-superstar-headline-bullets-list
            'org-superstar-remove-leading-stars)
  (add-hook 'writeroom-mode-enable-hook
            (defun +zen-prose-org-h ()
              "Reformat the current Org buffer appearance for prose."
              (when (eq major-mode 'org-mode)
                (setq display-line-numbers nil
                      visual-fill-column-width 60
                      org-adapt-indentation nil)
                (when (featurep 'org-superstar)
                  (setq-local org-superstar-headline-bullets-list '("🙘" "🙙" "🙚" "🙛")
                              ;; org-superstar-headline-bullets-list '("🙐" "🙑" "🙒" "🙓" "🙔" "🙕" "🙖" "🙗")
                              org-superstar-remove-leading-stars t)
                  (org-superstar-restart))
                (setq
                 +zen--original-org-indent-mode-p org-indent-mode
                 +zen--original-org-pretty-table-mode-p (bound-and-true-p org-pretty-table-mode))
                (org-indent-mode -1)
                (org-pretty-table-mode 1))))
  (add-hook 'writeroom-mode-disable-hook
            (defun +zen-nonprose-org-h ()
              "Reverse the effect of `+zen-prose-org'."
              (when (eq major-mode 'org-mode)
                (when (featurep 'org-superstar)
                  (org-superstar-restart))
                (when +zen--original-org-indent-mode-p (org-indent-mode 1))
                ;; (unless +zen--original-org-pretty-table-mode-p (org-pretty-table-mode -1))
                ))))
;; ZEN:2 ends here
