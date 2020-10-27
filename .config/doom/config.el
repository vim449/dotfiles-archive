(map! :leader
      :desc "List bookmarks"
      "b L" #'list-bookmarks
      :leader
      :desc "Save current bookmarks to bookmark file"
      "b w" #'bookmark-save)

(setq centaur-tabs-set-bar 'over
      centaur-tabs-set-icons t
      centaur-tabs-gray-out-icons 'buffer
      centaur-tabs-height 24
      centaur-tabs-set-modified-marker t
      centaur-tabs-style "slant"
      centaur-tabs-modified-marker "•")
(map! :leader
      :desc "Toggle tabs on/off"
      "t c" #'centaur-tabs-local-mode)
(evil-define-key 'normal centaur-tabs-mode-map (kbd "g <right>") 'centaur-tabs-forward       ; default Doom binding is 'g t'
                                               (kbd "g <left>") 'centaur-tabs-backward       ; default Doom binding is 'g T'
                                               (kbd "g <down>") 'centaur-tabs-forward-group
                                               (kbd "g <up>") 'centaur-tabs-backward-group)

(map! :leader
      :desc "Dired"
      "d d" #'dired
      :leader
      :desc "Dired jump to current"
      "d j" #'dired-jump
      (:after dired
        (:map dired-mode-map
         :leader
         :desc "Peep-dired image previews"
         "d p" #'peep-dired
         :leader
         :desc "Dired view file"
         "d v" #'dired-view-file)))
(evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file
                                             (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(setq doom-theme 'doom-gruvbox)
(map! :leader
      :desc "Load new theme"
      "h t" #'counsel-load-theme)

(require 'emms-setup)
(require 'emms-info)
(require 'emms-cue)
(require 'emms-mode-line)
(require 'emms-playing-time)
(emms-all)
(emms-default-players)
(emms-mode-line 1)
(emms-playing-time 1)
(setq emms-source-file-default-directory "~/Music/Non-Classical/70s-80s/"
      emms-playlist-buffer-name "*Music*"
      emms-info-asynchronously t
      emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
(map! :leader
      :desc "Go to emms playlist"
      "a a" #'emms-playlist-mode-go
      :leader
      :desc "Emms pause track"
      "a x" #'emms-pause
      :leader
      :desc "Emms stop track"
      "a s" #'emms-stop
      :leader
      :desc "Emms play previous track"
      "a p" #'emms-previous
      :leader
      :desc "Emms play next track"
      "a n" #'emms-next)

(map! :leader
      :desc "Evaluate elisp in buffer"
      "e b" #'eval-buffer
      :leader
      :desc "Evaluate defun"
      "e d" #'eval-defun
      :leader
      :desc "Evaluate elisp expression"
      "e e" #'eval-expression
      :leader
      :desc "Evaluate last sexpression"
      "e l" #'eval-last-sexp
      :leader
      :desc "Evaluate elisp in region"
      "e r" #'eval-region)

(setq browse-url-browser-function 'eww-browse-url)
(map! :leader
      :desc "Eww web browser"
      "e w" #'eww
      :leader
      :desc "Eww reload page"
      "e R" #'eww-reload
      :leader
      :desc "Search web for text between BEG/END"
      "s w" #'eww-search-words)

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 12)
      doom-variable-pitch-font (font-spec :family "Hack" :size 12)
      doom-big-font (font-spec :family "FiraCode Nerd Font" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(map! :leader
      :desc "Ivy push view"
      "v p" #'ivy-push-view
      :leader
      :desc "Ivy switch view"
      "v s" #'ivy-switch-view)

(setq display-line-numbers-type 'relative)
(map! :leader
      :desc "Toggle truncate lines"
      "t t" #'toggle-truncate-lines)

(require 'ox-groff)

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)
(require 'smtpmail)
(setq mu4e-get-mail-command "mbsync -c ~/.config/doom/mu4e/.mbsyncrc -a"
      mu4e-update-interval  300
      user-mail-address "adamson.dom@gmail.com"
      user-full-name  "Dominic Adamson"
      mu4e-compose-signature
       (concat
         "Dominic Adamson\n"
         "Sent From Mu4e inside Doom Emacs\n")
      message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-starttls-credentials '(("smtp.1and1.com" 587 nil nil))
      smtpmail-auth-credentials '(("smtp.1and1.com" 587 "adamson.dom@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.1and1.com"
      smtpmail-smtp-server "smtp.1and1.com"
      smtpmail-smtp-service 587
      mu4e-sent-folder "/Sent"
      mu4e-drafts-folder "/Drafts"
      mu4e-trash-folder "/Trash"
      mu4e-refile-folder "/All Mail"
      mu4e-maildir-shortcuts
      '(("/personal/Inbox"    . ?i)
        ("/personal/Sent"     . ?s)
        ("/personal/All Mail" . ?a)
        ("/personal/Trash"    . ?t)))

(after! neotree
  (setq neo-smart-open t
        (setq doom-themes-neotree-files-icons t)
        neo-window-fixed-size nil))
(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t))
(map! :leader
      :desc "Toggle neotree file viewer"
      "t n" #'neotree-toggle)

(map! :leader
      :desc "Edit agenda file"
      "\\ a" #'(lambda () (interactive) (find-file "~/Documents/org/agenda.org"))
      :leader
      :desc "Edit doom config.org"
      "\\ c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
      :leader
      :desc "Edit eshell aliases"
      "\\ e" #'(lambda () (interactive) (find-file "~/.config/doom/aliases"))
      :leader
      :desc "Edit doom init.el"
      "\\ i" #'(lambda () (interactive) (find-file "~/.config/doom/init.el"))
      :leader
      :desc "Edit doom packages.el"
      "\\ p" #'(lambda () (interactive) (find-file "~/.config/doom/packages.el")))

(after! org
  (require 'org-bullets)  ; Nicer bullets in org-mode
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-directory "~/Documents/org/"
        org-agenda-files '("~/Documents/org/agenda.org")
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-log-done 'time
        org-log-done 'note
        org-journal-dir "~/Documents/org/journal/"
        org-journal-date-format "%B %d, %Y (%A)"
        org-journal-file-format "%Y-%m-%d.org"
        org-hide-emphasis-markers t
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("ddg" . "https://duckduckgo.com/?q=")
            ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '((sequence
             "TODO(t)"           ; A task that is ready to be tackled
             "School(s)"         ; School related assignments
             "PROJ(p)"           ; A project that contains other tasks
             "WAIT(w)"           ; Something is holding up this task
             "|"                 ; The pipe necessary to separate "active" states and "inactive" states
             "DONE(d)"           ; Task has been completed
             "CANCELLED(c)" )))) ; Task has been cancelled

(map! :leader
      :desc "Copy to register"
      "r c" #'copy-to-register
      :leader
      :desc "Frameset to register"
      "r f" #'frameset-to-register
      :leader
      :desc "Insert contents of register"
      "r i" #'insert-register
      :leader
      :desc "Jump to register"
      "r j" #'jump-to-register
      :leader
      :desc "List registers"
      "r l" #'list-registers
      :leader
      :desc "Number to register"
      "r n" #'number-to-register
      :leader
      :desc "Interactively choose a register"
      "r r" #'counsel-register
      :leader
      :desc "View a register"
      "r v" #'view-register
      :leader
      :desc "Window configuration to register"
      "r w" #'window-configuration-to-register
      :leader
      :desc "Increment register"
      "r +" #'increment-register
      :leader
      :desc "Point to register"
      "r SPC" #'point-to-register)

(setq shell-file-name "/bin/zsh"
      eshell-aliases-file "~/.doom.d/aliases")

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window"
      "b c" #'clone-indirect-buffer-other-window)

(require 'sublimity-scroll)
(require 'sublimity-map)
(require 'sublimity-attractive)
(sublimity-mode 0)

(map! :leader
      :desc "Winner redo"
      "w <right>" #'winner-redo
      :leader
      :desc "Winner undo"
      "w <left>" #'winner-undo)
