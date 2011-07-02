(global-set-key (kbd "C-c C-l") 'lein-swank)
(global-set-key (kbd "C-c C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c ;") 'comment-or-uncomment-region)
(global-unset-key (kbd "C-+"))
(global-unset-key (kbd "C--"))

(when-load-path (concat home-dir "/src/sonian/sa-safe/.elisp")
  (require 'sonian-navigation))
