(define (make-zero-crossings input-stream)
	(let ((smoothed-values (smooth input-stream)))
		(stream-map sign-change-detector smoothed-values (cons-stream 0 smoothed-values))))
		
(define (smooth stream)
  (stream-map (lambda (x y)
                (/ (+ x y) 2)) 
              stream 
              (cons-stream 0 stream)))
              
;;my own solution below, I don't know if it works
(define (smooth2 input-stream last-value last-avg)
	(let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
		(cons-stream last-avg
			(smooth2 (stream-cdr input-stream)
				(stream-car input-stream)
				avpt))))

(define (make-zero-crossings2 input-stream)
	(let ((smoothed-values (smooth2 input-stream 0 0)))
		(stream-map sign-change-detector smoothed-values (cons-stream 0 smoothed-values))))
