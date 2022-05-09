;; mistery procedure
(define (f x)
	(+ x (g (+ x 2))))
		
;; and the compiled code is
((env) (val) 
(

(assign val (op make-compiled-procedure) (label entry16) (reg env)) ;; compilation of first definition of procedure
(goto (label after-lambda15))

entry16
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (x)) (reg argl) (reg env)) ;; formal parameter, only "x"
(assign proc (op lookup-variable-value) (const +) (reg env)) ;; there's a summation
(save continue)
(save proc) ;; saves "+"
(save env)
(assign proc (op lookup-variable-value) (const g) (reg env)) ;; there's a procedure "g"
(save proc) ;; saves "g"
(assign proc (op lookup-variable-value) (const +) (reg env)) ;; another summation
(assign val (const 2))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const x) (reg env))
(assign argl (op cons) (reg val) (reg argl)) ;; argl now contains the list "(x 2)"
(test (op primitive-procedure?) (reg proc)) ;; tests if "+" is a primitive procedure
(branch (label primitive-branch19))

compiled-branch18
(assign continue (label after-call17))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch19
(assign val (op apply-primitive-procedure) (reg proc) (reg argl)) ;; applies the summation "(+ x 2)"

after-call17
(assign argl (op list) (reg val)) ;; argl now contains the result of "(+ x 2)"
(restore proc) ;; restores "g"
(test (op primitive-procedure?) (reg proc)) ;; check if "g" is a primitive procedure
(branch (label primitive-branch22))

compiled-branch21 ;; "g" is not a primitive procedure
(assign continue (label after-call20))
(assign val (op compiled-procedure-entry) (reg proc)) ;; assign to "val" the value of the entry of "g"
(goto (reg val)) ;; goes to the entry of "g", which is not defined here (but doesn't need to), and will return to "after-call20"

primitive-branch22
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call20
(assign argl (op list) (reg val)) ;; argl now holds the result of "(g (+ x 2))"
(restore env) ;; restores the "env" so that it can check the correct value of "x" in the next instruction
(assign val (op lookup-variable-value) (const x) (reg env))
(assign argl (op cons) (reg val) (reg argl)) ;; argl now contains a list of "x" and the result of "(g (+ x 2))"
(restore proc) ;; restores the procedure "+"
(restore continue)
(test (op primitive-procedure?) (reg proc)) ;; test if "+" is a primitive procedure
(branch (label primitive-branch25))

compiled-branch24
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch25
(assign val (op apply-primitive-procedure) (reg proc) (reg argl)) ;; applies the primitive procedure "+" to sum "x" and "(g (+ x 2))"
(goto (reg continue))

after-call23

after-lambda15
(perform (op define-variable!) (const f) (reg val) (reg env)) ;; saves the name of this procedure ("f"), with the associanted compiled-procedure in the current environment
(assign val (const ok))
