(defpackage cl-welearn/tests/main
  (:use :cl
        :cl-welearn
        :rove))
(in-package :cl-welearn/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-welearn)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
