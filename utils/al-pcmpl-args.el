;;; al-pcmpl-args.el --- Additional functionality for pcmpl-args

;; Copyright © 2015-2016 Alex Kost

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

(require 'pcmpl-args)

;;;###autoload
(defun pcomplete/pre-inst-env ()
  (pcmpl-args-pcomplete
   (pcmpl-args-make-argspecs
    `((argument 0 (("COMMAND" nil))
                :subparser pcmpl-args-command-subparser)))))

(provide 'al-pcmpl-args)

;;; al-pcmpl-args.el ends here
