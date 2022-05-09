(define s (cons-stream 1 (add-streams s s)))

(define (add-streams s1 s2)
	(stream-map + s1 s2))


;; it's a stream beginning with 1 and whose cdr is the promise of summing the car-stream of the stream with itself
;; the second element will then be 2
;; the third element will be 4
