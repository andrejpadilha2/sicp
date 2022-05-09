(define (identity x) x)


(define (product-iter term a next b)
	(define (iter a result)
		(if (> a b)
			result
			(iter (next a) (* result a))))
	(iter a 1)
)

(define (inc x) (+ x 1))

(define (factorial n)
	(product identity 1 inc n)
)



(define (wallis-product n)
	(define (term n)
		(* (/ (* 2 n)
			(- (* 2 n) 1))
		   (/ (* 2 n)
		   	(+ (* 2 n) 1))))
	(product term 1.0 inc n)
)


(define (product term a next b)
	(if (> a b) 1
		(* (term a) (product term (next a) next b))
	)
)

(define (pi-approx n)
	(* 2 (wallis-product n)))
