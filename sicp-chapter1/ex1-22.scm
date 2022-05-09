(define (timed-prime-test n)
	(start-prime-test n (runtime))
)

(define (start-prime-test n start-time)
	(if (prime? n)
	(report-prime n (- (runtime) start-time)) #f)
)

(define (report-prime n elapsed-time)
	(display n)
	(display " *** ")
	(display elapsed-time)
	(newline)
)

(define (smallest-divisor n)
	(find-divisor n 2)
)

(define (find-divisor n test-divisor)
	(cond ((> (square test-divisor) n) n)
		((divides? test-divisor n) test-divisor)
		(else (find-divisor n (+ test-divisor 1))))
)

(define (divides? a b)
	(= (remainder b a) 0)
)

(define (prime? n)
	(= n (smallest-divisor n))
)




(define (search-for-primes lower-limit counter)
	
	(define (iter lower-limit counter)
		(if (> counter 0)
			(if (timed-prime-test lower-limit)
				(iter (+ lower-limit 2) (- counter 1))
				(iter (+ lower-limit 2) counter)
			)
		)
	)
	(if (even? lower-limit) 
		(iter (+ lower-limit 1) counter) 
		(iter (+ lower-limit 1))
	)
)