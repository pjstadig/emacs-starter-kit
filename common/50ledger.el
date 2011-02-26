(require 'ledger)

(add-to-list 'auto-mode-alist '("\\.dat$" . ledger-mode))

(defun ledger-add-entry (entry-text)
  (interactive
   (list
    (read-string "Entry: " (concat ledger-year "-" ledger-month "-"))))
  (let* ((args (with-temp-buffer
		 (insert entry-text)
		 (eshell-parse-arguments (point-min) (point-max))))
	 (date (car args))
	 (insert-year t)
	 (ledger-buf (current-buffer))
	 exit-code)
    (if (string-match "\\([0-9]+\\)-\\([0-9]+\\)-\\([0-9]+\\)" date)
	(setq date
	      (encode-time 0 0 0 (string-to-number (match-string 3 date))
			   (string-to-number (match-string 2 date))
			   (string-to-number (match-string 1 date)))))
    (ledger-find-slot date)
    (save-excursion
      (if (re-search-backward "^Y " nil t)
	  (setq insert-year nil)))
    (save-excursion
      (insert
       (with-temp-buffer
	 (setq exit-code
	       (apply #'ledger-run-ledger ledger-buf "entry"
		      (mapcar 'eval args)))
	 (if (= 0 exit-code)
	     (if insert-year
		 (buffer-substring 2 (point-max))
	       (buffer-substring 7 (point-max)))
	   (concat (if insert-year entry-text
		     (substring entry-text 6)) "\n"))) "\n"))))

(defun ledger-toggle-current-transaction (&optional style)
  "Toggle the cleared status of the transaction under point.
Optional argument STYLE may be `pending' or `cleared', depending
on which type of status the caller wishes to indicate (default is
`cleared').
This function is rather complicated because it must preserve both
the overall formatting of the ledger entry, as well as ensuring
that the most minimal display format is used.  This could be
achieved more certainly by passing the entry to ledger for
formatting, but doing so causes inline math expressions to be
dropped."
  (interactive)
  (let ((bounds (ledger-current-entry-bounds))
	clear cleared)
    ;; Uncompact the entry, to make it easier to toggle the
    ;; transaction
    (save-excursion
      (goto-char (car bounds))
      (skip-chars-forward "0-9./= \t-")
      (setq cleared (and (member (char-after) '(?\* ?\!))
			 (char-after)))
      (when cleared
	(let ((here (point)))
	  (skip-chars-forward "*! ")
	  (let ((width (- (point) here)))
	    (when (> width 0)
	      (delete-region here (point))
	      (if (search-forward "  " (line-end-position) t)
		  (insert (make-string width ? ))))))
	(forward-line)
	(while (looking-at "[ \t]")
	  (skip-chars-forward " \t")
	  (insert cleared " ")
	  (if (search-forward "  " (line-end-position) t)
	      (delete-char 2))
	  (forward-line))))
    ;; Toggle the individual transaction
    (save-excursion
      (goto-char (line-beginning-position))
      (when (looking-at "[ \t]")
	(skip-chars-forward " \t")
	(let ((here (point))
	      (cleared (member (char-after) '(?\* ?\!))))
	  (skip-chars-forward "*! ")
	  (let ((width (- (point) here)))
	    (when (> width 0)
	      (delete-region here (point))
	      (save-excursion
		(if (search-forward "  " (line-end-position) t)
		    (insert (make-string width ? ))))))
	  (let (inserted)
	    (if cleared
		(if (and style (eq style 'cleared))
		    (progn
		      (insert "* ")
		      (setq inserted t)))
	      (if (and style (eq style 'pending))
		  (progn
		    (insert "! ")
		    (setq inserted t))
		(progn
		  (insert "* ")
		  (setq inserted t))))
	    (if (and inserted
		     (re-search-forward "\\(\t\\| [ \t]\\)"
					(line-end-position) t))
		(cond
		 ((looking-at "\t")
		  (delete-char 1))
		 ((looking-at " [ \t]")
		  (delete-char 2))
		 ((looking-at " ")
		  (delete-char 1))))
	    (setq clear inserted)))))
    ;; Clean up the entry so that it displays minimally
    (save-excursion
      (goto-char (car bounds))
      (forward-line)
      (let ((first t)
	    (state ? )
	    (hetero nil))
	(while (and (not hetero) (looking-at "[ \t]"))
	  (skip-chars-forward " \t")
	  (let ((cleared (if (member (char-after) '(?\* ?\!))
			     (char-after)
			   ? )))
	    (if first
		(setq state cleared
		      first nil)
	      (if (/= state cleared)
		  (setq hetero t))))
	  (forward-line))
	(when (and (not hetero) (/= state ? ))
	  (goto-char (car bounds))
	  (forward-line)
	  (while (looking-at "[ \t]")
	    (skip-chars-forward " \t")
	    (let ((here (point)))
	      (skip-chars-forward "*! ")
	      (let ((width (- (point) here)))
		(when (> width 0)
		  (delete-region here (point))
		  (if (re-search-forward "\\(\t\\| [ \t]\\)"
					 (line-end-position) t)
		      (insert (make-string width ? ))))))
	    (forward-line))
	  (goto-char (car bounds))
	  (skip-chars-forward "0-9./= \t-")
	  (insert state " ")
	  (if (re-search-forward "\\(\t\\| [ \t]\\)"
				 (line-end-position) t)
	      (cond
	       ((looking-at "\t")
		(delete-char 1))
	       ((looking-at " [ \t]")
		(delete-char 2))
	       ((looking-at " ")
		(delete-char 1)))))))
    clear))
