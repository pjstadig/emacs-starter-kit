(setq user-common-dir (concat dotfiles-dir "common"))
(add-to-list 'load-path user-common-dir)
(if (file-exists-p user-common-dir)
    (mapc #'load (directory-files user-common-dir nil ".*el$")))
