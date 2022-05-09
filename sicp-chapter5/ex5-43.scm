;; Procedures from exercise ex4-16.scm
(define (scan-out-defines body)
  (let ((defined-vars (definitions body)))
    (if (null? defined-vars)  
        body
        (list 
         (make-let-seq  
          (unassigned-definitions defined-vars)
          (unassigned-initialisations defined-vars)
          (scanned-body body))))))
 
(define (definitions exp)
  (define (scan-iter body definitions-complete)
    (cond ((null? body) null)
          ((definition? (car body))
           (if definitions-complete
               (error "Define cannot appear in an expression context - DEFINITIONS" exp)
               (cons (car body) 
                     (scan-iter (cdr body) #f))))
          (else (scan-iter (cdr body) #t))))
  (scan-iter exp #f))
 
(define (make-let-seq unassigned-vars initial-values body)
  (append (list 'let unassigned-vars)
          initial-values 
          body))
 
(define (unassigned-definitions define-list)
  (map (lambda (def)  
         (list (definition-variable def) 
               '(quote *unassigned*)))
       define-list))
 
(define (unassigned-initialisations define-list)
  (map (lambda (def)  
         (list 'set! (definition-variable def) 
               (definition-value def)))
       define-list))
 
(define (scanned-body body)
  (cond ((null? body) body)
        ((definition? (car body)) (scanned-body (cdr body))) 
        (else (cons (car body) 
                    (scanned-body (cdr body))))))
                    
                    


;; to do this transformation, I would change the following on the compiler from ex5-42.scm
;;(compile-sequence (lambda-body exp) 'val 'return (cons formals cte))
;; to
;;(compile-sequence (scan-out-defines (lambda-body exp)) 'val 'return (cons formals cte))


		
		
		
		
		
		
		
		
		
		
		
		
		
		
