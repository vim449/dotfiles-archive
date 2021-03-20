;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)
(package! dmenu)
(package! evil-tutor)
(package! peep-dired)
(package! wc-mode)
(package! evil-quickscope)
(package! virtualenvwrapper)
(package! tree-sitter)
(package! tree-sitter-langs)
(package! vimrc-mode) ; I know this is blasphemy, but I need it
(package! command-log-mode)
(package! skeletor)
(package! 2048-game)
(package! rotate)
(package! theme-magic)
(package! elcord)
(package! keycast)
(package! gif-screencast)
(package! calctex :recipe (:host github :repo "johnbcoughlin/calctex"
                           :files ("*.el" "calctex/*.el" "calctex-contrib/*.el" "org-calctex/*.el" "vendor"))
  :pin "7fa2673c64...")
(package! info-colors :pin "47ee73cc19...")
(package! vlf :recipe (:host github :repo "m00natic/vlfi" :files ("*.el"))
  :pin "cc02f25337..." :disable t)
(package! org-appear :recipe (:host github :repo "awth13/org-appear")
  :pin "845be82b7a...")
(package! org-pretty-tags :pin "5c7521651b...")
(package! engrave-faces :recipe (:local-repo "lisp/engrave-faces"))
(package! org-ref :pin "7dbe3ace9b...")
(package! org-graph-view :recipe (:host github :repo "alphapapa/org-graph-view") :pin "13314338d7...")
(package! org-chef :pin "5b461ed7d4...")
(package! systemd :pin "b6ae63a236...")
(package! org-pretty-table
  :recipe (:host github :repo "Fuco1/org-pretty-table") :pin "474ad84a8f...")
