;; a) the evaluator will think that "define" is a procedure application instead of a special form, so when it evaluates "(eval (operator exp) env)", the "operator exp" returns "define", so it will effectively try to evaluate "(eval 'define env)", which is a symbol not defined and will return "unbound variable" for 'define

(define (application? exp)
	(tagged-list? exp 'call))
	
(define (operator exp) (cadr exp))

(define (operands exp) (cddr exp))
