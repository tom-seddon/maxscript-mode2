;;; MaxScript mode.

;; Author: Tom Seddon <maxscript-mode2@tomseddon.plus.com>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Copyright (C) 2013 Tom Seddon	

;; Permission is hereby granted, free of charge, to any person
;; obtaining a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without
;; restriction, including without limitation the rights to use, copy,
;; modify, merge, publish, distribute, sublicense, and/or sell copies
;; of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgroup maxscript nil
  "Major mode for editing MAXScript code."
  :prefix "maxscript-"
  :group 'languages)

(defcustom maxscript-indent-offset 8
  "Default indentation offset for maxscript."
  :group 'maxscript
  :type 'integer
  :safe 'integerp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun maxscript-indent-depth ()
  (let* ((ppss (syntax-ppss (point)))
	 (depth (car ppss)))
    (if (< depth 0)
	0
      depth)))

(defun maxscript-indent-line-function ()
  (back-to-indentation)
  (let ((depth (maxscript-indent-depth)))
    ;; back up 1 if first char is ")"
    (when (equal (following-char) ?\))
      (setq depth (- depth 1))
      (when (< depth 0)
	(setq depth 0)))
    
    (beginning-of-line)
    (delete-horizontal-space)
    (indent-to (* depth maxscript-indent-offset))))

(defun maxscript-indent-electric-close-bracket (arg)
  (interactive "*P")
  (self-insert-command (if (not (integerp arg))
			   1
			 arg))
  (when (and (not arg)
	     (eolp))
    (save-excursion
      (maxscript-indent-line-function))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-derived-mode
  maxscript-mode
  prog-mode
  "maxscript"
  "Mode for editing MAXScript source code."

  ;; comment.
  (make-local-variable 'comment-start)
  (setq comment-start "-- ")

  ;; font lock.
  (setq font-lock-defaults '(nil nil nil))

  ;; indent line
  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'maxscript-indent-line-function)
  (setq indent-tabs-mode t)

  ;; imenu
  (setq imenu-generic-expression
	(let ((ident '(1+ (any "A-Za-z0-9_"))))
	  `(("function" ,(rx line-start (0+ space) (or "fn" "function") (1+ space) (group (eval ident))) 1)
	    ("rollout" ,(rx line-start (0+ space) "rollout" (1+ space) (group (eval ident))) 1)
	    ("plugin" ,(rx line-start (0+ space) "plugin" (1+ space) (eval ident) (1+ space) (group (eval ident))) 1)
	    ("struct" ,(rx line-start (0+ space) "struct" (1+ space) (group (eval ident))) 1)
	    )))

  ;; syntax stuff.
  (let ((s maxscript-mode-syntax-table))
    (modify-syntax-entry ?- ". 12" s)
    (modify-syntax-entry ?/ ". 14b" s)
    (modify-syntax-entry ?* ". 23b" s)
    (modify-syntax-entry ?\n ">" s)
    (modify-syntax-entry ?\" "\"" s)
    (modify-syntax-entry ?\( "(" s)
    (modify-syntax-entry ?\) ")" s)
    (modify-syntax-entry ?\\ "\\" s)
    )
  )

(define-key maxscript-mode-map (kbd ")") 'maxscript-indent-electric-close-bracket)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar maxscript-load-hook nil
  "hook for maxscript-mode")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(run-hooks 'maxscript-load-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'maxscript2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
