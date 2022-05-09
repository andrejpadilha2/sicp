;; a)
(define (not-pair? element)
	(not (pair? element))

(define count-leaves-machine
	(make-machine
		'(tree continue p)
		(list (list '= =) (list '+ +) (list '- -) (list '* *) (list 'null? null?) (list 'not-pair? not-pair?) (list 'car car) (list 'cdr cdr))
		'((assign continue (label count-leaves-done))
		count-leaves
			(test (op null?) (reg tree))
			(branch (label base-case-0))	
			(test (op not-pair?) (reg tree))
			(branch (label base-case-1))
			;; else, prepare to count-leaves car tree
			(save continue)
			(assign continue (label after-count-leaves-car))
			(save tree)
			(assign tree (op car) (reg tree))
			(goto (label count-leaves))
		after-count-leaves-car
			;; prepare to count-leaves cdr tree
			(restore tree)
			(assign continue (label after-count-leaves-cdr))
			(assign tree (op cdr) (reg tree))
			(save p)
			(goto (label count-leaves))
		after-count-leaves-cdr
			;; sum the result of count-leaves car-tree and the result of this
			(assign tree (reg p))
			(restore p)
			(assign p (op +) (reg tree) (reg p))
			(restore continue)
			(goto (reg continue))
		base-case-0
			(assign p (const 0))
			(goto (reg continue))
		base-case-1
			(assign p (const 1))
			(goto (reg continue))
		count-leaves-done)))
	
;; final answer is on p






;; b)
(define count-leave-iter-machine
	(make-machine
		'(tree continue n)
		(list (list '= =) (list '+ +) (list '- -) (list '* *) (list 'null? null?) (list 'not-pair? not-pair?))
		'((assign n (const 0))
		(assign continue (label count-leaves-iter-done))
		count-iter
			(test (op null?) (reg tree))
			(branch (label base-case-0))
			(test (op not-pair?) (reg tree))
			(branch (label base-case-1))
			;; prepare to execute the inner count-iter
			(save continue)
			(assign continue (label after-inner-counter))
			(save tree)
			(assign tree (op car) (reg tree))
			(goto (label count-iter))
		after-inner-counter
			;; prepare to execute the outter count-iter
			(restore tree)
			(assign continue (label after-outter-counter))
			(assign tree (op cdr) (reg tree))
			(goto (reg count-iter))
		after-outter-counter
			(restore continue)
			(goto (reg continue))
		base-case-0
			(goto (reg continue))
		base-case-1
			(assign n (op +) (reg n) (const 1))
			(goto (reg continue))
		count-leaves-iter-done)))
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
