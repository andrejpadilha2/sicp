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
