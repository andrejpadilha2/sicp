(load "get-put.scm")
(load "ex4-3.scm")

;; answer copied from "http://community.schemewiki.org/?sicp-ex-4.9"

; (while <predicate> <body>) 
 ; for example:  
 ; (while (< i 100)  
 ;     (display i)  
 ;     (set! i (+ i 1))) 

(define (while? exp) (tagged-list? exp 'while)) 
(define (while-pred exp)(cadr exp)) 
(define (while-actions exp) (caddr exp)) 
   
(define (make-single-binding var val) (list (list var val))) 
(define (make-if-no-alt predicate consequent)(list 'if predicate consequent)) 
(define (make-combination operator operands) (cons operator operands)) 
  
(define (while->rec-func exp) 
	(list 'let (make-single-binding 'while-rec '(quote *unassigned*)) 
		(make-assignment 'while-rec 
			(make-lambda '() 
				(list (make-if-no-alt  
					(while-pred exp) 
					(make-begin (append (while-actions exp) 
						(list (make-combination 'while-rec '())))))))) 
		(make-combination 'while-rec '())))
  
            
            
;;I read that using "define" in the "named-let->combination" procedure can give nameclash issues...I don't understand it still

