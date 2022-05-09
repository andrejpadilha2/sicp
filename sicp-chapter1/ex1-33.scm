(define (filtered-accumulate-iter filter combiner null-value term a next b)
	(define (iter a result)
		(if (> a b) 
			result
			(if (filter a)
				(iter (next a) (combiner (term a) result))
				(iter (next a) result)
			)
		)
	)
	(iter a null-value)
)


(define (filtered-accumulate filter combiner null-value term a next b)
	(if (> a b)
		null-value
		(if (filter a)
			(combiner (term a) (filtered-accumulate filter combiner null-value term (next a) next b))
			(combiner null-value (filtered-accumulate filter combiner null-value term (next a) next b))
		)
	)
)




;; now we write sum and product as calls to accumulate that are greater than five up to b
(define (identity x) x)
(define (inc x) (+ x 1))

(define (greater-than-five x) (> x 5))

(define (sum term a next b) (filtered-accumulate-iter greater-than-five + 0 term a next b))
(define (product term a next b) (filtered-accumulate greater-than-five * 1 term a next b))


