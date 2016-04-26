;;; al-key.el --- Additional functionality for working with key bindings

;; Copyright © 2013-2016 Alex Kost

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

;;; Code:


;;; Binding keys

;; `al/bind-keys' macro and related code originates from `bind-key'
;; package: <https://github.com/jwiegley/use-package>.

(defvar al/override-global-map (make-keymap)
  "Keymap with key bindings to take precedence over other keymaps.")

(define-minor-mode al/override-global-mode
  "Minor mode with key bindings to override other modes."
  t "")

(add-to-list 'emulation-mode-map-alists
             `((al/override-global-mode . ,al/override-global-map)))

(defun al/key-command (cmd-spec)
  "Return command value for `al/bind-key' macro."
  (cond ((null cmd-spec) nil)
        ((listp cmd-spec)
         (if (eq (car cmd-spec) 'lambda)
             cmd-spec
           `(lambda () (interactive) ,@cmd-spec)))
        (t `',cmd-spec)))

(defmacro al/bind-key (key-name command &optional keymap)
  "Bind KEY-NAME to COMMAND in KEYMAP.

KEY-NAME should be a string taken by `read-kbd-macro'.

COMMAND may be either:

  - nil (to unbind the key if it is already bound in KEYMAP),
  - a command name (an unquoted symbol),
  - or a list (it will be wrapped into interactive `lambda' form).

If KEYMAP is not specified, use `global-map'.

Examples:

  (al/bind-key \"C-f\" nil)
  (al/bind-key \"C-j\" newline lisp-mode-map)
  (al/bind-key \"C-s-b\" ((backward-word) (backward-char)))"
  (let ((command (al/key-command command))
        (key-var (make-symbol "key"))
        (map-var (make-symbol "map")))
    `(let* ((,key-var (read-kbd-macro ,key-name))
            (,map-var (or ,keymap global-map)))
       ,(if command
            `(define-key ,map-var ,key-var ,command)
          `(when (lookup-key ,map-var ,key-var)
             (define-key ,map-var ,key-var nil))))))

(defmacro al/bind-key* (key-name command)
  `(al/bind-key ,key-name ,command al/override-global-map))

(defmacro al/bind-keys (&rest args)
  "Bind multiple keys.

ARGS are keyword arguments and key specifications.  The following
optional keywords are available:

  - `:map' - a keymap into which the key bindings should be added.

  - `:prefix-map' - name of a prefix map that should be created
    for these bindings.

  - `:prefix' - prefix key for these bindings.

  - `:prefix-docstring' - docstring of the prefix map variable.

The rest ARGS are conses of key binding strings and functions.
See `al/bind-key' for details."
  (let* ((map        (plist-get args :map))
         (doc        (plist-get args :prefix-docstring))
         (prefix-map (plist-get args :prefix-map))
         (prefix     (plist-get args :prefix))
         (bindings   (progn
                       (while (keywordp (car args))
                         (pop args)
                         (pop args))
                       args)))
    (or (and prefix prefix-map)
        (and (not prefix) (not prefix-map))
        (error "Both :prefix-map and :prefix must be supplied"))
    `(progn
       ,(when prefix-map
          `(progn
             (defvar ,prefix-map)
             ,(when doc
                `(put ',prefix-map 'variable-documentation ,doc))
             (define-prefix-command ',prefix-map)
             (al/bind-key ,prefix ,prefix-map ,map)))
       ,@(mapcar (lambda (form)
                   `(al/bind-key ,(car form) ,(cdr form)
                                 ,(or prefix-map map)))
                 bindings))))

(defmacro al/bind-keys* (&rest args)
  `(al/bind-keys :map al/override-global-map ,@args))

(provide 'al-key)

;;; al-key.el ends here