(define (fast-mult-iter a b)
	(define (iter j a b)
		(cond ((= b 0) j)
		((even? b) (iter j (double a) (halve b)))
		(else (iter (+ j a) a (- b 1))))
	)
	(iter 0 a b)
)



(define (double x) (+ x x))

(define (halve x) (/ x 2))

(define (even? n)
	(= (remainder n 2) 0)
)
