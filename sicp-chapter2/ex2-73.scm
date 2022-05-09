;;we can't assimilate the predicates "number?" and "same-variable?" into the data-directed dispatch because they are the minimum case, and the expression "(operator exp)" which is simply "(car exp)" would give an error, since they are not pairs to have a car or cdr
(define (install-deriv-package)
	;;sum constructors and selectors
	(define (make-sum a1 a2)
		(cond ((=number? a1 0) a2)
			((=number? a2 0) a1)
			((and (number? a1) (number? a2)) (+ a1 a2))
			(else (list '+ a1 a2))
		)
	)
	(define (addend s) (cadr s))
	(define (augend s) (caddr s))
	
	;;product constructors and selectors
	(define (make-product m1 m2)
		(cond ((or (=number? m1 0) (=number? m2 0)) 0)
			((=number? m1 1) m2)
			((=number? m2 1) m1)
			((and (number? m1) (number? m2)) (* m1 m2))
			(else (list '* m1 m2))
		)
	)
	(define (multiplier p) (cadr p))
	(define (multiplicand p) (caddr p))
	
	;;exponentiation constructors and selectors
	(define (make-exponentiation base exponent)
		(cond ((=number? exponent 0) 1)
			((=number? exponent 1) base)
			(else (list '** base exponent))
		)
	)
	(define (base expo) (cadr expo))
	(define (exponent expo) (caddr expo))
	
	
	(define (deriv-sum exp-oper var) (make-sum (deriv (addend exp-oper) var) (deriv (augend exp) var)))
	(define (deriv-prod exp-oper var) (make-sum (make-product (multiplier exp-oper) (deriv (multiplicand exp) var)) (make-product (deriv (multiplier exp) var) (multiplicand exp))))
	(define (deriv-exp exp-oper var) (make-product (exponent exp-oper) (make-product (make-exponentiation (base exp-oper) (- (exponent exp-oper) 1)) (deriv (base exp-oper) var))))

	(put 'deriv '+ deriv-sum)
	(put 'deriv '* deriv-prod)
	(put 'deriv '** deriv-exp)
	'done
)

(define (deriv exp var)
	(cond ((number? exp) 0)
		((variable? exp) (if (same-variable? exp var) 1 0))
		(else ((get 'deriv (operator exp)) (operands exp) var))
	)
)

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (variable? x) 
	(symbol? x)
)

(define (same-variable? v1 v2)
	(and (variable? v1) (variable? v2) (eq? v1 v2))
)


;;for item d, we would simply change the order of 'deriv and operator in the put procedure
