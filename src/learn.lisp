(defpackage :cl-welearn.learn
    (:use #:cl)
    (:import-from :cl-cookie #:make-cookie-jar)
    (:import-from :cl-welearn.auth
                  #:*global-cookies*
                  #:cookies<-cred)
    (:import-from :str #:containsp #:repeat #:replace-first)
    (:import-from :com.inuoe.jzon #:parse)
    (:import-from :cl-welearn.pprint #:format-table)
    (:import-from :cl-ppcre #:scan-to-strings)
    (:import-from :quri #:make-uri)
    (:import-from :cl-ansi-text #:green #:red)
    (:export :with-hint-input
             :print-query-results))
(in-package cl-welearn.learn)
(named-readtables:in-readtable :interpol-syntax)
(defparameter *query-uri* "https://welearn.sflep.com/ajax/authCourse.aspx?action=gmc")

(defparameter *result* nil)

(defun print-line ()
    (format t "~A~%" (repeat 51 "=")))

(defun query-courses ()
    (let* ((res (dex:get *query-uri*
                    :headers '(("Referer" . "https://welearn.sflep.com/student/index.aspx"))
                    :cookie-jar *global-cookies*
                    :force-string t)))
        (if (or (containsp "\"clist\":[]}" res)
                (not (containsp "clist" res)))
            (error "No course available or invalid login.~%")
            (progn (format t "Query courses success.~%")
                   (print-line)
                   (format t "My courses (Index, Course Name, Progress%):~%")
                   (let* ((back (gethash "clist" (parse res))))
                       (setf *result* back)
                       (loop for i from 0
                             for h across back collect
                                 (list
                                  i
                                  (gethash "name" h)
                                  (gethash "per" h))))))))

(defun print-query-results (tabular)
    (format-table t tabular :header nil)) ; header off for wide chars

(defmacro with-hint-input (hint divider? &body body)
    `(progn
      (when ,divider? (format t "===================================================~%"))
      (format t ,hint)
      (force-output)
      ,@body))

(defun query-units ()
    (let* ((idx (read))
           (cid (write-to-string (gethash
                                     "cid"
                                     (elt *result* idx))))
           (uri (replace-first "${CID}" cid "https://welearn.sflep.com/student/course_info.aspx?cid=${CID}"))
           (res (dex:get uri :cookie-jar *global-cookies*))
           (uid (elt
                    (nth-value 1
                               (scan-to-strings "\"uid\":(.*?)," res))
                    0))
           (classid (elt
                        (nth-value 1
                                   (scan-to-strings "\"classid\":\"(.*?)\"" res))
                        0)))
        (setf res (parse (dex:get (make-uri
                                   :defaults "https://welearn.sflep.com/ajax/StudyStat.aspx"
                                   :query `(("action" . "courseunits") ("cid" . ,cid) ("uid" . ,uid)))
                             :cookie-jar *global-cookies*
                             :headers '(("Referer" . "https://welearn.sflep.com/student/course_info.aspx")))))
        (let* ((back (gethash "info" res))
               (unitsum (length back)))
            (values
                (loop for i from 0
                      for h across back collect
                          (if (string= (gethash "visible" h) "true")
                              (list i (green "[Currently Visible]") (gethash "unitname" h) (gethash "name" h))
                              (list i (red "[Currently Invisible]") (gethash "unitname" h) (gethash "name" h))))
                cid
                uri
                uid
                classid
                idx
                unitsum))))

(defun random-between (min max)
    "generate a random number in [MIN,MAX)"
    (+ min (random (- max min))))


(defun choose-unit ()
    (with-hint-input "Choose one by its index (or <C-d> to exit): "
                     t
                     (multiple-value-bind (tabular
                                           cid
                                           referer-in-infoheader
                                           uid
                                           classid
                                           idx
                                           unitsum)
                             (query-units)
                         (print-query-results tabular)
                         (with-hint-input
                          "Either set a fixed Correct% or a closed interval.~%Syntax: '(70 100)' for correct% between 70% and 100% and '93' for a 93% correctness." t
                          (let* ((correctness (read))
                                 (rand? (cond ((typep correctness 'cons) t)
                                              ((typep correctness 'number) nil)
                                              (t (error "Correctness:~A is not a type of CONS or NUMBER" (type-of correctness)))))
                                 (way1-success? nil)
                                 (way2-success? nil)
                                 (ajaxurl "https://welearn.sflep.com/Ajax/SCO.aspx")
                                 (infoheaders
                                  `(("Referer" . ,referer-in-infoheader)))
                                 (uri
                                  #?"https://welearn.sflep.com/ajax/StudyStat.aspx?action=scoLeaves&cid=${cid}&uid=${uid}&unitidx=${idx}&classid=${classid}")
                                 (crate 0))
                              (loop
                               (let* ((res (dex:get uri
                                               :headers infoheaders))
                                      (json (parse res)))
                                   (when (or
                                          (containsp "异常" res)
                                          (containsp "出错了" res))
                                         (return))
                                   (loop for course across (gethash "info" json) do
                                             (if (string= (gethash "isvisible" course) "false")
                                                 (format t "[!!Skipped!!]    ~A" (gethash "location" course))
                                                 (when
                                                  (containsp "未" (gethash "iscomplete" course))
                                                  (if rand?
                                                      (setf crate (random-between
                                                                   (first correctness)
                                                                   (second correctness)))
                                                      (setf crate correctness))
                                                  (let ((data #?"{\"cmi\":{\"completion_status\":\"completed\",\"interactions\":[],\"launch_data\":\"\",\"progress_measure\":\"1\",\"score\":{\"scaled\":\"${crate}\",\"raw\":\"100\"},\"session_time\":\"0\",\"success_status\":\"unknown\",\"total_time\":\"0\",\"mode\":\"normal\"},\"adl\":{\"data\":[]},\"cci\":{\"data\":[],\"service\":{\"dictionary\":{\"headword\":\"\",\"short_cuts\":\"\"},\"new_words\":[],\"notes\":[],\"writing_marking\":[],\"record\":{\"files\":[]},\"play\":{\"offline_media_id\":\"9999\"}},\"retry_count\":\"0\",\"submit_time\":\"\"}}[INTERACTIONINFO]")
                                                        (id (gethash "id" course))))))))))))))
