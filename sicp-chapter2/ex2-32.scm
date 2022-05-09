(define nil '())

(define (subsets s)
	(if (null? s)
		(list nil)
		(let ((rest (subsets (cdr s))))
			(append rest (map (lambda (element) (cons (car s) element)) rest)))
	)
)

(define list1 (list 1 2 3))
