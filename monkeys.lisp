(cl:in-package :quickmonkeys)


#+scl
(defpatch :trivial-gray-streams
    :components ((:file "package")))


#+scl
(defpatch :cl+ssl
  :components ((:file "reload")))


#+clisp
(defpatch :chirp
  :components ((:file "generics")))


#+clisp
(defpatch :3bmd
  :components ((:file "extensions")))


#+clisp
(defpatch :drakma
  :components ((:file "request")))


#+lispworks6
(defpatch :arnesi
  :components ((:file "lexenv")))


#+#:obsolete
(defpatch :cl-oauth
  :components ((:file "consumer")))


;;; *EOF*
