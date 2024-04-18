; init for vscode
(declaim (sb-ext:muffle-conditions cl:style-warning))
(let ((sys (merge-pathnames "cl-welearn.asd" (uiop:getcwd))))
    (asdf:load-asd sys)
    (ql:quickload :cl-welearn))
