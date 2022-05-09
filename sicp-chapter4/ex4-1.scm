;; list-of-values that evaluates from left to right, necessarily
;; force the evaluation with NESTED lets....nested lets are just let*

(define (list-of-values exps env)
	(if (no-operands? exps)
		'()
		(let*   ((left (eval (first-operand exps) env))
			(right (list-of-values (rest-operands exps) env)))
			(cons left right)))))
			
;; list-of-values that evaluates from right to left, necessarily
;; force the evaluation with NESTED lets....nested lets are just let*
(define (list-of-values exps env)
	(if (no-operands? exps)
		'()
		(let*   ((right (list-of-values (rest-operands exps) env))
			(left (eval (first-operand exps) env)))
			(cons left right))))
