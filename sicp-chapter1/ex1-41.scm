(define (double original-procedure)
	(lambda (x) (original-procedure (original-procedure x)))
)

(define (inc x) (+ x 1))
