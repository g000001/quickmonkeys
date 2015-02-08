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


#+allegro
(defpatch :cl-oauth
    :components (#+#:obsolete
                 (:file "consumer")
                 (:file "uri")))


#+cmu
(defpatch :ironclad
  :components ((:file "modes")))


#+cmu
(defpatch :kmrcl
  ;; error: Misplaced declaration.
    :components ((:file "processes")))


#+cmu
(defpatch :named-readtables
    ;; fix: type declaration.
  :components ((:file "define-api")))


;;; *EOF*


