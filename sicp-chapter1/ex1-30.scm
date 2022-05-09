(define (cube x) (* x x x))

(define (sum term a next b)
	(define (iter a result)
		(if (> a b)
			result
			(iter (next a) (+ result (term a)))))
	(iter a 0)
)

(define (simpsonIntegral f a b n)
	(define h (/ (- b a) n))
	
	(define (add-2h x) (+ x (* 2 h)))
	
	(* (/ h 3)  (+ 
		(f a)
		(* 4 (sum f (+ a h) add-2h (- b h)))
		(* 2 (sum f (add-2h a) add-2h (- b (* 2 h))))
		(f b)
	)
	)
)
