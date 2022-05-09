(load "get-put.scm")
(load "ex4-3.scm")

;; let

;; ((let? exp) (analyze-let exp)) -> add this in "analyze"
(define (analyze-let exp)
	(analyze (let->combination exp)))
	
(define (let->combination exp)
	(cons (make-lambda (let-variables-list exp) (let-body exp)) (let-expressions-list exp)))

(define (let-variables-list associations)
	(define (let-var-loop associations)
		(if (last-exp? associations)
			(let-variable associations)
			(cons (let-variable associations) (let-var-loop (rest-associations associations)))))
	(let-var-loop (let-associations exp)))))

(define (let-associations exp) (cadr exp))
(define (rest-associations associations) (cdr associations))

(define (let-variable associations) (car associations))

	
(define (let-expressions-list associations)
	(define (let-exp-loop associations)
		(if (last-exp? associations)
			(let-expression associations)
			(cons (let-expression associations) (let-exp-loop (rest-associations associations)))))
	(let-exp-loop (let-associations exp))))

(define (let-expression associations) (cadar associations))

(define (let-body exp) (cddr exp))
	
(define (let? exp) (tagged-list? exp 'let))
