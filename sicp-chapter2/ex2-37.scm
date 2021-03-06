(define nil '())

(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence))
		)
	)
)

(define (accumulate-n op init seqs)
	(if (null? (car seqs))
		nil
		(cons (accumulate op init (map car seqs))
			(accumulate-n op init (map cdr seqs))
		)
	)
)


(define (dot-product v w)
	(accumulate + 0 (map * v w))
)

(define (matrix-*-vector m v)
	(map (lambda (x) (dot-product x v)) m)
)

(define (transpose mat)
	(accumulate-n cons '() mat)
)

(define (matrix-*-matrix m n)
	(let ((cols (transpose n)))
		(map (lambda (x) (matrix-*-vector cols x)) m)
	)
)


(define v1 (list 1 2 3))
(define v2 (list 4 5 6))
(define v3 (list 7 8 9))

(define m1 (list v1 v2 v3))
(define m2 (list v1 v2 v3))
