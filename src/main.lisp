(defpackage cl-welearn
  (:use :cl)
  (:import-from :cl-welearn.auth
                #:prompt-passwd)
  (:import-from :cl-welearn.learn
                #:learn)
  (:import-from :clingon
                #:make-command
                #:make-option
                #:getopt)
  (:import-from :dotenv #:load-env)
  (:export :main))
(in-package :cl-welearn)


(defun main ()
  (setq dex:*connection-pool* (dex:make-connection-pool 50))
  (when (probe-file ".env") (load-env ".env"))
  (clingon:run (app/command)))

(defun app/command ()
  (make-command
    :name "finishit"
    :description "it finishes homework for you so you don't have to"
    :authors '("notch1p <evan@brmb.me>")
    :version "final"
    :license "BSD 2-Clause"
    :options (app/options)
    :handler (lambda (cmd)
               (let ((account (getopt cmd :welearn-account))
                     (password (getopt cmd :welearn-password)))
                 (when (getopt cmd :proxy?) (setq dex:*default-proxy* nil) (format t "INFO: Proxy settings omitted~%"))
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
     :key :welearn-password)
   (make-option :flag
     :description "omit proxy settings from Env"
     :long-name "no-proxy"
     :key :proxy?)))

