(define (cont-frac n d k)
	(define (frac-rec i)
		(if (> i k) 0 (/ (n i) (+ (d i) (frac-rec (+ i 1)))))
	)
	(frac-rec 1)
)



(define (cont-frac-iter n d k)
	(define (iter result k)
		(cond ((> k 0) (iter (/ (n k) (+ (d k) result)) (- k 1)))
			(else result)
		)
	)
	(iter 0 k)
)

(define (ni x) (lambda (i)
		(if (= i 1) x (- (square x)))
	)
)

(define di 
	(lambda (i) (+ 1 (* (- i 1) 2)))
)

(define (tan-cf x k)
	(cont-frac (ni x) di k)
)
