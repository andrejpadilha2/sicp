(define (cube-iter guess last-guess x)
	(if (good-enough? guess last-guess x)
		guess
		(cube-iter (improve guess x) guess
			x)))
			
(define (improve guess x)
	(three-average (/ x (* guess guess)) (* 2 guess)))
	
(define (three-average x y)
	(/ (+ x y) 3))
	
(define (good-enough? guess last-guess x)
	( < (abs (- guess last-guess)) (/ guess 100000)))
	
(define (cubert x)
	(cube-iter 1.0 0.1 x))
