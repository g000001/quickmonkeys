;;;; quickmonkeys.asd -*- Mode: Lisp;-*- 

(cl:in-package :asdf)


(defsystem :quickmonkeys
  :serial t
  :components ((:file "package")
               (:file "quickmonkeys")
               (:file "monkeys")))


;;; *EOF*
