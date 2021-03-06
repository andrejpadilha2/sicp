(define (make-monitored f)
	(let ((counter 0))
		(define (dispatch m)
			(cond ((eq? m 'how-many-calls?) counter)
				((eq? m 'reset-count) (begin (set! counter 0) counter))
				(else (begin (set! counter (+ counter 1)) (f m)))
			)
		)
	dispatch
	)
)
