;;;; quickmonkeys.lisp -*- Mode: Lisp;-*- 

(cl:in-package :quickmonkeys)

(defvar *component-class*
  #+(and :asdf2 (not :asdf3)) 'asdf::COMPONENTS
  #+asdf3 'asdf::CHILDREN)


(Defun system-components (system)
  (Slot-Value (asdf::component-system system)
              *component-class*))


(Defun has-components-p (obj)
  (Slot-Exists-P obj *component-class*))


(Defun components (obj)
  (Slot-Value obj *component-class*))


(Defun flatten-components (compos)
  (Cond ((Null compos) nil)
        ((Atom compos)
         (If (has-components-p compos)
             (flatten-components (components compos))
             (List compos)))
        (T
         (Append (flatten-components (Car compos))
                 (flatten-components (Cdr compos))))))


(Defun find-source-component-by-name (name system)
  (Find name
        (flatten-components (system-components system))
        :test #'String=
        :key (Lambda (c)
               (when (Slot-Exists-P c 'asdf::name)
                 (Slot-Value c 'asdf::name)))))


(Defun source-component-name (sc)
  (if (Slot-Exists-P sc 'asdf::name)
      (Slot-Value sc 'asdf::name)
      ""))


(Defun do-patch (orig patch)
  (Dolist (compo
           (Remove-If-Not (Lambda (x)
                            (typep x 'asdf::source-file))
                          (flatten-components (find-system patch))))
    (Let ((oc (find-source-component-by-name (source-component-name compo)
                                             (find-system orig)))
          (pc (find-source-component-by-name (source-component-name compo)
                                             (find-system patch))))
      (defmethod perform :around (operation (component (Eql oc)))
        (format *debug-io*
                "~&;;; Patching: ~A ~S ...~2%     w  c(..)o   ( 
      \\__(-)    __)
          /\\   (
         /(_)___)
         w /|
          | \\
         m  m    ...~2%"
                orig
                oc)
        (asdf:perform operation pc))))
  (when (#+(and asdf2 (not asdf3)) asdf::system-loaded-p
         #+asdf3 asdf::component-loaded-p
         (find-system orig))
    (load-system orig :force (List orig))))


(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun kludgy-fix (name patch-name)
    #+(or clisp lispworks allegro-v8.2 cmucl)
    (progn
      (setf (slot-value (find-system patch-name) 'asdf::SOURCE-FILE)
            (system-source-file (find-system :quickmonkeys)))
      (dolist (c (flatten-components (system-components (find-system patch-name))))
        (setf (slot-value c 'asdf::ABSOLUTE-PATHNAME)
              (merge-pathnames (make-pathname
                                :directory (list :relative "monkeys"
                                                 (string-downcase name))
                                :name (Slot-Value c 'asdf::name)
                                :type "lisp")
                               (system-source-directory
                                (find-system :quickmonkeys))))))))


(defmacro defpatch (name &body files)
  (let ((patch-name (intern (concatenate 'string (string name) (string '#:.patch))
                            :keyword)))
    `(progn
       (defsystem ,patch-name
           :serial t
         :components
         ((:module "monkeys"
                   :components
                   ((:module ,(string-downcase name)
                             ,@files)))))
       (kludgy-fix ,name ,patch-name)
       (do-patch ,name ,patch-name))))


;;; *EOF*


