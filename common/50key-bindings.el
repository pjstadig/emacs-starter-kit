(global-set-key (kbd "C-c C-l") 'lein-swank)
(add-to-list 'load-path (concat home-dir "/src/sonian/sa-safe/.elisp"))
(require 'sonian-navigation)
(global-set-key (kbd "C-c C-j") 'sonian-jump)
(global-set-key (kbd "C-c C-;") 'comment-or-uncomment-region)
;; (global-unset-key (kbd "C-+"))
;; (global-unset-key (kbd "C--"))
