(load "get-put.scm")
(load "ex4-3.scm")

;;answer copied from "https://wizardbook.wordpress.com/2010/12/26/exercise-4-8/"

; Let statements
(define (named-let? exp) 
  (and (tagged-list? exp 'let)
       (symbol? (cadr exp))))
 
; Let selectors
(define (let-initials exp) (map cadr (cadr exp)))
(define (let-parameters exp) (map car (cadr exp)))
(define named-let-identifier car)
(define let-body cddr)
 
; A named let is equivalent to a procedure definition 
; followed by a single application of that procedure with the 
; initial values given by the let expression.
;
; exp should be the initial let expression stripped of the 'let symbol
;   this allows the same selection procedures to be used without altering them.
(define (named-let->combination exp)
  (let ((procedure-name (named-let-identifier exp)))
    ; 2 expressions are needed so wrap them in a begin form
    (make-begin 
     (list
      ; define the procedure with the name given in the let expression
      (list 'define procedure-name 
            (make-lambda 
             (let-parameters exp) 
             (let-body exp)))
      ; apply the procedure with the initial values given by the let expression
      (cons procedure-name (let-initials exp))))))
 
; a let is syntactic sugar for
;   ((lambda (params) (body)) values)
(define (let->combination exp)
  (if (named-let? exp)
      (named-let->combination (cdr exp))
      (cons (make-lambda (let-parameters exp) 
                         (let-body exp))
            (let-initials exp))))
            
            
            
            
;;I read that using "define" in the "named-let->combination" procedure can give nameclash issues...I don't understand it yet

