;; from exercise 3.59
(define ones (cons-stream 1 ones))

(define integers (cons-stream 1 (add-streams ones integers)))

(define (add-streams s1 s2)
	(stream-map + s1 s2))

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

							
(define (sum-triple list-pair)
	(+ (triple (car list-pair)) (triple (cadr list-pair))))

(define (triple x) (* x x x))

(define ordered-int-pairs (weighted-pairs integers integers sum-triple))

		
(define (Ramanujan s) 
          (define (stream-cadr s) (stream-car (stream-cdr s))) 
          (define (stream-cddr s) (stream-cdr (stream-cdr s))) 
          (let ((scar (stream-car s)) 
                    (scadr (stream-cadr s))) 
                 (if (= (sum-triple scar) (sum-triple scadr))  
                         (cons-stream (list (sum-triple scar) scar scadr) 
                                                  (Ramanujan (stream-cddr s))) 
                         (Ramanujan (stream-cdr s))))) 
		
(define Ramanujan-numbers
	(Ramanujan ordered-int-pairs))
