(define (same-parity a . li)
	(define (same-parity-function a li)
		(let ((yes? (if (even? a)
			even?
			odd?
		)))
		(if (null? li)
			li
			(if (yes? (car li))
				(cons (car li) (same-parity-function a (cdr li)))
				(same-parity-function a (cdr li))
			)
		)
		)
	)
	(same-parity-function a li)
)
