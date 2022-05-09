(define nil '())

(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence))
		)
	)
)

(define (fold-left op initial sequence)
	(define (iter result rest)
		(if (null? rest)
			result
			(iter (op result (car rest))
				(cdr rest)
			)
		)
	)
	(iter initial sequence)
)

;;fold-right is the same as accumulate

(define (reverse1 sequence)
	(fold-right (lambda (x y) (append y (list x))) nil sequence)
)

(define (reverse2 sequence)
	(fold-left (lambda (x y) (append (list y) x)) nil sequence)
)
