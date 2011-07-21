(when-load-path (concat home-dir "/src/magit")
  (require 'magit)
  (setq magit-diff-options '("-b"))
  (setq magit-status-buffer-switch-function 'switch-to-buffer))
