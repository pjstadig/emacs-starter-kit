(setq lotus-dir "/opt/ibm/lotus/notes/")
(if (file-exists-p lotus-dir)
    (setenv "LD_LIBRARY_PATH" lotus-dir))
