(defpackage cl-welearn
    (:use :cl)
    (:import-from :cl-welearn.auth
                  #:cookies<-cred
                  #:prompt-passwd)
    (:import-from :cl-welearn.learn
                  #:learn)
    (:import-from :cl-welearn.pprint
                  #:format-table)
    (:import-from :uiop
                  #:getenv)
    (:export :main))
(in-package :cl-welearn)

(defparameter welearn-account (getenv "WELEARN_ACCOUNT"))
(defparameter welearn-password (getenv "WELEARN_PASSWORD"))

(defun main ()
    (prompt-passwd welearn-account welearn-password)
    (learn))
