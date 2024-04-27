(defpackage cl-welearn
    (:use :cl)
    (:import-from :cl-welearn.learn
                  #:learn)
    (:import-from :clingon
                  #:make-command
                  #:make-option
                  #:getopt)
    (:export :main))
(in-package :cl-welearn)

(defun main ()
    (clingon:run (app/command)))

(defun app/command ()
    (make-command
        :name "finishit"
        :description "it finishes homework for you so you don't waste any time on english."
        :authors '("notch1p <evan@brmb.me>")
        :version "final"
        :license "BSD 2-Clause"
        :options (app/options)
        :handler (lambda (cmd)
                     (let ((account (getopt cmd :welearn-account))
                           (password (getopt cmd :welearn-password)))
                         (prompt-passwd account password)
                         (learn)))))

(defun app/options ()
    (list
     (make-option :string
         :description "your welearn account"
         :short-name #\u
         :long-name "user"
         :env-vars '("WELEARN_ACCOUNT")
         :key :welearn-account)
     (make-option :string
         :description "your welearn password"
         :short-name #\p
         :long-name "password"
         :env-vars '("WELEARN_PASSWORD")
         :key :welearn-password)))
