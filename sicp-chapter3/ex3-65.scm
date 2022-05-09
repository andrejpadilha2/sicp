(define (ln2-summands n)
	(cons-stream (/ 1.0 n)
		(stream-map - (ln2-summands (+ n 1)))))
		
(define pi-stream
	(partial-sums (ln2-summands 1)))
	
(define (partial-sums stream)
	(add-streams stream (cons-stream 0 (partial-sums stream))))
	
	
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
