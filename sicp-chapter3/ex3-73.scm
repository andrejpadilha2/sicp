;; from exercise 3.62
(define ones (cons-stream 1 ones))

(define integers (cons-stream 1 (add-streams ones integers)))

(define (add-streams s1 s2)
	(stream-map + s1 s2))
	
(define (scale-stream stream factor)
	(stream-map (lambda (x) (* x factor)) stream))
	
(define (integral integrand initial-value dt)
	(define int
	(cons-stream initial-value
		(add-streams (scale-stream integrand dt)
			int)))
	int)
	
(define (RC R C dt)
	(lambda (i v0)
		(add-streams 
			(integral (scale-stream i (/ 1 C)) v0 dt)
			(scale-stream i R))))
