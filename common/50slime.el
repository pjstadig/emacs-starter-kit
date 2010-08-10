;;(add-to-list 'load-path (concat home-dir "/src/swank-clojure"))
(require 'slime)
(add-hook 'slime-repl-mode-hook '(lambda ()
                                   (paredit-mode t)))
