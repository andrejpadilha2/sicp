(define (cube x) (* x x x))

(define (sum term a next b)
	(if (> a b)
		0
		(+ (term a)
		(sum term (next a) next b))
	)
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
