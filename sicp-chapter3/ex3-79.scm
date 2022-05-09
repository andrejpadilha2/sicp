(define (integral delayed-integrand initial-value dt)
	(cons-stream initial-value
		(let ((integrand (force delayed-integrand)))
		(if (stream-null? integrand)
			the-empty-stream
			(integral (stream-cdr integrand)
				(+ (* dt (stream-car integrand))
					initial-value)
				dt)))))
				
(define (general-solve-2nd f dy0 y0 dt)
	(define y (integral (delay dy) y0 dt))
	(define dy (integral (delay ddy) dy0 dt))
	(define ddy (stream-map f dy y))
	y)
