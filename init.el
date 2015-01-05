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
(package-initialize)
(elpy-enable)

(color-theme-initialize)
(color-theme-clarity)

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-f") 'isearch-forward-regexp)

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
