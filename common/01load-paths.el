(setq home-dir (getenv "HOME"))

(defmacro when-load-path (dir &rest body)
  (declare (indent defun))
  `(if (file-exists-p ,dir)
       (progn (add-to-list 'load-path ,dir)
              ,@body)
     (princ (concat "--- Could not find " ,dir))))
