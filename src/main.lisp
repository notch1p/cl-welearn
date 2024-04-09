(defpackage cl-welearn
    (:use :cl)
    (:import-from :cl-welearn.auth
                  #:cookies<-cred
                  #:prompt-passwd)
    (:import-from :cl-welearn.learn
                  #:print-query-results
                  #:query-courses
                  #:with-hint-input
                  #:query-units)
    (:import-from :cl-welearn.pprint
                  #:format-table)
    (:export :main))
(in-package :cl-welearn)

(defun main ()

    ; get courses
    (prompt-passwd)
    (print-query-results (query-courses))
    (with-hint-input "Choose one or more unit by its index (or <C-d> to exit):~%e.g. '(1 3 5)' for unit 1,3,5. Uses lisp syntax. " t
        (format-table t (query-units)
                      :header nil
                      ;   :column-label '("Index" "Visibility" "#Unit" "Unit Name")
                      ;   :column-align '(:right :center :left :right)
                      )))