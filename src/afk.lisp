(defpackage :cl-welearn.afk
    (:use #:cl #:sb-thread)
    (:import-from :cl-welearn.auth #:*global-cookies*)
    (:import-from :str #:containsp)
    (:import-from :com.inuoe.jzon
                  #:parse))
(in-package :cl-welearn.afk)
(named-readtables:in-readtable :interpol-syntax)

(defmacro bulk-set (&rest pairs)
    `(progn
      ,@(loop for (sym val) on pairs by #'cddr
              collect `(setq ,sym ,val))))

(defun start-afk (afk-time x uid cid)
    (let* ((scoid (gethash "id" x))
           (url "https://welearn.sflep.com/Ajax/SCO.aspx")
           (req1
            (dex:post url
                :content `(("action" . "getscoinfo_v7")
                           ("uid" . ,uid)
                           ("cid" . ,cid)
                           ("scoid" . ,scoid))
                :cookie-jar *global-cookies*
                :headers '(("Referer" . "https://welearn.sflep.com/student/StudyCourse.aspx"))))
           (back)
           (cstatus)
           (progress)
           (session_time)
           (total_time)
           (crate))
        (when (containsp "学习数据不正确" req1)
              (setq req1 (dex:post url
                             :content `(("action" . "startsco160928")
                                        ("uid" . ,uid)
                                        ("cid" . ,cid)
                                        ("scoid" . ,scoid))
                             :cookie-jar *global-cookies*
                             :headers '(("Referer" . "https://welearn.sflep.com/student/StudyCourse.aspx"))))
              (setq req1 (dex:post url
                             :content `(("action" . "getscoinfo_v7")
                                        ("uid" . ,uid)
                                        ("cid" . ,cid)
                                        ("scoid" . ,scoid))
                             :cookie-jar *global-cookies*
                             :headers '(("Referer" . "https://welearn.sflep.com/student/StudyCourse.aspx"))))
              (when (containsp "学习数据不正确" req1)
                    (format t "Error: ~A~%" (gethash "location" x))
                    (return-from start-afk)))
        (setq back
                (gethash "comment" (parse req1)))
        (if (containsp "cmi" back)
            (progn
             (bulk-set
                 back (gethash "cmi" (parse back))
                 cstatus (gethash "completion_status" back)
                 progress (gethash "progress_measure" back)
                 session_time (gethash "session_time" back)
                 total_time (gethash "total_time" back)
                 crate (gethash "scaled"
                                (gethash "score" back)))
             ;  (setq back (gethash "cmi" (parse back)))
             ;  (setq cstatus (gethash "completion_status" back))
             ;  (setq progress (gethash "progress_measure" back))
             ;  (setq session_time (gethash "session_time" back))
             ;  (setq total_time (gethash "total_time" back))
             ;  (setq crate (gethash "scaled"
             ;                       (gethash "score" back)))
             )
            (bulk-set
                cstatus "not_attempted"
                progress "0"
                session_time "0"
                total_time "0"
                crate ""))
        (setq req1 (dex:post url
                       :content `(("action" . "keepsco_with_getticket_with_updatecmitime")
                                  ("uid" . ,uid)
                                  ("cid" . ,cid)
                                  ("scoid" . ,scoid)
                                  ("session_time" . ,session_time)
                                  ("total_time" . ,total_time))
                       :cookie-jar *global-cookies*
                       :headers '(("Referer" . "https://welearn.sflep.com/student/StudyCourse.aspx"))))
        (loop for nowtime from 1 to (+ afk-time 1) do
                  (sleep 1)
                  (when (= 0 (mod nowtime 60))
                        (setq req1 (dex:post url
                                       :content `(("action" . "keepsco_with_getticket_with_updatecmitime")
                                                  ("uid" . ,uid)
                                                  ("cid" . ,cid)
                                                  ("scoid" . ,scoid)
                                                  ("session_time" . ,session_time)
                                                  ("total_time" . ,total_time))
                                       :cookie-jar *global-cookies*
                                       :headers '(("Referer" . "https://welearn.sflep.com/student/StudyCourse.aspx"))))))
        (setq req1 (dex:post url
                       :content `(("action" . "savescoinfo160928")
                                  ("cid" . ,cid)
                                  ("scoid" . ,scoid)
                                  ("uid" . ,uid)
                                  ("progress" . ,progress)
                                  ("crate" . ,crate)
                                  ("status" . "unknown")
                                  ("cstatus" . ,cstatus)
                                  ("trycount" . "0"))
                       :cookie-jar *global-cookies*
                       :headers '(("Referer" . "https://welearn.sflep.com/student/StudyCourse.aspx"))))))