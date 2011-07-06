(let ((org-mode-path (concat home-dir "/src/org-mode")))
  (if (file-exists-p org-mode-path)
      (progn
        (add-to-list 'load-path (concat home-dir "/src/org-mode/lisp"))
        (add-to-list 'load-path (concat home-dir "/src/org-mode/contrib/lisp"))
        (require 'org))
    (princ (concat "---Could not find " org-mode-path))))

(define-key global-map "\C-cc" 'org-capture)
(setq org-directory (concat home-dir "/org"))
(setq org-agenda-files (list org-directory))
(setq org-completion-use-ido 't)
(setq org-capture-templates
      '(("t" "Todo" entry (file "inbox.org")
         "* TODO %i%?")
        ("p" "Project" entry (file "gtd.org")
         "* %i%? :project:")
        ("j" "Journal" entry (file+datetree "journal.org")
         "* %i%?\n  Entered on %T")))
(setq org-refile-targets `((,(concat home-dir "/org/gtd.org") . (:level . 1))))
(setq org-todo-keywords
       '((sequence "TODO" "|" "WAITING" "DONE")))

(setq org-mobile-directory (concat home-dir "/Dropbox/mobileorg"))
(setq org-mobile-files nil)
(setq org-mobile-inbox-for-pull (concat home-dir "/org/inbox.org"))
(setq org-mobile-force-id-on-agenda-items nil)
