(defsystem "cl-welearn/deploy"
           :long-name "cl-finish-welearn"
           :version "0.1.1"
           :author "Evan Gao"
           :maintainer "Evan Gao"
           :mailto "evan@brmb.me"
           :license "LLGPL"
           :homepage "https://github.com/notch1p/cl-welearn"
           :source-control "https://github.com/notch1p/cl-welearn.git"
           :depends-on ("str"
                        "dexador"
                        "cl-cookie"
                        "cl-utilities"
                        "clingon"
                        "com.inuoe.jzon"
                        "cl-ppcre"
                        "quri"
                        "alexandria"
                        "cl-ansi-text"
                        "cl-interpol")
           :serial t
           :components ((:module "src"
                                 :serial t
                                 :components
                                 ((:file "pprint")
                                  (:file "auth")
                                  (:file "learn")
                                  (:file "main"))))

           :description "Sample library"
           :long-description "Common Lisp sample library"
           :defsystem-depends-on (:deploy)
           :build-operation "deploy-op"
           :build-pathname "finishIt"
           :entry-point "cl-welearn:main")

(defsystem "cl-welearn"
           :long-name "cl-finish-welearn"
           :version "0.1.1"
           :author "Evan Gao"
           :maintainer "Evan Gao"
           :mailto "evan@brmb.me"
           :license "LLGPL"
           :homepage "https://github.com/notch1p/cl-welearn"
           :source-control "https://github.com/notch1p/cl-welearn.git"
           :depends-on ("str"
                        "dexador"
                        "cl-cookie"
                        "cl-utilities"
                        "clingon"
                        "com.inuoe.jzon"
                        "cl-ppcre"
                        "quri"
                        "alexandria"
                        "cl-ansi-text"
                        "cl-interpol")
           :serial t
           :components ((:module "src"
                                 :serial t
                                 :components
                                 ((:file "pprint")
                                  (:file "auth")
                                  (:file "learn")
                                  (:file "main"))))

           :description "Sample library"
           :long-description "Common Lisp sample library"
           :build-operation "program-op"
           :build-pathname "finishIt"
           :entry-point "cl-welearn:main")

; (defsystem "cl-welearn/tests"
;            :author "Evan Gao"
;            :license "LLGPL"
;            :depends-on ("cl-welearn"
;                         "rove")
;            :components ((:module "tests"
;                                  :components
;                                  ((:file "main"))))
;            :description "Test system for cl-welearn"
;            :perform (test-op (op c) (symbol-call :rove :run c)))

; sbcl core compression

; #+sb-core-compression
; (defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
;     (uiop:dump-image (asdf:output-file o c)
;                      :executable t
;                      :compression t))