(require 'server)
(if (not (server-running-p))
    (server-start))

(defun exit-emacs-client ()
  "consistent exit emacsclient.
   if not in emacs client, echo a message in minibuffer, don't exit emacs.
   if in server mode
      and editing file, do C-x # server-edit
      else do C-x 5 0 delete-frame"
  (interactive)
  (if server-buffer-clients
      (server-edit)
    (delete-frame)))

(global-set-key (kbd "C-c q") 'exit-emacs-client)
