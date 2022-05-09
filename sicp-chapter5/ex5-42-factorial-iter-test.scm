;; iterative factorial procedure
(define (factorial n)
	(define (iter product counter)
		(if (> counter n)
			product
			(iter (* counter product)
				(+ counter 1))))
	(iter 1 1))
	
	
;; compiled to
((env) (val)
(
(assign val (op make-compiled-procedure) (label entry2) (reg env))
(goto (label after-lambda1))

entry2
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (n)) (reg argl) (reg env))
(assign val (op make-compiled-procedure) (label entry7) (reg env))
(goto (label after-lambda6))

entry7
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (product counter)) (reg argl) (reg env))
(save continue)
(save env)	;; this save env was already here and is correct
(save env)	;; this save env
(assign env (op get-global-environment) (reg env))
(assign proc (op lookup-variable-value) (const >) (reg env))
(restore env)	;; and this restore env, are just here so that we can get-the-global-environment, lookup ">", and then restore it so that the next instructions can use the correct "env"
(assign val (op lexical-address-lookup) (const (1 . 0)) (reg env))
(assign argl (op list) (reg val))
(assign val (op lexical-address-lookup) (const (0 . 1)) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch22))

compiled-branch21
(assign continue (label after-call20))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch22
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call20
(restore env)
(restore continue)
(test (op false?) (reg val))
(branch (label false-branch9))

true-branch10

(assign val (op lexical-address-lookup) (const (0 . 0)) (reg env))
(goto (reg continue))

false-branch9
(save env)
(assign env (op get-global-environment) (reg env))
(assign proc (op lookup-variable-value) (const iter) (reg env))
(restore env)
(save continue)
(save proc)
(save env)
(save env)
(assign env (op get-global-environment) (reg env))
(assign proc (op lookup-variable-value) (const +) (reg env))
(restore env)
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (op lexical-address-lookup) (const (0 . 1)) (reg env)) 
(assign argl (op cons) (reg val) (reg argl)) 
(test (op primitive-procedure?) (reg proc)) 
(branch (label primitive-branch16))

compiled-branch15
(assign continue (label after-call14))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch16
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call14
(assign argl (op list) (reg val))
(restore env)
(save argl)
(save env)
(assign env (op get-global-environment) (reg env))
(assign proc (op lookup-variable-value) (const *) (reg env))
(restore env)
(assign val (op lexical-address-lookup) (const (0 . 0)) (reg env))
(assign argl (op list) (reg val))
(assign val (op lexical-address-lookup) (const (0 . 1)) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch13))

compiled-branch12
(assign continue (label after-call11))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch13
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call11
(restore argl)
(assign argl (op cons) (reg val) (reg argl))
(restore proc)
(restore continue)
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch19))

compiled-branch18
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch19
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(goto (reg continue))

after-call17

after-if8

after-lambda6
(perform (op define-variable!) (const iter) (reg val) (reg env))
(assign val (const ok))
(assign env (op get-global-environment) (reg env))
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





