(add-to-list 'load-path (concat home-dir "/src/org-mode/lisp"))
(add-to-list 'load-path (concat home-dir "/src/org-mode/contrib/lisp"))

(require 'org)
(define-key global-map "\C-cc" 'org-capture)
(setq org-directory (concat home-dir "/org"))
(setq org-agenda-files (list org-directory))
(setq org-completion-use-ido 't)
(setq org-refile-targets `((nil . (:level . 1))
                           ((,(concat home-dir "/org/inbox.org")) .
                            (:level . 1))
                           ((,(concat home-dir "/org/projects.org")) .
                            (:level . 1))))
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "gtd.org" "Inbox")
         "* TODO %i%?")
        ("p" "project" entry (file "projects.org")
         "* %i%?")
        ("j" "Journal" entry (file+datetree "journal.org")
         "* %i%?\n\n  Entered on %T")))
