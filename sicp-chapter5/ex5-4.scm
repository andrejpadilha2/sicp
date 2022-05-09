;; when trying to do exercise a, I actually did exercise b...
;; but solution b is that of an iterative process, not a recursive process
;; hence, we need to create a specific solution for a recursive process
;; in SICP we find "The continue register must always be saved. Whether there are other registers that need to be saved depends on the particular machine, since not all recursive computations need the original values of registers that are modified during solution of the subproblem."


;; a
(controller
	(assign n (op read))
	(assign b (op read))
	(assign continue (label expn-done))
expn
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
expn-done)

;; b
(controller
init
	(assign n (op read))
	(assign b (op read))
	(assign counter (reg n))
	(assign product (const 1))
expt-iter
	(test (op =) (reg counter) (const 0))
	(branch (label expt-done))
	(assign product (op *) (reg b) (reg product))
	(assign counter (op -) (reg counter) (const 1))
	(goto (label expt-iter))
expt-done)
