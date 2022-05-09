(load "get-put.scm")
(load "ex4-3.scm")

;; let*
(define (eval-let* exp env)
	(eval (let*->nested-lets exp) env))
	
(define (let*->nested-lets exp)
	(define (let*-loop associations)
		(if (last-exp? associations)
			(make-let (list (let*-association associations)) (let*-last-body exp))
			(cons (make-let (list (let*-association associations)) (let*-loop (rest-associations associations))))
	(let*-loop (let*-extract-associations exp)))
			
(define (let*-extract-associations exp) (cadr exp))			
(define (let*-association associations) (car associations))
(define (rest-associations associations) (cdr associations))
(define (let*-last-body exp) (cddr exp))
	
(define (make-let associations body)
	(cons 'let (cons associations body)))
	
;; it's sufficient to just add a clause to eval whose action is (eval (let*->nested-lets exp) env)
(put 'eval 'let* eval-let*)
