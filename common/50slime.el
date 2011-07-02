(when-load-path (concat home-dir "/src/slime")
  (require 'slime)
  (add-hook 'slime-repl-mode-hook '(lambda ()
                                     (paredit-mode t))))
