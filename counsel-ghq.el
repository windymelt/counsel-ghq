;;; counsel-ghq.el --- ghq with counsel interface -*- lexical-binding: t; -*-

;; Copyright (C) 2016 by Keisuke Noguchi

;; Author: Keisuke Noguchi <windymelt@3qe.us>
;; URL: https://github.com/windymelt/counsel-ghq
;; Keywords: lisp counsel ghq
;; Version: 0.0.1
;; Package-Requires: ((emacs "24") (ivy "0.9.1"))

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

;; counsel-ghq.el provides a counsel interface to "ghq".

;;; Code:

(require 'ivy)

(defgroup counsel-ghq nil
  "ghq with counsel interface"
  :prefix "counsel-ghq-"
  :group 'counsel)

(defcustom counsel-ghq-command-ghq
  "ghq"
  "*A ghq command"
  :type 'string
  :group 'counsel-ghq)

(defcustom counsel-ghq-command-ghq-arg-list
  '("list" "--full-path")
  "*Arguments for getting ghq list"
  :type '(repeat string)
  :group 'counsel-ghq)

(defcustom counsel-ghq-command-git
  "git"
  "*A git command"
  :type 'string
  :group 'counsel-ghq)

(defcustom counsel-ghq-command-git-arg-ls-files
  '("ls-files")
  "*Arguments for getting file list in git repository"
  :type '(repeat string)
  :group 'counsel-ghq)

(defcustom counsel-ghq-command-hg
  "hg"
  "*A hg command"
  :type 'string
  :group 'counsel-ghq)

(defcustom counsel-ghq-command-hg-arg-ls-files
  '("manifest")
  "*Arguments for getting file list in hg repository"
  :type '(repeat string)
  :group 'counsel-ghq)

(defcustom counsel-ghq-command-svn
  "svn"
  "*A svn command"
  :type 'string
  :group 'counsel-ghq)

(defcustom counsel-ghq-command-svn-arg-ls-files
  '("list" "--recursive")
  "*Arguments for getting files (and directories) list in svn repository"
  :type '(repeat string)
  :group 'counsel-ghq)

(defun counsel-ghq--open-dired (file)
  (dired (file-name-directory file)))

(ivy-set-actions 'counsel-ghq
  '(("o" find-file "Open File")
    ("O" find-file-other-window "Open File other window")
    ("f" find-file-other-frame "Open File other frame")
    ("d" counsel-ghq--open-dired "Open Directory")))

(defmacro counsel-ghq--line-string ()
  `(buffer-substring-no-properties
    (line-beginning-position) (line-end-position)))

(defun counsel-ghq--list-candidates ()
  (with-temp-buffer
    (unless (zerop (apply #'call-process
                          counsel-ghq-command-ghq nil t nil
                          counsel-ghq-command-ghq-arg-list))
      (error "Failed: Can't get ghq list candidates"))
    (let ((paths))
      (goto-char (point-min))
      (while (not (eobp))
        (push (counsel-ghq--line-string) paths)
        (forward-line 1))
      (reverse paths))))

(defun counsel-ghq--ls-files ()
  (with-temp-buffer
    (unless (or (zerop (or (ignore-errors
                             (apply #'call-process
                                    counsel-ghq-command-git nil '(t nil) nil
                                    counsel-ghq-command-git-arg-ls-files))
                           1))
                (zerop (or (ignore-errors
                             (apply #'call-process
                                    counsel-ghq-command-svn nil '(t nil) nil
                                    counsel-ghq-command-svn-arg-ls-files))
                           1))
                (zerop (or (ignore-errors
                             (apply #'call-process
                                    counsel-ghq-command-hg nil t nil
                                    counsel-ghq-command-hg-arg-ls-files))
                           1)))
      (error "Failed: Can't get file list candidates"))
    (split-string (buffer-string))))

(defun counsel-ghq--source (repo)
  (let ((name (file-name-nondirectory (directory-file-name repo))))
    (ivy-read (concat name ": ")
              (counsel-ghq--ls-files)
              :action (lambda (path) (find-file path)))))

;;;###autoload
(defun counsel-ghq ()
  "Ivy interface for ghq."
  (interactive)
  (ivy-read (concat "ghq list [M-o to menu]: ") (counsel-ghq--list-candidates)
            :keymap counsel-describe-map
            :preselect (counsel-symbol-at-point)
            :history 'counsel-describe-symbol-history
            :require-match t
            :sort nil
            :action (lambda (repo)
                      (let ((default-directory (file-name-as-directory repo)))
                        (counsel-ghq--source default-directory)))
            :caller 'counsel-ghq))

(provide 'counsel-ghq)

;;; counsel-ghq.el ends here
