;; a
(define (lookup-variable-value var env)
	(define (env-loop env)
		(define (scan vars vals)
			(cond ((null? vars)
					(env-loop (enclosing-environment env)))			
				((eq? var (car vars))
					(if (eq? (car vals) '*unassigned*)
						(error "Unassigned variable" var)
						(car vals)))
				(else (scan (cdr vars) (cdr vals)))))
		(if (eq? env the-empty-environment)
			(error "Unbound variable " var)
			(let ((frame (first-frame env)))
				(scan (frame-variables frame)
				(frame-values frame )))))
	(env-loop env))
	
;; b
	;;copied from https://wizardbook.wordpress.com/2011/01/03/exercise-4-16/
	;; takes a procedure body as argument and returns a version of it with no internal definitions
	
	;; loop through procedure body, identify define's, create a let association of the define's variable and the value *unassigned*, repeat loop
	;; if there's no more define's, save the rest of the procedure body as it is
	;; then create a let, with the associations created in the loop, as many "set!" as necessary for every variable/value pair, and finally with the rest of the original procedure's body ;;
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

	
;; c
;; I would install scan-out-defines in make-procedure, because it would be transformed only once
;; if we install it in the selector (procedure-body p), the transformation would need to occur every time the procedure body is selected
