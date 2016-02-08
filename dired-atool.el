;;; dired-atool.el --- Pack/unpack files with atool on dired. -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Hiroki YAMAKAWA

;; Author: Hiroki YAMAKAWA <s06139@gmail.com>
;; URL: https://github.com/HKey/dired-atool
;; Version: 1.1.0
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

;; Dired-atool is an utility to pack/unpack files with atool on dired.

;; Please see https://github.com/HKey/dired-atool/blob/master/README.md
;; for more details.

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

(defcustom dired-atool-unpacking-options '("--explain")
  "Additional options for unpacking with atool."
  :type '(repeat string)
  :group 'dired-atool
  :package-version '(dired-atool . "0.1.0"))

(defcustom dired-atool-packing-options '("--explain")
  "Additional options for packing with atool."
  :type '(repeat string)
  :group 'dired-atool
  :package-version '(dired-atool . "0.1.0"))

(defcustom dired-atool-insert-exit-message t
  "Non-nil means that dired-atool inserts an exit message to a process buffer."
  :type 'boolean
  :group 'dired-atool
  :package-version '(dired-atool . "1.1.0"))


(defun dired-atool--buffer-name (message)
  "Make a buffer name using MESSAGE."
  (format "*dired-atool: %s*" message))

(defun dired-atool--exit-message (process)
  "Make a message string about exit of PROCESS."
  (format "%s exited with code %d at %s"
          (mapconcat #'identity (process-command process) " ")
          (process-exit-status process)
          (current-time-string)))

(defun dired-atool--insert-exit-message (process)
  "Insert an exit message in a buffer of PROCESS."
  (with-current-buffer (process-buffer process)
    (insert "\n" (dired-atool--exit-message process))))

(defun dired-atool--async-shell-command (command-list)
  "A wrapper function to call `async-shell-command'.
COMMAND-LIST is a list of a command separated by spaces."
  (let* ((command (mapconcat #'shell-quote-argument command-list " "))
         (buffer-name (dired-atool--buffer-name command)))
    (async-shell-command command buffer-name buffer-name)
    ;; Add an exit message to the process buffer
    (when dired-atool-insert-exit-message
      (let* ((process (get-buffer-process buffer-name))
             (sentinel (process-sentinel process)))
        (set-process-sentinel
         process
         (lambda (process status)
           (when (functionp sentinel)
             (funcall sentinel process status))
           (when (memq (process-status process) '(exit signal))
             (dired-atool--insert-exit-message process))))))))

(defun dired-atool--make-directory (dir prompt)
  "Make DIR directory if the answer of PROMPT is yes."
  (when (yes-or-no-p prompt)
    (make-directory dir t)
    t))

(defun dired-atool--file-names-for-prompt (files)
  "Return a string to show in a prompt message about FILES."
  (if (= (length files) 1)
      (car files)
    (format "* [%d files]" (length files))))


;;;###autoload
(defun dired-atool-do-unpack (&optional arg)
  "Unpack file(s) with atool.
ARG is used for `dired-get-marked-files'."
  (interactive "P")
  (let* ((files (dired-get-marked-files t arg))
         (dir (expand-file-name    ; to expand "~" to a real path name
               (dired-mark-pop-up
                nil nil files
                #'read-directory-name
                (format "Unpack %s to: "
                        (dired-atool--file-names-for-prompt files))
                (dired-dwim-target-directory))))
         (command-list `(,dired-atool-atool
                         ,(concat "--extract-to=" dir)
                         "--each"
                         ,@dired-atool-unpacking-options
                         ,@files)))
    (if (or (file-exists-p dir)
            (dired-atool--make-directory
             dir
             (format
              "Directory %s does not exist.  Make it before unpacking?"
              dir)))
        (dired-atool--async-shell-command command-list)
      (message "Unpacking canceled."))))

;;;###autoload
(defun dired-atool-do-unpack-with-subdirectory (&optional arg)
  "Unpack file(s) with atool.
This command makes subdirectories in the current directory and unpacks
files into them.
ARG is used for `dired-get-marked-files'."
  (interactive "P")
  (let* ((files (dired-get-marked-files t arg))
         (command-list `(,dired-atool-atool
                         "--extract"
                         "--subdir"
                         "--each"
                         ,@dired-atool-unpacking-options
                         ,@files)))
    (if (dired-mark-pop-up nil nil files
                           #'yes-or-no-p
                           (format "Unpack %s?"
                                   (dired-atool--file-names-for-prompt files)))
        (dired-atool--async-shell-command command-list)
      (message "Unpacking canceled."))))

;;;###autoload
(defun dired-atool-do-pack (&optional arg)
  "Pack file(s) with atool.
ARG is used for `dired-get-marked-files'."
  (interactive "P")
  (let* ((files (dired-get-marked-files t arg))
         (archive (expand-file-name ; to expand "~" to a real path name
                   (dired-mark-pop-up
                    nil nil files
                    #'read-directory-name
                    (format "Pack %s to: "
                            (dired-atool--file-names-for-prompt files))
                    (dired-dwim-target-directory))))
         (dir (directory-file-name (file-name-directory archive)))
         (command-list `(,dired-atool-atool
                         "--add"
                         ,archive
                         ,@dired-atool-packing-options
                         ,@files))
         (ok? nil))
    (catch 'cancel
      (when (file-exists-p archive)
        (if (yes-or-no-p
             (format "%s already exists.  Remove it before packing?" archive))
            (delete-file archive)
          (throw 'cancel nil)))
      (unless (or (file-exists-p dir)
                  (dired-atool--make-directory
                   dir
                   (format
                    "Directory %s does not exist.  Make it before packing?"
                    dir)))
        (throw 'cancel nil))
      (setq ok? t))
    (if ok?
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

;; Local Variables:
;; eval: (when (fboundp (quote flycheck-mode)) (flycheck-mode 1))
;; eval: (when (fboundp (quote flycheck-package-setup)) (flycheck-package-setup))
;; End:
