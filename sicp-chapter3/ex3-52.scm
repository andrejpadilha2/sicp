(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

(define (stream-enumerate-interval low high)
	(if (> low high)
	the-empty-stream
		(cons-stream
		low
		(stream-enumerate-interval (+ low 1) high))))
		
(define (stream-filter pred stream)
	(cond ((stream-null? stream) the-empty-stream)
		((pred (stream-car stream))
			(cons-stream (stream-car stream)
					(stream-filter pred
						(stream-cdr stream))))
			(else (stream-filter pred (stream-cdr stream)))))

(define (stream-for-each proc s)
	(if (stream-null? s)
		'done
		(begin (proc (stream-car s))
			(stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
	(stream-for-each display-line s))

(define (display-line x)
	(newline)
	(display x))

(define (show x)
	(display-line x)
	x)

(define sum 0)

(define (accum x)
	(set! sum (+ x sum))
	sum)
	
(define seq (stream-map accum (stream-enumerate-interval 1 20))) ;; creates a stream with all integers from 1 to 20, then stream-map "accum" to this stream

(define y (stream-filter even? seq))

(define z (stream-filter (lambda (x) (= (remainder x 5) 0 ))
		seq))
		
;;(stream-ref y 7) ;; this will first return 1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 66, 78, 91, 105, 120, 136 from the execution of "(accum x)" (but not print in the screen), but will return in the end, and y will be the stream {6 10 28 36 66 78 120 136 ... }, so (stream-ref y 7) will just return 136

;;(display-stream z) ;; z will be the stream {10 15 45 55 105 120 ... }
;; display-stream will apply the procedure "display-line" for each "stream-car" of "z" and keep doing until all values of (stream-enumerate-interval 1 20) are calculated
