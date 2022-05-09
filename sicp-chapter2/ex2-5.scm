(define (cons a b) 
	(* (expt 2 a) (expt 3 b))
)

(define (count-0-remainder-divisions n p d)
	(if (= (remainder p d) 0)
		(count-0-remainder-divisions (+ n 1) (/ p d) d)
		n)
)

(define (car pair)
	(count-0-remainder-divisions 0 pair 2)
)

(define (cdr pair)
	(count-0-remainder-divisions 0 pair 3)
)
