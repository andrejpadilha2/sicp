;; assuming good-enough? and improve are primitives
(controller
	(assign x (op read))
	(assign guess (const 1))
loop
	(test (op good-enough?) (reg guess))
	(branch (label done))
	(assign guess (op improve) (reg guess))
	(goto (label loop))
done)



;; expanding good-enough? and improve in arithmetic operations
(controller
	(assign x (op read))
	(assign guess (const 1))
loop-sqrt-iter
	(assign square (op *) (reg guess) (reg guess))
	(assign sub (op -) (reg square) (reg x))
	(test (op <) (reg sub) (const 0))
	(branch (label negative))
	(assign abs (reg sub))
compare
	(test (op <) (reg abs) (const 0.001))
	(branch (label done))
improve
	(assign temp (op /) (reg x) (reg guess))
	(assign guess (op +) (reg guess) (reg temp))
	(assign guess (op /) (reg guess) (const 2))
	(goto (label loop-sqrt-iter))		
negative
	(assign abs (op *) (reg sub) (const -1))
	(goto compare)
done)
