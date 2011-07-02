(when-load-path (concat home-dir "/src/clojure-mode")
  (require 'clojure-mode)
  (autoload 'clojure-test-mode "clojure-test-mode" "Clojure test mode" t)
  (autoload 'clojure-test-maybe-enable "clojure-test-mode" "" t)
  (add-hook 'clojure-mode-hook 'clojure-test-maybe-enable)
  (add-hook 'clojure-mode-hook '(lambda ()
                                  (whitespace-mode t))))
