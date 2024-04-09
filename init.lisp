; init for vscode
(let ((sys (merge-pathnames "cl-welearn.asd" (uiop:getcwd))))
    (asdf:load-asd sys)
    (ql:quickload :cl-welearn))
