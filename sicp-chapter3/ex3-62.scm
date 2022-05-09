;;from exercise 3.61
(define (invert-unit-series series)
	(let ((sr (stream-cdr series)))
		(cons-stream 1 
			(scale-stream 
				(mul-series sr (invert-unit-series series)) 
				-1))))


;;from exercise 3.60
(define (mul-series s1 s2)
	(cons-stream (* (stream-car s1) 
			 (stream-car s2)) 
		     (add-streams (scale-stream (stream-cdr s2) 
		     				 (stream-car s1))
		     		  (mul-series (stream-cdr s1) s2))))
	
	
	
	
;; from exercise 3.59
(define ones (cons-stream 1 ones))

(define integers (cons-stream 1 (add-streams ones integers)))

(define (scale-stream stream factor)
	(stream-map (lambda (x) (* x factor)) stream))

(define (add-streams s1 s2)
	(stream-map + s1 s2))

(define (mul-streams s1 s2)
	(stream-map * s1 s2))
	
(define (div-streams s1 s2)
	(stream-map / s1 s2))

(define (integrate-series series)
	(div-streams series integers))
	
(define cosine-series
	(cons-stream 1 (scale-stream (integrate-series sine-series) -1)))
	
(define sine-series
	(cons-stream 0 (integrate-series cosine-series)))
	
	
;;to check	
(define cos-square+sin-square
  (add-streams (mul-series cosine-series 
                           cosine-series)
               (mul-series sine-series 
                           sine-series)))
                           
(define (display-stream-until n s)     ; n-th value included 
     (if (< n 0) 
         the-empty-stream 
         (begin (newline) (display (stream-car s)) 
                (display-stream-until (- n 1) (stream-cdr s)))))
                
;;ex 3.62            
(define (div-series s1 s2)
	(mul-series s1 (invert-unit-series s2)))
	
(define tangent-series (div-series sine-series cosine-series))
