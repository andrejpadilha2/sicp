;; If we implemented "unless" as a special form (besides not being a good practice to just add more and more special forms to a language), we wouldn't be able to pass "unless" as an argument to other functions, like "map" (I think....?)

;; if we wish to implement "unless" as a special form

(define (unless? exp) (tagged-list? exp 'unless))

(define (unless-condition exp) (cadr exp))

(define (unless-usual-value exp) (caddr exp))
	
(define (unless-exceptional-value exp) 
	(if (not (null? (cdddr exp)))
		(cadddr exp)
		'false))

(define (unless->if exp)
	(make-if (unless-condition exp) (unless-exceptional-value exp) (unless-usual-value exp))
	

					
;; and then we just add this to "eval" clauses				
((unless? exp) (eval (unless->if exp) env))
