(define (reverse li)
	(if (null? (cdr li))
		li
		(append (reverse (cdr li)) (list (car li))))
)

(define list1 (list 23 72 149 34))
