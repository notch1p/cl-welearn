(defpackage :cl-welearn.pprint
    (:use #:cl)
    (:export :format-table))
(in-package cl-welearn.pprint)


(defparameter *CELL-FORMATS-DIRECTIVE* '(:left "~vA"
                                               :center "~v:@<~A~>"
                                               :right "~v@A"))

(defun format-table (stream data &key (column-label (loop for i from 1 to (length (car data))
                                                          collect (format nil "COL~D" i)))
                            (column-align (loop for i from 1 to (length (car data))
                                                collect :left))
                            (header t))
    (let* ((col-count (length column-label))
           (strtable (cons column-label ; table header
                           (loop for row in data ; table body with all cells as strings
                                 collect (loop for cell in row
                                               collect (if (stringp cell)
                                                           cell
                                                           ;else
                                                           (format nil "~A" cell))))))
           (col-widths (loop with widths = (make-array col-count :initial-element 0)
                             for row in strtable
                             do (loop for cell in row
                                      for i from 0
                                      do (setf (aref widths i)
                                             (max (aref widths i) (length cell))))
                             finally (return widths))))
        ;------------------------------------------------------------------------------------
        ; splice in the header separator
        (setq strtable
                (nconc (list (car strtable) ; table header
                             (loop for align in column-align ; generate separator
                                   for width across col-widths
                                   collect (case align
                                               (:left (format nil ":~v@{~A~:*~}"
                                                          (1- width) "-"))
                                               (:right (format nil "~v@{~A~:*~}:"
                                                           (1- width) "-"))
                                               (:center (format nil ":~v@{~A~:*~}:"
                                                            (- width 2) "-")))))
                    (cdr strtable))) ; table body
        ;------------------------------------------------------------------------------------
        ; Generate the formatted table
        (let ((row-fmt (format nil "| ~{~A~^ | ~} |~~%" ; compile the row format
                           (loop for align in column-align
                                 collect (getf *CELL-FORMATS-DIRECTIVE* align))))
              (widths (loop for w across col-widths collect w)))
            ; write each line to the given stream
            (dolist (row (if header strtable (subseq strtable 2)))
                (apply #'format stream row-fmt (mapcan #'list widths row))))))
