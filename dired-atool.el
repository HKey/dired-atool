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


;;;###autoload
(defun dired-atool-do-unpack (&optional arg)
  "Unpack file(s) with atool.
ARG is used for `dired-get-marked-files'."
  (interactive "P")
  (let* ((files (dired-get-marked-files nil arg))
         (dir (read-directory-name
               (format "Unpack %s to: "
                       (mapconcat #'file-name-nondirectory files ", "))
               (dired-dwim-target-directory)))
         (command (mapconcat #'shell-quote-argument
                             `(,dired-atool-atool
                               ,(concat "--extract-to=" dir)
                               "--each"
                               ,@files)
                             " ")))
    (async-shell-command command "*dired-atool*")))

;;;###autoload
(defun dired-atool-do-pack (&optional arg)
  "Pack file(s) with atool.
ARG is used for `dired-get-marked-files'."
  (interactive "P")
  (let* ((files (dired-get-marked-files t arg))
         (archive (read-file-name
                   (format "Pack %s to: "
                           (mapconcat #'identity files ", "))
                   (dired-dwim-target-directory)))
         (command (mapconcat #'shell-quote-argument
                             `(,dired-atool-atool
                               "--add"
                               ,archive
                               ,@files)
                             " ")))
    (async-shell-command command "*dired-atool*")))

(provide 'dired-atool)
;;; dired-atool.el ends here
