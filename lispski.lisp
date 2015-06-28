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
  (cond ((atom xs)
         xs)
        (t
         (let* ((x (ski-eval (car xs)))
                (f (or (and (functionp x) x) (cdr (assoc x scope))))
                (y (ski-eval (cdr xs))))
           (if (null f)
               (cons x y)
               (funcall f y))))))

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
    (remove-if-not
     (lambda (x) (some (lambda (y) (eq x y)) terms))
     (string-upcase str))))
