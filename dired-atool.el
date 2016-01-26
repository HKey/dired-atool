;;; dired-atool.el --- Atool utilities for dired.    -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Hiroki YAMAKAWA

;; Author: Hiroki YAMAKAWA <s06139@gmail.com>
;; URL: https://github.com/HKey/dired-atool
;; Version: 0.1.0
;; Package-Requires: ((emacs "24"))
;; Keywords: files

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

;;; Commentary:

;;

;;; Code:

(require 'dired)
(require 'dired-aux)


(defgroup dired-atool nil
  "Atool utilities for dired."
  :group 'dired
  :prefix "dired-atool-")

(defcustom dired-atool-atool "atool"
  "Atool program which is used to pack/unpack files."
  :type 'string
  :group 'dired-atool
  :package-version '(dired-atool . "0.1.0"))


(defun dired-atool--buffer-name (message)
  "Make a buffer name using MESSAGE."
  (format "*dired-atool: %s*" message))

(defun dired-atool--async-shell-command (command-list)
  "A wrapper function to call `async-shell-command'.
COMMAND-LIST is a list of a command separated by spaces."
  (let* ((command (mapconcat #'shell-quote-argument command-list " "))
         (buffer-name (dired-atool--buffer-name command)))
    (async-shell-command command buffer-name buffer-name)))

(defun dired-atool--make-directory (dir prompt)
  "Make DIR directory if the answer of PROMPT is yes."
  (when (yes-or-no-p prompt)
    (make-directory dir t)
    t))

;;;###autoload
(defun dired-atool-do-unpack (&optional arg)
  "Unpack file(s) with atool.
ARG is used for `dired-get-marked-files'."
  (interactive "P")
  (let* ((files (dired-get-marked-files t arg))
         (dir (expand-file-name    ; to expand "~" to a real path name
               (read-directory-name
                (format "Unpack %s to: "
                        (mapconcat #'identity files ", "))
                (dired-dwim-target-directory))))
         (command-list `(,dired-atool-atool
                         ,(concat "--extract-to=" dir)
                         "--each"
                         ,@files)))
    (if (or (file-exists-p dir)
            (dired-atool--make-directory
             dir
             (format
              "Directory %s does not exist. Make it before unpacking?"
              dir)))
        (dired-atool--async-shell-command command-list)
      (message "Unpacking canceled."))))

;;;###autoload
(defun dired-atool-do-pack (&optional arg)
  "Pack file(s) with atool.
ARG is used for `dired-get-marked-files'."
  (interactive "P")
  (let* ((files (dired-get-marked-files t arg))
         (archive (expand-file-name ; to expand "~" to a real path name
                   (read-file-name
                    (format "Pack %s to: "
                            (mapconcat #'identity files ", "))
                    (dired-dwim-target-directory))))
         (dir (directory-file-name (file-name-directory archive)))
         (command-list `(,dired-atool-atool
                         "--add"
                         ,archive
                         ,@files)))
    (if (or (file-exists-p dir)
            (dired-atool--make-directory
             dir
             (format
              "Directory %s does not exist. Make it before packing?"
              dir)))
        (dired-atool--async-shell-command command-list)
      (message "Packing canceled."))))

;;;###autoload
(defun dired-atool-setup ()
  "Setup key bindings of dired-atool commands."
  (interactive)
  (define-key dired-mode-map (kbd "z") #'dired-atool-do-unpack)
  (define-key dired-mode-map (kbd "Z") #'dired-atool-do-pack))

(provide 'dired-atool)
;;; dired-atool.el ends here
