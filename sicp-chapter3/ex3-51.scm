(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

(define (stream-enumerate-interval low high)
	(if (> low high)
	the-empty-stream
		(cons-stream
		low
		(stream-enumerate-interval (+ low 1) high))))

(define (display-line x)
	(newline)
	(display x))

(define (show x)
	(display-line x)
	x)

(define z (stream-enumerate-interval 0 10))
(define x (stream-map show (stream-enumerate-interval 0 10))) ; -> it will create a bouding to a variable x
;; then it will create a stream, enumerating the integers from 0 to 10
;; it will stream-map the procedure "show" in the stream created
;; so the result will be a new stream, "x", in which each "stream-car" is "(show x)" and each "stream-cdr" is the promise to "show" the next stream

;;stream-ref returns the stream-car of a stream as the final result
;;(stream-ref x 5) ;; stream-ref will navigate the stream, forcing the promises until it reaches the desired position
;; at each evaluation, it will "(display-line x)", and return the value of x...since stream-map was applied, x is the "stream-car" of the stream

;;(stream-ref x 7) ;; since delay is memoized, it will store the results, that is, 1 (from the first evaluation in stream-ref), 2 (from the second evaluation in stream-ref), and so on until 5 (from the fifth evaluation of stream-ref), and it will keep going from there, evaluating (display-line 6) and (display-line 7) before finally returning "7" as the result
