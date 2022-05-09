(define nil '())

(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence))
		)
	)
)

(define (accumulate-n op initi seqs)
	(if (null? (car seqs))
		nil
		(cons (accumulate op init (map car seqs))
			(accumulate-n op init (map cdr sequence))
		)
	)
)



(define x (cons (list 1 2) (list 3 4)))
