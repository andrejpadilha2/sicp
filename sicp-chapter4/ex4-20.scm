;;copied from https://wizardbook.wordpress.com/2011/01/04/exercise-4-20/

;; a) 
(define (eval-letrec exp env)
  (eval# (letrec->combination exp) env))
 
(define letrec-declarations cadr)
(define letrec-variable     car)
(define letrec-value        cadr)
(define letrec-body         cddr)
(define (letrec-initials exp) (map cadr exp))
 
(define (letrec->combination exp)
  (let* ((declarations (letrec-declarations exp))
         (initials     (letrec-initials declarations)))
    (if (null? declarations)
        exp
        (make-let-seq
         (letrec-unassigned-definitions declarations)
         (letrec-unassigned-initialisations declarations)
         (letrec-body exp)))))
 
(define (letrec-unassigned-definitions define-list)
  (map (lambda (def)
         (list (letrec-variable def)
               '(quote *unassigned*)))
       define-list))
 
(define (letrec-unassigned-initialisations declarations)
  (map (lambda (dec)
         (list 'set!
               (letrec-variable dec)
               (letrec-value dec)))
       declarations))
       
;; b)
       
;; if we use the normal let, it will not work
;; a let is transformed to a lambda with the let-binding values used as arguments to the lambda expression
;; the arguments will be defined in a diffrent environment that the outter lambda is
;; if use let like this, when the lambda procedure is executed with those arguments, the arguments will not be able to be evaluated, since they can be mutual recursive, it can eventually find an unbound variable

;; using only let, the example in the book would become
(define (f x)
  ((lambda (new-even? new-odd?) 
    "rest of body of f"
     (display (new-even? x)))    
   (lambda (n)
     (if (= n 0)
         true
         (new-odd? (- n 1))))
   (lambda (n)
     (if (= n 0)
         false
         (new-even? (- n 1))))))
         
;; when using letrec Even? and odd? procs reference E2 because the are created when evaluating
;; set! within the body of the lambda.  This means they can lookup the even?
;; and odd? variables defined in this frame.

;; when using only let
;; Even? and odd? procs reference E1 because they are evaluated in the body of
;; f but outside the 'let lambda' because they are passed as arguments to that
;; lambda.  This means they can't lookup the even? and odd? variables defined
;; in E2.

;;there's a beautiful diagram explaining in: http://community.schemewiki.org/?sicp-ex-4.20
