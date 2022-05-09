(define (timed-prime-test n)
	(start-prime-test n (runtime))
)

(define (start-prime-test n start-time)
	(if (fast-prime? n 100) 
		(report-prime n (- (runtime) start-time)) 
		#f
	)
)

(define (square x) (* x x))

(define (report-prime n elapsed-time)
	(display n)
	(display " *** ")
	(display elapsed-time)
	(newline)
)

(define (miller-rabin-expmod base exp m)
	(define (squaremod-with-check x)
		(define (check-nontrivial-sqrt1 x square)
			(if (and (= square 1)
				(not (= x 1))
				(not (= x (- m 1))))
			0
			square))
		(check-nontrivial-sqrt1 x (remainder (square x) m))
	)
	(cond ((= exp 0) 1)
		((even? exp)
			(remainder (square (miller-rabin-expmod base (/ exp 2) m)) m))
		(else (remainder (* base (miller-rabin-expmod base (- exp 1) m)) m))
	)
)

(define (miller-rabin-test n)
	(define (try-it a)
		(define (check-it x)
			(and (not (= x 0)) (= x 1)))
		(check-it (miller-rabin-expmod a (- n 1) n)))
	(try-it (+ 1 (random (- n 1))))
)
	
(define (fast-prime? n times)
	(cond ((= times 0) true)
		((miller-rabin-test n) (fast-prime? n (- times 1)))
		(else #f)
	)
)


(define (search-for-primes lower-limit counter)
	
	(define (iter lower-limit counter)
		(if (> counter 0)
			(if (timed-prime-test lower-limit)
				(iter (+ lower-limit 2) (- counter 1))
				(iter (+ lower-limit 2) counter)
			)
			(display " end")
		)
	)
	(if (even? lower-limit) 
		(iter (+ lower-limit 1) counter) 
		(iter (+ lower-limit 1) counter)
	)
)