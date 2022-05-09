(define (integral delayed-integrand initial-value dt)
	(cons-stream initial-value
		(let ((integrad (force delayed-integrand)))
		(if (stream-null? integrand)
			the-empty-stream
			(integral (stream-cdr integrand)
				(+ (* dt (stream-car integrand))
					initial-value)
				dt)))))
				
(define (solve-2nd a b dy0 y0 dt)
	(define y (integral (delay dy) y0 dt))
	(define dy (integral (delay ddy) dy0 dt))
	(define ddy (stream-add
		(scale-stream dy a)
		(scale-stream y b)))
	y)
	
