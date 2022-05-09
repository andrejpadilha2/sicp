;; (define (text-of-quotation exp) (cadr exp)) -> original version

;; now with this version of the lazy evaluator
;; quoted lists need to be converted into the equivalent cons forms e.g. '(a b c) becomes (cons 'a (cons 'b (cons 'c '())))

(define (text-of-quotation exp)
	(let ((result (cadr exp)))
		(if (pair? result)	;; we check to see if it's a list or any other quoted expression
			(eval (make-list result) env) ;; if it's a list, we need to transform '(a b c) into (cons 'a (cons 'b (cons 'c '()))) and then evaluate that
			result))) ;; if it's not, we just return the quoted expression
	
(define (make-list xs)
	(if (null? xs)
		'()
		(list 'cons (list 'quote (car xs)) (make-list (cdr xs)))))
