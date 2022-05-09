(define ones (cons-stream 1 ones))

(define integers (cons-stream 1 (add-streams ones integers)))

(define (add-streams s1 s2)
	(stream-map + s1 s2))

(define (partial-sums stream)
	(add-streams stream (cons-stream 0 (partial-sums stream))))
	
(define s (partial-sums integers))

(define (mul-streams s1 s2)
	(stream-map * s1 s2))


;; it's a stream beginning with 1 and whose cdr is the promise of summing the car-stream of the stream with itself
;; the second element will then be 2
;; the third element will be 4
