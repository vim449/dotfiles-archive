(setq doom-font (font-spec :family "Hack" :size 12)
      doom-variable-pitch-font (font-spec :family "Hack" :size 12)
      ;; doom-big-font (font-spec :family "Hack" :size 14)
      )

(setq doom-theme 'doom-gruvbox)
(map! :leader
      :desc "Load new theme"
      "h t" #'counsel-load-theme)

(after! org
  (setq org-directory "~/Org/"
        org-agenda-files '("~/Org/agenda.org")
        org-log-done 'time
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        org-link-abbrev-alist
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("ddg" . "https://duckduckgo.com/?q=")
            ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-todo-keywords '((sequence "TODO(t)" "PROJ(p)" "VIDEO(v)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c)" )))
  ;; Nicer bullets in org-mode
  (require 'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq display-line-numbers-type t)
(map! :leader
      :desc "Toggle truncate lines"
      "l t" #'toggle-truncate-lines)

(setq neo-window-fixed-size nil)

(require 'ox-groff)

(setq browse-url-browser-function 'eww-browse-url)

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)

(setq centaur-tabs-set-bar 'over
      centaur-tabs-set-icons t
      centaur-tabs-gray-out-icons 'buffer
      centaur-tabs-height 24
      centaur-tabs-set-modified-marker t
      centaur-tabs-style "bar"
      centaur-tabs-modified-marker "•")
(map! :leader
      :desc "Toggle tabs on/off"
      "t o" #'centaur-tabs-local-mode
      :leader
      :desc "Switch tab groups"
      "t s" #'centaur-tabs-counsel-switch-group
      :leader
      :desc "Toggle tab groups"
      "t t" #'centaur-tabs-toggle-groups
      :leader
      :desc "Kill all buffers in group"
      "t k" #'centaur-tabs-kill-all-buffer-in-current-group
      :leader
      :desc "Next tab"
      "t n" #'centaur-tabs-forward
      :leader
      :desc "Previous tab"
      "t p" #'centaur-tabs-backward)

(map!
  (:after dired
    (:map dired-mode-map
     :leader
     "l i" #'peep-dired
     )))
(evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file
                                             (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(use-package emms
  :ensure t
  :config
  (require 'emms-setup)
  (require 'emms-info)
  (require 'emms-cue)
  (require 'emms-mode-line)
  (require 'emms-playing-time)
  (setq emms-source-file-default-directory "~/Music/Non-Classical/70s-80s/")
  (setq emms-playlist-buffer-name "*Music*")
  (setq emms-info-asynchronously t)
  (unless (eq system-type 'windows-nt)
    (setq emms-source-file-directory-tree-function
          'emms-source-file-directory-tree-find))
  (emms-all)
  (emms-default-players)
  (emms-mode-line 1)
  (emms-playing-time 1))

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'mu4e)
(setq mu4e-get-mail-command "mbsync -c ~/.config/doom/mu4e/.mbsyncrc -a"
      mu4e-update-interval  300)
(setq
   user-mail-address "adamson.dom@gmail.com"
   user-full-name  "Dominic Adamson"
   mu4e-compose-signature
    (concat
     "Dominic Adamson\n"
     "Sent From Mu4e inside Doom Emacs"))
(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
   starttls-use-gnutls t
   smtpmail-starttls-credentials '(("smtp.1and1.com" 587 nil nil))
   smtpmail-auth-credentials
     '(("smtp.1and1.com" 587 "adamson.dom@gmail.com" nil))
   smtpmail-default-smtp-server "smtp.1and1.com"
   smtpmail-smtp-server "smtp.1and1.com"
   smtpmail-smtp-service 587)

(custom-set-variables
 '(elfeed-feeds
   (quote
    (("https://www.reddit.com/r/linux.rss" reddit linux)
     ("https://www.gamingonlinux.com/article_rss.php" gaming linux)
     ("https://hackaday.com/blog/feed/" hackaday linux)
     ("https://opensource.com/feed" opensource linux)
     ("https://linux.softpedia.com/backend.xml" softpedia linux)
     ("https://itsfoss.com/feed/" itsfoss linux)
     ("https://www.zdnet.com/topic/linux/rss.xml" zdnet linux)
     ("https://www.phoronix.com/rss.php" phoronix linux)
     ("http://feeds.feedburner.com/d0od" omgubuntu linux)
     ("https://www.computerworld.com/index.rss" computerworld linux)
     ("https://www.networkworld.com/category/linux/index.rss" networkworld linux)
     ("https://www.techrepublic.com/rssfeeds/topic/open-source/" techrepublic linux)
     ("https://betanews.com/feed" betanews linux)
     ("http://lxer.com/module/newswire/headlines.rss" lxer linux)
     ("https://distrowatch.com/news/dwd.xml" distrowatch linux)))))
(global-evil-quickscope-always-mode 1)
