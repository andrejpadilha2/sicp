;; from exercise 3.59
(define ones (cons-stream 1 ones))

(define integers (cons-stream 1 (add-streams ones integers)))

(define (add-streams s1 s2)
	(stream-map + s1 s2))
	
	
;;from exercise 3.70
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
		
;; this exercise		
(define (sum-square list-pair)
	(+ (square (car list-pair)) (square (cadr list-pair))))

(define ordered-int-pairs (weighted-pairs integers integers sum-square))
	
(define (sum-square-forms s) 
          (define (stream-cadr s) (stream-car (stream-cdr s)))
          (define (stream-caddr s) (stream-car (stream-cdr (stream-cdr s))))
          (define (stream-cddr s) (stream-cdr (stream-cdr s)))
          (define (stream-cdddr s) (stream-cdr (stream-cdr (stream-cdr s))))
          (let ((scar (stream-car s)) 
                (scadr (stream-cadr s))
                (scaddr (stream-caddr s)))
                 (if (and (= (sum-square scar) (sum-square scadr)) (= (sum-square scar) (sum-square scaddr)) )
                         (cons-stream (list (sum-square scar) scar scadr scaddr) 
                                                  (sum-square-forms (stream-cdddr s))) 
                         (sum-square-forms (stream-cdr s))))) 
		
(define sum-square-forms-numbers
	(sum-square-forms ordered-int-pairs))
