;; implementing append with register machines
(define (append x y)
	(if (null? x)
		y
		(cons (car x) (append (cdr x) y))))

(define append-machine
	(make-machine
		'(x y w continue)
		(list (list 'null? null) (list 'cons cons) (list 'car car) (list 'cdr cdr))
		'((assign continue (label append-done))
		append-loop
			(test (op null?) (reg x))
			(branch (label null-x))
			(save continue)
			;; prepare to do inner append
			(assign continue (label after-inner-append))
			(save x)
			(assign x (op cdr) (reg x))
			(goto (label append-loop))
		after-inner-append
			(restore x)
			(assign x (op car) (reg x))
			(restore continue)
			(assign (reg w) (op cons) (reg x) (reg w))
			(goto (label continue))
		null-x
			(assign w (reg y))
			(goto (reg continue))
		append-done)))
		
;; final result is in w



;; implementing append! with register machines		
(define (append! x y)
	(set-cdr! (last-pair x) y)
	x)
	
(define (last-pair x)
	(if (null? (cdr x))
		x
		(last-pair (cdr x))))
		

(define append!-machine
	(make-machine
		'(x y w z)
		(list (list 'null? null) (list 'cons cons) (list 'car car) (list 'cdr cdr))
		'((assign w (reg x)) ;; saves the start of x
		last-pair-loop
			(assign z (reg x)) ;; saves x before cdring into register z
			(assign x (op cdr) (reg x))
			(test (op null?) (reg x))
			(branch (label after-last-pair))
			(goto (label last-pair-loop))
		after-last-pair
			(perform (op set-cdr!) (reg z) (reg y)) ;; sets the cdr of z to be y
			(assign x (reg w)) ;; assigns x back to its beginning
		append!-done)))
		
		
		
		
		
		
		
		
		
		
		
		
		
