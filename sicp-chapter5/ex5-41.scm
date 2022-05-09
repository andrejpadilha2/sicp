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
		
		
;; (define cte1 (list (list 'y 'z) (list 'a 'b 'c 'd 'e) (list 'x 'y))) ;; for testing

