(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-to-list 'load-path "~/.emacs-conf")
(add-to-list 'load-path "/home/yakoub/.emacs.d/color-theme-6.6.0")
(add-to-list 'load-path "/home/yakoub/.emacs.d/ecb-master")

(require 'color-theme)
(require 'package)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)


(package-initialize)
(elpy-enable)

(color-theme-initialize)
(color-theme-clarity)

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-f") 'isearch-forward-regexp)
(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "C-;") 'kill-whole-line)
;; fuzzy keybinding
(global-set-key (kbd "C-u") 'fiplr-find-file)

;;;Install el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

;;;Ruby packages

(setq el-get-sources
      '((:name ruby-mode 
               :type elpa
               :load "ruby-mode.el")
        (:name inf-ruby  :type elpa)
        (:name ruby-compilation :type elpa)
        (:name css-mode :type elpa)
        (:name textmate
               :type git
               :url "git://github.com/defunkt/textmate.el"
               :load "textmate.el")
        (:name rvm
               :type git
               :url "http://github.com/djwhitt/rvm.el.git"
               :load "rvm.el"
               :compile ("rvm.el")
               :after (lambda() (rvm-use-default)))
        (:name rhtml
               :type git
               :url "https://github.com/eschulte/rhtml.git"
               :features rhtml-mode)
        (:name yaml-mode 
               :type git
               :url "http://github.com/yoshiki/yaml-mode.git"
               :features yaml-mode)))
(el-get 'sync)

;; melpa packages

(defvar my-melpa-packages
  '(
    company-math
	enh-ruby-mode
	robe
	fiplr
	lua-mode
	cython-mode
    )
  "A list of packages to install from MELPA at launch.")

;;; melpa config

(defun my-melpa-packages-installed-p ()
  "Check if all packages in `my-melpa-packages' are installed."
  (every #'package-installed-p my-melpa-packages))

(defun require-my-melpa-package (package)
  "Install PACKAGE unless already installed."
  (unless (memq package my-melpa-packages)
    (add-to-list 'my-melpa-packages package))
  (unless (package-installed-p package)
    (package-install package)))

(defun require-my-melpa-packages (packages)
  "Ensure PACKAGES are installed.
Missing packages are installed automatically."
  (mapc #'require-my-melpa-package packages))

(defun install-my-melpa-packages ()
  "Install all packages listed in `my-melpa-packages'."
  (unless (my-melpa-packages-installed-p)
    ;; check for new packages (package versions)
    (message "%s" "Refreshing its package database...")
    (package-refresh-contents)
    (message "%s" " done.")
    ;; install the missing packages
    (require-my-melpa-packages my-melpa-packages)))

;; Install Melpa packages
(install-my-melpa-packages)

;; package recipes

(setq
 ac-el-get-packages
 '(el-get
   auto-complete))

(el-get 'sync ac-el-get-packages) 

(setq
 math-el-get-packages
 '(el-get
   ac-math))


(el-get 'sync math-el-get-packages) 

;;configure autocomplete plugin
(require 'auto-complete-config)
 (add-to-list 'ac-dictionary-directories
     "~/.emacs./elpa/auto-complete-20141208.809/dict")
 (ac-config-default)
 (setq ac-ignore-case nil)

;; configure ecb
(require 'ecb)
(global-set-key (kbd "C-!") 'ecb-activate)
(global-set-key (kbd "C-@") 'ecb-deactivate)
;;; show/hide ecb window
(global-set-key (kbd "C-#") 'ecb-show-ecb-windows)
(global-set-key (kbd "C-$") 'ecb-hide-ecb-windows)
;;; quick navigation between ecb windows
(global-set-key (kbd "C-%") 'ecb-goto-window-edit1)
(global-set-key (kbd "C-^") 'ecb-goto-window-directories)
(global-set-key (kbd "C-&") 'ecb-goto-window-sources)
(global-set-key (kbd "C-*") 'ecb-goto-window-methods)
(global-set-key (kbd "C-(") 'ecb-goto-window-compilation)


;; Irony-mode for c++
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; autocomplete and c++ general configurations

(require 'cc-mode)
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default tab-width 4 indent-tabs-mode t)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

(require 'auto-complete-clang)
(define-key c++-mode-map (kbd "<C-tab>") 'ac-complete-clang)

;; company mode autocomplete
(add-hook 'after-init-hook 'global-company-mode)

;; AUCTex plugin
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
;; compile to pdf by default
(require 'tex)
(setq TeX-PDF-mode t)
;; company-math mode
(add-to-list 'company-backends 'company-math-symbols-unicode)
(add-to-list 'company-backends 'company-math-symbols-latex)
(add-to-list 'company-backends 'company-latex-commands)

;; local configuration for TeX modes
(defun my-latex-mode-setup ()
  (setq-local company-backends
              (append '(company-math-symbols-latex company-latex-commands)
                      company-backends)))

(add-hook 'TeX-mode-hook 'my-latex-mode-setup)
;; Allow region selection deletion
(delete-selection-mode 1)


;;ruby robe-mode configurations
(add-hook 'ruby-mode-hook 'robe-mode)
(push 'company-robe company-backends)
