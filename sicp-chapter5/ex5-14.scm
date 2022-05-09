(load "cap5-RegisterMachineSimulator.scm")

(define (fact-machine-general n tracing)
	(define fact-machine 
		(make-machine
		'(a n continue)
		
		(list (list '* *) (list '= =) (list '- -) (list 'print display))
		
		'(	
			(assign continue (label fact-done))
			fact-loop
				(test (op =) (reg n) (const 1))
				(branch (label fact-base-case))
				(save continue)
				(assign continue (label after-fact-loop))
				(save n)
				(assign n (op -) (reg n) (const 1))
				(goto (label fact-loop))
			fact-base-case
				(assign n (const 1))
				(goto (reg continue))
			after-fact-loop
				(assign a (reg n))
				(restore n)
				(restore continue)
				(assign n (op *) (reg a) (reg n))
				(goto (reg continue))
			fact-done
				(perform (op print) (reg n))
				)))
	
	(if (eq? tracing 'on)
		(fact-machine 'trace-on))
	((fact-machine 'stack) 'initialize)
	(set-register-contents! fact-machine 'n n)
	(start fact-machine)
	((fact-machine 'stack) 'print-statistics)
	(fact-machine 'print-instruction-counter))
				

