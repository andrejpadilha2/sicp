(define (fast-expt b n)
	(cond ((= n 0) 1)
	((even? n) (square (fast-expt b (/ n 2))))
	(else (* b (fast-expt b (- n 1)))))
)

(define (even? n)
	(= (remainder n 2) 0)
)

;;(fast-expt 2 5)
;;1- (* 2 (fast expt 2 4))
;;2- (* 2 (square (fast-expt 2 2)))
;;3- (* 2 (square (square (fast-expt 2 1))))
;;4- (* 2 (square (square (* 2 (fast-expt 2 0)))))
;;5- (* 2 (square (square (* 2 1))))
;;6- (* 2 (square (square 2)))
;;7- (* 2 (square 4))





(define (fast-expt-iter b n)
	(define (iter a b n)
		(cond ((= n 0) a)
		((even? n) (iter a (square b) (/ n 2)))
		(else (iter (* a b) b (- n 1))))
	)
	(iter 1 b n)
)
