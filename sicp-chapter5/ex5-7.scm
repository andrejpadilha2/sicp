(define expn-machine
	(make-machine
	'(n b continue p)
	(list (list '= =) (list '- -) (list '* *))
	'(expn
		(test (op =) (reg n) (const 0))
		(branch (label expn-base-case))
		(save continue)
		(assign continue (label after-expn))
		(assign n (op -) (reg n) (const 1))	
		(goto (label expn))
	expn-base-case
		(assign p (const 1))
		(goto (reg continue))
	after-expn
		(restore continue)
		(assign p (op *) (reg p) (reg b))
		(goto (reg continue))
	expn-done)))
	
(set-register-contents! expn-machine 'b 4)

(set-register-contents! expn-machine 'n 3)

(start expn-machine)

(get-register-contents expn-machine 'p)
