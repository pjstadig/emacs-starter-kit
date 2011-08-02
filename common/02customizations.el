(setq-default fill-column 80)
(setq color-theme-is-cumulative t
      frame-background-mode 'dark
      whitespace-line-column 80)

(modify-frame-parameters nil '((wait-for-wm . nil)))
(set-face-attribute 'default nil :family "Inconsolata" :height 120)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "Inconsolata")))))
