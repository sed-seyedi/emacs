;;
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;; bash alias in emacs https://stackoverflow.com/a/12229404
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")

;; always open in fundamental-mode
(setq-default major-mode 'fundamental-mode)
(add-to-list 'auto-mode-alist '("\\..*\\'" . fundamental-mode))

;(add-to-list 'load-path "~/.emacs.d/elisp")
;; no tabs
(setq-default indent-tabs-mode nil)
;; tabs to 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq tab-stop-list (number-sequence 4 200 4))

;; ignore bell function
(setq ring-bell-function 'ignore)

;uncomment the next three lines for removing stuffx
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)

(put 'dired-find-alternate-file 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; backups
(setq backup-directory-alist `(("." . "~/.emacs_backups")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
(setq tramp-backup-directory-alist backup-directory-alist)
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; on the fly error checking for php
;(require 'flymake)
;(add-hook 'find-file-hook 'flymake-find-file-hook)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(defun cleanup-buffer-safe ()
  "Perform a bunch of safe operations on the whitespace content of a buffer.
Does not indent buffer, because it is used for a before-save-hook, and that
might be bad."
  (interactive)
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8))

;; Various superfluous white-space. Just say no.
(add-hook 'before-save-hook 'cleanup-buffer-safe)

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (cleanup-buffer-safe)
  (indent-region (point-min) (point-max)))
(global-set-key (kbd "C-c n") 'cleanup-buffer)

;; background and foreround colors:
(set-foreground-color "#90EE02")
(set-background-color "#341228")

;; disable color crap
;; You can also toggle the color crap with "Meta-x global-font-lock-mode".
(setq-default global-font-lock-mode nil)
(global-font-lock-mode 0)

;; Default font
;(set-default-font "Inconsolata-24")
(set-default-font "Fantasque Sans Mono-18")

;; http://emacs.stackexchange.com/a/5941
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

(use-package avy
  :ensure t
  :bind ("C-j" . avy-goto-char))

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    (add-to-list 'ac-modes 'fundamental-mode)
    ))

(use-package flymake
  :ensure t
  :config
  (progn
    (add-hook 'find-file-hook 'flymake-find-file-hook)
  ))

;; remove .html files from flymake extensions
(delete '("\\.cfm?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
(delete '("\\.cfc?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
(delete '("\\.css?\\'" flymake-xml-init) flymake-allowed-file-name-masks)
(delete '("\\.js?\\'" flymake-xml-init) flymake-allowed-file-name-masks)

(use-package ido
  :config
  (setq ido-enable-flex-matching t)
  (ido-everywhere t)
  (ido-mode 1))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;;; c-z do nothing
(global-unset-key (kbd "C-z"))


;;;; un/indent region (see: https://stackoverflow.com/a/11624677)
(defun my-indent-region (N)
  (interactive "p")
  (if (use-region-p)
      (progn (indent-rigidly (region-beginning) (region-end) (* N 4))
             (setq deactivate-mark nil))
    (self-insert-command N)))

(defun my-unindent-region (N)
  (interactive "p")
  (if (use-region-p)
      (progn (indent-rigidly (region-beginning) (region-end) (* N -4))
             (setq deactivate-mark nil))
    (self-insert-command N)))

(global-set-key ">" 'my-indent-region)
(global-set-key "<" 'my-unindent-region)