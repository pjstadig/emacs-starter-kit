(add-to-list 'load-path "/home/sonian/src/sonian/sa-safe/.elisp")
(add-to-list 'load-path "/home/sonian/src/clojure-mode")
(add-to-list 'load-path "/home/sonian/src/swank-clojure")
;;(add-to-list 'load-path "/home/sonian/src/slime")
;;(add-to-list 'load-path "/home/sonian/src/slime/contrib")

(require 'clojure-mode)
(require 'slime)
(require 'color-theme)
(require 'sonian-navigation)
(global-set-key (kbd "C-c C-j") 'sonian-jump)
(global-set-key (kbd "C-c C-;") 'comment-or-uncomment-region)

;; swank launchers

(defun slime-it-up (&optional port)
  (interactive)
  ;; use .dir-locals.el to set slime-port. Must be 4005 for maven.
  (slime-connect "localhost" (or port slime-port)))

(defun slime-start-filter (process output)
  (when (string-match "Connection opened on local port" output)
    (slime-it-up)
    (set-process-filter process nil)))

(defun mvn-swank ()
  (interactive)
  (let ((root (locate-dominating-file default-directory "pom.xml")))
    (when (not root)
      (error "Not in a Maven project."))
    (shell-command (format "cd %s && mvn -o clojure:swank &" root) "*mvn-swank*")
    (set-process-filter (get-buffer-process "*mvn-swank*") 'slime-start-filter)))

(defun lein-swank ()
  (interactive)
  (let ((root (locate-dominating-file default-directory "project.clj")))
    (when (not root)
      (error "Not in a Leiningen project."))
    (shell-command (format "cd %s && lein swank %s &" root slime-port) "*lein-swank*")
    (set-process-filter (get-buffer-process "*lein-swank*") 'slime-start-filter)))

(global-set-key (kbd "C-c C-s") 'slime-it-up)
(global-set-key (kbd "C-c C-m") 'mvn-swank)
(global-set-key (kbd "C-c C-l") 'lein-swank)

(autoload 'clojure-test-mode "clojure-test-mode" "Clojure test mode" t)
(autoload 'clojure-test-maybe-enable "clojure-test-mode" "" t)
(add-hook 'clojure-mode-hook 'clojure-test-maybe-enable)
(add-hook 'clojure-mode-hook '(lambda ()
                                (whitespace-mode t)))
(add-hook 'slime-repl-mode-hook '(lambda ()
                                   (paredit-mode t)))
(add-hook 'erc-mode-hook '(lambda ()
                            (erc-scrolltobottom-mode t)))

;;(set-face-attribute 'default nil :family "Inconsolata" :height 100)
;;(modify-frame-parameters nil '((wait-for-wm . nil)))

;; ERC
(eval-after-load 'erc
  '(progn
     (setq erc-prompt ">"
           erc-fill-column 75
           erc-hide-list '("JOIN" "PART" "QUIT" "NICK")
           erc-track-exclude-types (append '("324" "329" "332" "333"
                                             "353" "477" "MODE")
                                           erc-hide-list)
           erc-nick "pjstadig"
           erc-autojoin-timing :ident
           erc-autojoin-channels-alist
           '(("freenode.net" "#clojure"
              "#clojure-awesome" "#sonian" "#sonian-safe"))
           erc-ignore-list '("sexpbot")
           erc-prompt-for-nickserv-password nil)
     (require 'erc-services)
     (require 'erc-spelling)
     (erc-services-mode 1)
     (add-to-list 'erc-modules 'highlight-nicknames 'spelling)
     (add-hook 'erc-connect-pre-hook (lambda (x) (erc-update-modules)))
     (set-face-foreground 'erc-input-face "dim gray")
     (set-face-foreground 'erc-my-nick-face "blue")))

(setq pcomplete-cycle-completions nil)

(ignore-errors
  (load (expand-file-name "~/.passwords.el"))

  (setq erc-nickserv-passwords
        `((freenode     (("pjstadig" . ,freenode-password))))))

(defun clean-message (s)
  (setq s (replace-regexp-in-string "'" "&apos;"
          (replace-regexp-in-string "\"" "&quot;"
          (replace-regexp-in-string "&" "&amp;"
          (replace-regexp-in-string "<" "&lt;"
          (replace-regexp-in-string ">" "&gt;" s)))))))

(defun call-libnotify (matched-type nick msg)
  (let* ((cmsg  (split-string (clean-message msg)))
         (nick   (first (split-string nick "!")))
         (msg    (mapconcat 'identity (rest cmsg) " ")))
    (shell-command-to-string
     (format "notify-send '%s says:' '%s'"
             nick msg))))

(add-hook 'erc-text-matched-hook 'call-libnotify)

;; (global-unset-key [home])
;; (global-unset-key [end])
;; (global-unset-key [prior])
;; (global-unset-key [next])
;; (global-unset-key [left])
;; (global-unset-key [right])
;; (global-unset-key [up])
;; (global-unset-key [down])
;; (global-unset-key (kbd "C-+"))
;; (global-unset-key (kbd "C--"))

(load-file "~/.emacs.d/color-theme-paul.el")
(color-theme-paul)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "/usr/bin/conkeror")

(unless (boundp 'start-server)
  (setq start-server t))

;; org-mode setup
(add-to-list 'load-path "/home/sonian/src/org-mode/lisp")
(add-to-list 'load-path "/home/sonian/src/org-mode/contrib/lisp")

(require 'org)
(define-key global-map "\C-cc" 'org-capture)
(setq org-directory "~/org")
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\n  Entered on %T\n  %i")))

(setq org-agenda-files '("~/org"))
(setenv "LD_LIBRARY_PATH" "/opt/ibm/lotus/notes/")

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(color-theme-is-cumulative t)
 '(fill-column 80)
 '(frame-background-mode (quote dark))
 '(whitespace-line-column 80 t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "Inconsolata")))))
