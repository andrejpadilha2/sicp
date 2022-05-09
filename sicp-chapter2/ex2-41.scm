(define nil '())

(define (filter predicate sequence)
	(cond ((null? sequence) nil)
		((predicate (car sequence))
			(cons (car sequence)
				(filter predicate (cdr sequence))
			)
		)
		(else (filter predicate (cdr sequence)))
	)
)

(define (enumerate-interval low high)
	(if (> low high)
		nil
		(cons low (enumerate-interval (+ low 1) high))
	)
)

(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence))
		)
	)
)

(define (flatmap proc seq)
	(accumulate append nil (map proc seq))
)


;;this is what I change from ex. 40
(define (make-triple-sum triple)
	(list (car triple) (cadr triple) (caddr triple) (+ (car triple) (cadr triple) (caddr triple)))
)

(define (unique-triples n)
	(flatmap 
		(lambda (i) 
			(flatmap (lambda (j)
				(map (lambda (k) (list i j k)) (enumerate-interval 1 (- j 1))))
				(enumerate-interval 1 (- i 1))
			)
		)
		(enumerate-interval 1 n)
	)
)

(define (triple-sum-to-s? s)
	(lambda (triple) (= s (+ (car triple) (cadr triple) (caddr triple))))
)

(define (triples-sum-to-s n s)
	(map make-triple-sum
		(filter (triple-sum-to-s? s)
			(unique-triples n)
		)
	)
)
