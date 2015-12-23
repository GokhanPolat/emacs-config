;;; visual.el --- Visual settings: fonts, themes, mode-line, …  -*- lexical-binding: t -*-

;; Copyright © 2012-2015 Alex Kost

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;;; Frame specific settings

(defun al/frame-visual-actions (&optional frame)
  "Perform some visual actions specific to a FRAME type."
  (when (and (display-graphic-p)
             (require 'utl-font nil t))
    (set-frame-font (utl-first-existing-font) nil t)
    ;; Should be "solved": 武 (droid); 🐼, 😻, ⚽, ∵, ⸪ (symbola);
    ;; ࿌ (unifont); 🃜, 🜒, 🝖 (quivira).
    (utl-set-fontset
     "fontset-default" nil nil
     '("Symbola-12"
       (#x2020  . #x24ff)
       (#x2600  . #x27ff)
       (#x2900  . #x29ff)
       (#x2e00  . #x2e42)
       (#x1d300 . #x1d371)
       (#x1d400 . #x1d7ff)
       (#x1f000 . #x1f1ff)
       (#x1f300 . #x1f6ff))
     '("Ubuntu Mono-12"
       (?²      . ?³)
       (?¼      . ?¾)
       (#x2070  . #x208f))
     '("Quivira-12" nil))))

(al/add-hook-maybe
    '(after-make-frame-functions window-setup-hook)
  'al/frame-visual-actions)


;;; Global keys

(al/bind-keys
 :prefix-map al/visual-map
 :prefix-docstring "Map for visual stuff."
 :prefix "M-V"
 ("T"   . tool-bar-mode)
 ("M"   . menu-bar-mode)
 ("S"   . scroll-bar-mode)
 ("I"   . tooltip-mode)
 ("r"   . rainbow-mode)
 ("t"   . utl-load-theme)
 ("C"   . make-color)
 ("c"   . make-color-switch-to-buffer)
 ("l"     (utl-load-theme 'alect-light))
 ("M-l"   (utl-load-theme 'alect-light-alt))
 ("d"     (utl-load-theme 'alect-dark))
 ("M-d"   (utl-load-theme 'alect-dark-alt))
 ("b"     (utl-load-theme 'alect-black))
 ("M-b"   (utl-load-theme 'alect-black-alt))
 ("h"   . hl-line-mode)
 ("w"   . whitespace-mode)
 ("W"   . global-whitespace-mode)
 ("M-W"   (setq show-trailing-whitespace
                (not show-trailing-whitespace)))
 ("f"   . utl-face-to-kill-ring)
 ("F"   . facemenu-set-foreground)
 ("B"   . facemenu-set-background)
 ("M-F" . make-color-foreground-color-to-kill-ring)
 ("M-B" . make-color-background-color-to-kill-ring))


;;; Themes

(use-package custom
  :defer t
  :config
  (setq custom-safe-themes t)

  ;; Fix bug <http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16266>.
  (defun al/fix-custom-variables-bug (fun &rest args)
    "Allow setting undefined variables in themes."
    (let (custom--inhibit-theme-enable)
      (apply fun args)))
  (advice-add 'custom-theme-set-variables
    :around #'al/fix-custom-variables-bug))

(use-package alect-themes
  :init
  (al/add-my-package-to-load-path-maybe "alect-themes")
  :config
  (setq
   alect-display-class '((class color) (min-colors 256))
   alect-overriding-faces
   '((hl-line ((((type graphic)) :background bg)
               (t :background unspecified)))
     (sauron-header-face ((t :foreground unspecified)))))
  (unless (al/emacs-trunk-p)
    (push '(fringe ((((class color) (min-colors 256))
                     :foreground gray :background bg+2)))
          alect-overriding-faces))
  (when (require 'utl-color nil t)
    (utl-load-theme 'alect-light)))


;;; Mode line

(defface al/mode-name
  '((((background light)) :foreground "#028902")
    (((background dark))  :foreground "yellow"))
  "Face for `mode-name' displayed in the mode line.")

(use-package utl-mode-line
  :config
  (setq
   utl-mode-names-alist
   '((emacs-lisp-mode            . "EL")
     (lisp-interaction-mode      . "ELi")
     (inferior-emacs-lisp-mode   . "EL>")
     (lisp-mode                  . "CL")
     (slime-repl-mode            . "CL>")
     (scheme-mode                . "λ")
     (geiser-repl-mode           . "λ>")
     (geiser-doc-mode            . "λ🄷")
     (python-mode                . "Py")
     (inferior-python-mode       . "Py>")
     (js-mode                    . "JS")
     (sh-mode                    . "Sh")
     (shell-mode                 . "Sh>")
     (eshell-mode                . "ESh>")
     (dired-mode                 . "🗀")
     (wdired-mode                . "🗁")
     (Info-mode                  . "🄸")
     (help-mode                  . "🄷")
     (doc-view-mode              . "Doc")
     (pdf-view-mode              . "pdfView")
     (pdf-outline-buffer-mode    . "pdf🖹")
     (sql-interactive-mode       . "SQL>")
     (ibuffer-mode               . "IB")
     (gnus-server-mode           . "𝗚Srv")
     (gnus-group-mode            . "𝗚Gr")
     (gnus-summary-mode          . "𝗚Sum")
     (gnus-article-mode          . "𝗚Art")
     (message-mode               . "🖂")
     (erc-view-log-mode          . "ERC🄻")
     (erc-list-menu-mode         . "ERC🗋")
     (calc-mode                  . "=")
     (debugger-mode              . "🔨")
     (snippet-mode               . "🗍")
     (diary-mode                 . "🕮")
     (ediff-mode                 . "ε")

     (magit-status-mode          . "µStatus")
     (magit-process-mode         . "µProc")
     (magit-log-mode             . "µ🄻")
     (magit-log-select-mode      . "µ🄻Select")
     (magit-reflog-mode          . "µReflog")
     (magit-refs-mode            . "µRefs")
     (magit-diff-mode            . "µDiff")
     (magit-revision-mode        . "µRevision")
     (magit-cherry-mode          . "µCherry")
     (magit-stash-mode           . "µStash")
     (magit-stashes-mode         . "µStashes")
     (magit-popup-mode           . "µPopup")
     (magit-popup-sequence-mode  . "µPopupSeq")
     (git-rebase-mode            . "gitRebase")

     (calendar-mode              . "📆")
     (w3m-form-input-select-mode . "w3m🗹")
     (package-menu-mode          . "Pkg🗋")
     (guix-package-info-mode     . "γ🄷p")
     (guix-output-info-mode      . "γ🄷o")
     (guix-generation-info-mode  . "γ🄷g")
     (guix-package-list-mode     . "γ🗋p")
     (guix-output-list-mode      . "γ🗋o")
     (guix-generation-list-mode  . "γ🗋g")
     (emms-playlist-mode         . "🎝")
     (emms-stream-mode           . "🎝 Streams")
     (sauron-mode                . "👁"))

   utl-minor-mode-names-alist
   '((visual-line-mode           . "↩")
     (auto-fill-function         . "↵")
     (isearch-mode               . "🔎")))

  (utl-diminish utl-minor-mode-names-alist)
  (al/add-hook-maybe 'after-change-major-mode-hook 'utl-mode-name))

(setq-default
 mode-line-format
 `("%e" mode-line-front-space
   mode-line-mule-info mode-line-client mode-line-modified mode-line-remote
   " " mode-line-buffer-identification " " mode-line-position
   " %l,%c"
   (vc-mode vc-mode)
   " " mode-line-modes mode-line-misc-info
   utl-mode-server
   mode-line-end-spaces)

 mode-line-buffer-identification
 (propertized-buffer-identification "%b")

 mode-line-mule-info
 `(""
   (current-input-method
    (:propertize
     current-input-method-title
     help-echo (concat ,(purecopy "Input method: ")
                       current-input-method
                       ,(purecopy
                         (concat "\n" "mouse-2: Disable input method\n"
                                 "mouse-3: Describe input method")))
     local-map ,mode-line-input-method-map
     face font-lock-warning-face
     mouse-face mode-line-highlight))
   ,(propertize
     "%z"
     'help-echo 'mode-line-mule-info-help-echo
     'mouse-face 'mode-line-highlight
     'local-map mode-line-coding-system-map)
   (:eval (mode-line-eol-desc))))

(setq
 mode-line-position
 `((-3 ,(propertize "%P" 'face 'font-lock-builtin-face)))

 mode-line-modes
 (let ((recursive-edit-help-echo "Recursive edit: C-M-c to get out")
       (mode-help-echo (concat "Mode actions:\n"
                               "mouse-1: Show menu\n"
                               "mouse-2: Show help\n"
                               "mouse-3: Minor modes")))
   (list '(:eval
           (let ((proc (get-buffer-process (current-buffer))))
             (propertize
              (if proc (symbol-name (process-status proc)) "–")
              'face 'font-lock-constant-face)))
         " "
         (propertize "%["
                     'help-echo recursive-edit-help-echo
                     'face 'font-lock-warning-face)
         "│"
         `(:propertize mode-name
                       help-echo ,mode-help-echo
                       face al/mode-name
                       mouse-face mode-line-highlight
                       local-map ,mode-line-major-mode-keymap)
         '(utl-mode-info
           ("("
            (:propertize utl-mode-info face font-lock-comment-face)
            ")"))
         `(:propertize minor-mode-alist
                       mouse-face mode-line-highlight
                       help-echo ,mode-help-echo
                       local-map ,mode-line-minor-mode-keymap)
         '(:eval
           (if (buffer-narrowed-p)
               (propertize " ↕"
                           'help-echo "mouse-1: Remove narrowing"
                           'mouse-face 'mode-line-highlight
                           'local-map (make-mode-line-mouse-map 'mouse-1 #'mode-line-widen))
             ""))
         "│"
         (propertize "%]"
                     'help-echo recursive-edit-help-echo
                     'face 'font-lock-warning-face))))


;;; Misc settings and packages

(setq-default
 indicate-buffer-boundaries 'left
 visual-line-fringe-indicators '(nil vertical-bar)
 indicate-empty-lines t
 font-lock-extra-managed-props '(composition))

(setq jit-lock-defer-time 0.1)

;; Make page breaks look fancier than the default "^L".
;; Idea from <http://www.jurta.org/en/emacs/dotemacs>.
(or standard-display-table
    (setq standard-display-table (make-display-table)))
(aset standard-display-table ?\^L
      (let ((line (make-vector 30 ?—)))
        (vconcat line " page break " line)))

(column-number-mode)
(blink-cursor-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)
;; (mouse-avoidance-mode 'banish)

(use-package scroll-bar
  :init
  (setq scroll-bar-mode 'right)
  (scroll-bar-mode 0))

(use-package tooltip
  :defer t
  ;; :init (tooltip-mode 0)
  :config
  (setq tooltip-delay 0.2))

(use-package whitespace
  :defer t
  :diminish " _"
  :config
  (setq
   whitespace-line-column 78
   whitespace-display-mappings
   `((space-mark   ?\s  [?·])
     (space-mark   ?    [?○])
     ;; (newline-mark ?\n  [?↵ ?\n])
     (newline-mark ?\^L ,(aref standard-display-table ?\^L))
     (tab-mark     ?\t  [?⇉ ?\t]))
   whitespace-style
   '(face spaces tabs trailing lines space-before-tab newline
          indentation space-after-tab tab-mark newline-mark)))

(use-package ruler-mode
  :defer t
  :config
  (setq ruler-mode-show-tab-stops t))

(use-package paren
  :init
  (setq show-paren-delay 0.1)
  (show-paren-mode)
  :config
  (setq show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t))

(use-package indent-guide
  :defer t
  :diminish " ¦"
  :config
  (setq
   indent-guide-delay 0.3
   indent-guide-char "¦")
  ;; https://github.com/zk-phi/indent-guide/issues/29
  (defun al/indent-guide-post-command-hook ()
    (if (null indent-guide-delay)
        (indent-guide-show)
      (run-with-idle-timer indent-guide-delay nil
                           #'indent-guide-show)))
  (advice-add 'indent-guide-post-command-hook
    :override 'al/indent-guide-post-command-hook))

(use-package make-color
  :defer t
  :config
  (al/add-hook-maybe 'make-color-mode-hook 'al/bar-cursor-type))

(use-package rainbow-mode
  :defer t
  :diminish (rainbow-mode . " 🖌")
  :config
  (setq rainbow-x-colors t)
  (advice-add 'rainbow-mode :after #'utl-refontify))

(use-package hl-todo
  :defer t
  :init
  (setq hl-todo-keyword-faces
        (mapcar (lambda (word)
                  (cons word 'hl-todo))
                '("TODO" "FIXME" "XXX" "WARNING")))
  :config
  (setq hl-todo-keywords
        `(((lambda (_)
             (let (case-fold-search)
               (re-search-forward hl-todo-regexp nil t)))
           (1 (hl-todo-get-face) t t)))))

;;; visual.el ends here
