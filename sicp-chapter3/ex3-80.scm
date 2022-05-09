(define (RLC R L C dt)
	(lambda (vc0 il0)
		(define vc (integral (delay dvc) vc0 dt))
		(define dvc (scale-stream il (- (/ 1 C))))
		(define il (integral (delay dil) il0 dt))
		(define dil (add-stream
			(scale-stream vc (/ 1 L))
			(scale-stream il (- (/ R L)))))
		(cons vc il)))
			
(define (integral delayed-integrand initial-value dt)
	(cons-stream initial-value
		(let ((integrad (force delayed-integrand)))
		(if (stream-null? integrand)
			the-empty-stream
			(integral (stream-cdr integrand)
				(+ (* dt (stream-car integrand))
					initial-value)
				dt)))))
