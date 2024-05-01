(defsystem "cl-welearn/deploy"
           :long-name "cl-finish-welearn"
           :author "Evan Gao"
           :maintainer "Evan Gao"
           :mailto "evan@brmb.me"
           :license "BSD 2-Clause"
           :homepage "https://github.com/notch1p/cl-welearn"
           :source-control "https://github.com/notch1p/cl-welearn.git"
           :defsystem-depends-on (:deploy)
           :depends-on ("bordeaux-threads"
                        "cl-dotenv"
                        "str"
                        "dexador"
                        "cl-cookie"
                        "clingon"
                        "com.inuoe.jzon"
                        "cl-ppcre"
                        "quri"
                        "alexandria"
                        "cl-ansi-text"
                        "cl-interpol"
                        "cl-ansi-term"
                        "cl-tqdm")
           :serial t
           :components ((:module "src"
                                 :serial t
                                 :components
                                 ((:file "pprint")
                                  (:file "auth")
                                  (:file "afk")
                                  (:file "learn")
                                  (:file "main"))))

           :description "it finishes homework for you"
           :build-operation "deploy-op"
           :build-pathname "finishit"
           :entry-point "cl-welearn:main")

(defsystem "cl-welearn"
           :long-name "cl-finish-welearn"
           :author "Evan Gao"
           :maintainer "Evan Gao"
           :mailto "evan@brmb.me"
           :license "BSD 2-Clause"
           :homepage "https://github.com/notch1p/cl-welearn"
           :source-control "https://github.com/notch1p/cl-welearn.git"
           :depends-on ("bordeaux-threads"
                        "cl-dotenv"
                        "str"
                        "dexador"
                        "cl-cookie"
                        "clingon"
                        "com.inuoe.jzon"
                        "cl-ppcre"
                        "quri"
                        "alexandria"
                        "cl-ansi-text"
                        "cl-interpol"
                        "cl-ansi-term"
                        "cl-tqdm")
           :serial t
           :components ((:module "src"
                                 :serial t
                                 :components
                                 ((:file "pprint")
                                  (:file "auth")
                                  (:file "afk")
                                  (:file "learn")
                                  (:file "main"))))

           :description "it finishes homework for you"
           :build-operation "program-op"
           :build-pathname "bin/finishit"
           :entry-point "cl-welearn:main")
