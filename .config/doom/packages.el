;; -*- no-byte-compile: t; -*-

(package! rotate :pin "4e9ac3ff80...")

(package! xkcd :pin "66e928706f...")

(package! selectric-mode :pin "1840de71f7...")

(package! wttrin :recipe (:local-repo "lisp/wttrin"))

(package! spray :pin "74d9dcfa2e...")

(package! theme-magic :pin "844c4311bd...")

(package! elcord :pin "25531186c1...")

(package! keycast :pin "a3a0798349...")

(package! vlf :recipe (:host github :repo "m00natic/vlfi" :files ("*.el"))
  :pin "cc02f25337...")

(package! gif-screencast :pin "1145e676b1...")

(package! command-log-mode)

(package! tree-sitter)
(package! tree-sitter-langs)

(package! dmenu)
(package! peep-dired)
(package! wc-mode)
(package! evil-quickscope)
(package! vimrc-mode)
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
(package! info-colors)
(package! evil-terminal-cursor-changer :disable t)
