;; an address is a pair of two numbers -> address: (frame . displacement)

;; we must remember that we start the list from position 0
(define (address-frame address) (car address))
(define (address-displacement address) (cdr address))

;; a frame is a pair of two lists, variable names and variable values

(define (lexical-address-lookup address rtenv)
	;; the compile-time environment is a list of frames, each containing a list of variables	
	;; the lexical address consists of two numbers, a frame number and a displacement number	
	;; we should basically "walk" through the rte using the address supplied
	(let*  ((frame (list-ref rtenv (address-frame address))) ;; we scan rtenv to retrieve the correct frame
		(value (list-ref (frame-values frame) (address-displacement address)))) ;; we then scan the values of that frame to retrieve the correct value we are looking for
		(if (eq? value '*unassigned*) ;; check if the value is "unassigned"
			(error "the variable is unassigned -- LEXICAL-ADDRESS-LOOKUP" address)
			value))) ;; return the value

(define (lexical-address-set! address new-value rtenv)
	(let*  ((frame (list-ref rtenv (address-frame address))) ;; we scan rtenv to retrieve the correct frame
		(values (frame-values frame))) ;; we than extract only the "values" list of the frame
		(list-set! values (address-displacement address) new-value)))
		
		
		
(define (list-set! list k val)
	(if (= k 0)
		(set-car! list val)
		(list-set! (cdr list) (- k 1) val)))
		
		
(define (find-variable val cte)
	(let 	((frame-number 0)
		(displacement 0)
		(env cte))
		(define (frame-search val env)
			(if (null? env)
				'not-found
				(variable-search val (car env))))
		
		(define (variable-search val frame)
			(if (null? frame)
				(begin
					(set! frame-number (+ 1 frame-number))
					(set! displacement 0)
					(set! env (cdr env))
					(frame-search val env))
				(if (eq? (car frame) val)
					(cons frame-number displacement)
					(begin
						(set! displacement (+ 1 displacement))
						(variable-search val (cdr frame))))))	
			
		(frame-search val cte)))
