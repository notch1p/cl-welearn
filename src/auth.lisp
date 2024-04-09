(defpackage :cl-welearn.auth
    (:use #:cl)
    (:import-from :cl-cookie #:make-cookie-jar)
    (:export :*global-cookies*
             :cookies<-cred
             :prompt-passwd))
(in-package cl-welearn.auth)

(defparameter *prelogin-redirect* "https://welearn.sflep.com/user/prelogin.aspx?loginret=http%3a%2f%2fwelearn.sflep.com%2fuser%2floginredirect.aspx")
(defparameter *login-url* "https://sso.sflep.com/idsvr/account/login")
(defparameter *global-cookies* (make-cookie-jar))

(defun cookies<-cred (user pwd)
    "Retrieve cookies from `user: username` and `pwd: password`"
    (let* ((headers (nth-value 2
                               (dex:get *prelogin-redirect*
                                   :max-redirects 0
                                   :cookie-jar *global-cookies*)))
           (location (gethash "location" headers))
           (rturl (subseq location 27))
           (data `(("rturl" . ,rturl)
                   ("account" . ,user)
                   ("pwd" . ,pwd))))
        (dex:post *login-url*
            :content data
            :cookie-jar *global-cookies*)
        (dex:get location
            :cookie-jar *global-cookies*)
        *global-cookies*))

(defun prompt-passwd (&optional user passwd)
    (format t "Enter username and password line by line:~%")
    (force-output)
    (cookies<-cred
     (if user user (read-line))
     (if passwd passwd (read-line))))
