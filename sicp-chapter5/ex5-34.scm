;; iterative factorial procedure
(define (factorial n)
	(define (iter product counter)
		(if (> counter n)
			product
			(iter (* counter product)
				(+ counter 1))))
	(iter 1 1))
		
;; and the compiled code is
((env) (val) 
(
(assign val (op make-compiled-procedure) (label entry2) (reg env)) ;; compilation of first lambda expression (from "(factorial n)")
(goto (label after-lambda1))

entry2 ;; procedure body of "(factorial n")
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (n)) (reg argl) (reg env))
(assign val (op make-compiled-procedure) (label entry7) (reg env)) ;; compilation of second lambda expression (from "(iter product counter)"
(goto (label after-lambda6))

entry7 ;; procedure body of "(iter product counter)"
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (product counter)) (reg argl) (reg env))
(save continue) ;; save continue on stack
(save env) ;; save env on stack
(assign proc (op lookup-variable-value) (const >) (reg env))
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const counter) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc)) ;; checks if ">" is a primitive procedure
(branch (label primitive-branch22)) 

compiled-branch21
(assign continue (label after-call20))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch22
(assign val (op apply-primitive-procedure) (reg proc) (reg argl)) ;; application of primitive procedure ">"

after-call20
(restore env) ;; restores env from stack
(restore continue) ;; restores continue from stack, now the stack is empty again
(test (op false?) (reg val))
(branch (label false-branch9))

true-branch10 ;; if counter > n, ends the program, result is in prodcut, and will be in register "val"
(assign val (op lookup-variable-value) (const product) (reg env))
(goto (reg continue))

false-branch9 ;; if counter !> n
(assign proc (op lookup-variable-value) (const iter) (reg env)) ;; lookup the value of "iter"
(save continue) ;; save continue on stack
(save proc) ;; save proc on stack, that's, "iter"
(save env) ;; save env on stack
(assign proc (op lookup-variable-value) (const +) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const counter) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc)) ;; checks if "+" is a primitive procedure
(branch (label primitive-branch16))

compiled-branch15
(assign continue (label after-call14))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch16
(assign val (op apply-primitive-procedure) (reg proc) (reg argl)) ;; application of primitive procedure "+"

after-call14
(assign argl (op list) (reg val)) ;; now arglist contains the value from "(+ counter 1)"
(restore env) ;; restore env from stack
(save argl) ;; save argl on stack
(assign proc (op lookup-variable-value) (const *) (reg env)) ;; now it will execute the * procedure
(assign val (op lookup-variable-value) (const product) (reg env))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const counter) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc)) ;; checks if "*" is a primitive procedure
(branch (label primitive-branch13))

compiled-branch12
(assign continue (label after-call11))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch13
(assign val (op apply-primitive-procedure) (reg proc) (reg argl)) ;; application of primitive procedure "*"

after-call11
(restore argl) ;; restore argl from stack
(assign argl (op cons) (reg val) (reg argl)) ;; now argl contains two values, first the value from "(* counter product)" and "(+ counter 1)"
(restore proc) ;; restores proc from stack
(restore continue) ;; restores continue from stack, now the stack is EMPTY
(test (op primitive-procedure?) (reg proc)) ;; is "iter" a primitive procedure?
(branch (label primitive-branch19))

compiled-branch18 ;; since "iter" is not a primitive procedure
(assign val (op compiled-procedure-entry) (reg proc)) ;; assigns to "val" the value of "iter"s entry, that's, "entry7"
(goto (reg val)) ;; goes to "entry7"...notice how it calls "iter" again and the stack is EMPTY...this is the main difference between the recursive process and the iterative process (check ex5-33.scm)

primitive-branch19
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(goto (reg continue))

after-call17

after-if8

after-lambda6
(perform (op define-variable!) (const iter) (reg val) (reg env))
(assign val (const ok))
(assign proc (op lookup-variable-value) (const iter) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (const 1))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch5))

compiled-branch4
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch5
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(goto (reg continue))

after-call3

after-lambda1
(perform (op define-variable!) (const factorial) (reg val) (reg env))
(assign val (const ok))))

;; in entry2 there's no "save env" in the iterative procedure

