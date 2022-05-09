(controller
	(assign p (const 1))
	(assign c (const 1))
loop
	(test (op >) (reg c) (reg n))
	(branch (label done))
	(assign p (op *) (reg p) (reg c))
	(assign c (op +) (reg c) (const 1))
	(goto (label loop))
done)
