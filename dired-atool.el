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

(defgroup dired-atool nil
  "Atool utilities for dired."
  :group 'dired
  :prefix "dired-atool-")

(defcustom dired-atool-atool "atool"
  "Atool program which is used to pack/unpack files."
  :type 'string
  :group 'dired-atool
  :package-version '(dired-atool . "0.1.0"))


(provide 'dired-atool)
;;; dired-atool.el ends here
