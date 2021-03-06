;;;; lispski.lisp

(in-package #:lispski)

;;; "lispski" goes here. Hacks and glory await!

(defvar s
  (lambda (x)
    (lambda (y)
      (lambda (z)
        (cons (cons x z)
              (cons y z))))))

(defvar k
  (lambda (x)
    (lambda (y)
      x)))

(defvar i
  (lambda (x)
    x))

(defvar scope
  (list
   (cons 's s)
   (cons 'k k)
   (cons 'i i)))

(defun ski-step (xs)
  (if (atom xs)
      xs
      (let* ((x (ski-eval (car xs)))
             (f (or (and (functionp x) x) (cdr (assoc x scope))))
             (y (ski-eval (cdr xs))))
        (if (null f)
            (cons x y)
            (funcall f y)))))

(defun fix (f xs)
  "Computer the fix-point of f with xs"
  (let ((res (funcall f xs)))
    (if (equal xs res)
        res
        (fix f res))))

(defun ski-eval (terms)
  "Evaluate the SKI terms in terms"
  (fix #'ski-step terms))

(defun sanitize (str)
  (let ((terms "SKI()"))
    (string-upcase str)))

(defun ski-treeify (xs acc)
  "Parse a list of characters (terms) into a tree
The result is a cons of the resulting tree and the unparsed terms"
  (cond ((null acc)
         (ski-treeify (cdr xs) (car xs)))
        ((null xs)
         (cons acc ()))
        ((eq (car xs) #\()
         (let ((res (ski-treeify (cdr xs) ())))
           (ski-treeify (cdr res)
                       (cons acc (car res)))))
        ((eq (car xs) #\))
         (cons acc (cdr xs)))
        (t
         (ski-treeify (cdr xs) (cons acc (car xs))))))

(defun descent-map (f xs)
  (cond
    ((null xs)
     ())
    ((atom xs)
     (funcall f xs))
    (t
     (cons (descent-map f (car xs)) (descent-map f (cdr xs))))))

(defun ski-parser (str)
  (descent-map (lambda (x) (intern (string x)))
               (ski-treeify (coerce (sanitize str) 'list) ())))

(defun ski-repl ()
  (loop (format t "~A~%" (ski-eval (car (ski-parser
                                         (progn (format t "> ")
                                                (finish-output)
                                                (read-line))))))))
