(define (deep-reverse li)
	(cond ((null? li) '())
		((not (pair? li)) li)
		(else (append (deep-reverse (cdr li))
			(list (deep-reverse (car li)))
			)
		)
	)
)

(define list1 (list (list 1 2) (list 3 4)))

(define list2 (list (list 1 2) 3))

(define list3 (list 1 (list 2 3)))
