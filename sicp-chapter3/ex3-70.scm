;; a)
(define (merge-weighted s1 s2 proc) 
   (cond ((stream-null? s1) s2) 
         ((stream-null? s2) s1) 
         (else 
          (let ((s1car (stream-car s1)) 
                (s2car (stream-car s2))) 
            (let ((w1 (proc s1car)) 
                  (w2 (proc s2car))) 
              (if (< w1 w2) 
                  (cons-stream s1car (merge-weighted (stream-cdr s1) s2 proc)) 
                  (cons-stream s2car (merge-weighted s1 (stream-cdr s2) proc)))))))) 
  
 (define (weighted-pairs s1 s2 proc) 
   (cons-stream 
    (list (stream-car s1) (stream-car s2)) 
    (merge-weighted 
     (stream-map (lambda (x) (list (stream-car s1) x)) (stream-cdr s2)) 
     (weighted-pairs (stream-cdr s1) (stream-cdr s2) proc) 
     proc))) 

							
(define (weight-pair1 list-pair)
	(+ (car list-pair) (cadr list-pair)))

;;final answer
(define ordered-int-pairs (weighted-pairs integers integers weight-pair1))

;; b)
(define (weight-pair2 list-pair)
	(+ (* 2 (car list-pair)) 
	   (* 3 (cadr list-pair)) 
	   (* (car list-pair) (cadr list-pair))))
	
(define filtered-integers
	(stream-filter (lambda (x) (compound-not-divisible? x 2 3 5)) integer))

(define (not-divisible? dividend divisor) 
   (not (= 0 (remainder dividend divisor))))
  
(define (compound-not-divisible? dividend x y z) 
   (and (not-divisible? dividend x) 
        (not-divisible? dividend y) 
        (not-divisible? dividend z)))
        
;;final answer
(define ordered-conditional-pair
	(weighted-pairs filtered-integers filtered-integers weight-pair2))
