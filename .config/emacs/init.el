(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(load-theme 'deeper-blue)

(set-face-attribute 'default nil :family "Iosevka Fixed" :height 125)
(set-face-attribute nil nil :family "Iosevka Fixed" :height 125)
