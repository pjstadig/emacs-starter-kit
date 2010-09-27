(defun remove-server-query-hook ()
  (remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
  (remove-hook 'server-visit-hook 'remove-server-query-hook))
(add-hook 'server-visit-hook 'remove-server-query-hook)
