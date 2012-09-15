;; ERC
(add-hook 'erc-mode-hook '(lambda ()
                            (erc-scrolltobottom-mode t)))

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
           '(("freenode.net" "#clojure")
             ("irc.sa2s.us" "#safe" "#devs"))
           erc-ignore-list '("sexpbot")
           erc-prompt-for-nickserv-password nil)
     (require 'erc-services)
     (require 'erc-spelling)
     (erc-services-mode 1)
     (add-to-list 'erc-modules 'highlight-nicknames 'spelling)
     (add-hook 'erc-connect-pre-hook (lambda (x) (erc-update-modules)))
     (set-face-foreground 'erc-input-face "dim gray")
     (set-face-foreground 'erc-my-nick-face "blue")))

(ignore-errors
  (load (expand-file-name "~/.passwords.el"))
  (setq erc-nickserv-passwords
        `((freenode     (("pjstadig" . ,freenode-password))))))

(defun clean-message (s)
  (setq s (replace-regexp-in-string "&" "&amp;" s))
  (setq s (replace-regexp-in-string "'" "&apos;" s))
  (setq s (replace-regexp-in-string "\"" "&quot;" s))
  (setq s (replace-regexp-in-string "<" "&lt;" s))
  (setq s (replace-regexp-in-string ">" "&gt;" s)))

(defun call-libnotify (matched-type nick msg)
  (let* ((cmsg  (split-string (clean-message msg)))
         (nick   (first (split-string nick "!")))
         (msg    (mapconcat 'identity (rest cmsg) " ")))
    (shell-command-to-string
     (format "notify-send '%s says:' '%s'"
             nick msg))))

(add-hook 'erc-text-matched-hook 'call-libnotify)
(setq pcomplete-cycle-completions nil)
