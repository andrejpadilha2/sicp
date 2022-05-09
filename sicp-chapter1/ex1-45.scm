(define (average-damp f)
	(lambda (x) (average x (f x)))
)
	
(define (average x y)
	(/ (+ x y) 2)
)

(define tolerance 0.00001)

(define (fixed-point f first-guess)
	(define (close-enough? v1 v2)
		(< (abs (- v1 v2)) tolerance)
	)
	(define (try guess)
		(let ((next (f guess)))
			(if (close-enough? guess next)
				next
				(try next)
			)
		)
	)
	(try first-guess)
)

(define (fixed-point-of-transform g transform guess)
	(fixed-point (transform g) guess)
)

(define (compose f g)
	(lambda (x) (f (g x)))
)

(define (repeated f n)
	(if (= n 1) f (compose f (repeated f (- n 1))))
)

(define (sq-root x)
	(fixed-point-of-transform (lambda (y) (/ x y)) average-damp 1.0))
	
(define (cube-root x)
	(fixed-point-of-transform (lambda (y) (/ x (square y))) average-damp 1.0))

(define (4th-root x) (fixed-point-of-transform (lambda (y) (/ x (cube y))) (repeated average-damp 2) 1.0))

(define (5th-root x) (fixed-point-of-transform (lambda (y) (/ x (expt y 4))) (repeated average-damp 2) 1.0))

(define (8th-root x) (fixed-point-of-transform (lambda (y) (/ x (expt y 7))) (repeated average-damp 3) 1.0))

(define (16th-root x) (fixed-point-of-transform (lambda (y) (/ x (expt y 15))) (repeated average-damp 4) 1.0))

(define (log2 n) (/ (log n) (log 2)))
(define (nth-root x n) (fixed-point-of-transform (lambda (y) (/ x (expt y (- n 1)))) (repeated average-damp (floor (log2 n))) 1.0))
