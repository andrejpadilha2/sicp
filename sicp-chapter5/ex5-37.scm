;; first definition of factorial (with recursive process), compiled with alternative compiler
(define (factorial n)
	(if (= n 1)
		1
		(* (factorial (- n 1)) n)))

;; and the compiled code is
((continue env) (val) 
(
(save continue) 
(save env) 
(save continue) 
(assign val (op make-compiled-procedure) (label entry2) (reg env))
(restore continue) (goto (label after-lambda1))

entry2
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (n)) (reg argl) (reg env))
(save continue)
(save env)
(save continue)
(save env)
(save continue)
(assign proc (op lookup-variable-value) (const =) (reg env))
(restore continue)
(restore env)
(restore continue)
(save continue)
(save proc)
(save env)
(save continue)
(assign val (const 1))
(restore continue)
(assign argl (op list) (reg val))
(restore env)
(save argl)
(save continue)
(assign val (op lookup-variable-value) (const n) (reg env))
(restore continue)
(restore argl)
(assign argl (op cons) (reg val) (reg argl))
(restore proc)
(restore continue)
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch17))

compiled-branch16
(assign continue (label after-call15))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch17
(save continue)
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(restore continue)

after-call15
(restore env)
(restore continue)
(test (op false?) (reg val))
(branch (label false-branch4))

true-branch5
(save continue)
(assign val (const 1))
(restore continue)
(goto (reg continue))

false-branch4
(save continue)
(save env)
(save continue)
(assign proc (op lookup-variable-value) (const *) (reg env))
(restore continue)
(restore env)
(restore continue)
(save continue)
(save proc)
(save env)
(save continue)
(assign val (op lookup-variable-value) (const n) (reg env))
(restore continue)
(assign argl (op list) (reg val))
(restore env)
(save argl)
(save continue)
(save env)
(save continue)
(assign proc (op lookup-variable-value) (const factorial) (reg env))
(restore continue)
(restore env)
(restore continue)
(save continue)
(save proc)
(save continue)
(save env)
(save continue)
(assign proc (op lookup-variable-value) (const -) (reg env))
(restore continue)
(restore env)
(restore continue)
(save continue)
(save proc)
(save env)
(save continue)
(assign val (const 1))
(restore continue)
(assign argl (op list) (reg val))
(restore env)
(save argl)
(save continue)
(assign val (op lookup-variable-value) (const n) (reg env))
(restore continue)
(restore argl)
(assign argl (op cons) (reg val) (reg argl))
(restore proc)
(restore continue)
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch8))

compiled-branch7
(assign continue (label after-call6))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch8
(save continue)
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(restore continue)

after-call6
(assign argl (op list) (reg val))
(restore proc)
(restore continue)
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch11))

compiled-branch10
(assign continue (label after-call9))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch11
(save continue)
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(restore continue)

after-call9
(restore argl)
(assign argl (op cons) (reg val) (reg argl))
(restore proc)
(restore continue)
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch14))

compiled-branch13
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch14
(save continue)
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(restore continue)
(goto (reg continue))

after-call12

after-if3

after-lambda1
(restore env)
(perform (op define-variable!) (const factorial) (reg val) (reg env))
(assign val (const ok)) (restore continue)))

		
		
;; it's easy to see that there's several unnecessary saves and restores		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
