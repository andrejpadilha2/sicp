(define (pairs s t)
	(cons-stream
		(list (stream-car s) (stream-car t))
		(interleave
			(stream-map (lambda (x) (list (stream-car s) x))
				(stream-cdr t))
			(pairs (stream-cdr s) (stream-cdr t)))))
			
(define (interleave s1 s2)
	(if (stream-null? s1)
		s2
		(cons-stream  stream-car s1)
			(interleave s2 (stream-cdr s1))))
			
(define (pairs-alt2 s t)
	(interleave
		(stream-map (lambda (x) (list (stream-car s) x))
			t)
		(pairs-alt2 (stream-cdr s) (stream-cdr t))))
		
;;pairs-alt2 will never return the first evaluation of 'interleave' because the second argument of it, pairs-alt2, is recursively calling itself
