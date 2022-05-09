;; first definition of factorial (with recursive process) is
(define (factorial n)
	(if (= n 1)
		1
		(* (factorial (- n 1)) n)))
	
	
	
		
;; and the compiled code is
((env) (val) 
(
(assign val (op make-compiled-procedure) (label entry2) (reg env)) ;; compilation of the lambda expression from "(factorial n)"
(goto (label after-lambda1))
 
entry2 ;; procedure body of "(factorial n)"
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (n)) (reg argl) (reg env))
(save continue) ;; saves continue on stack
(save env) ;; saves env on stack
(assign proc (op lookup-variable-value) (const =) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc)) ;; checks if "=" is a primitive procedure
(branch (label primitive-branch17))

compiled-branch16
(assign continue (label after-call15))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch17
(assign val (op apply-primitive-procedure) (reg proc) (reg argl)) ;; applies the primitive procedure "n"

after-call15
(restore env) ;; restores env from stack
(restore continue) ;; restores continue from stack, now the stack is EMPTY
(test (op false?) (reg val)) ;; check if "(= n 1)" is true/false
(branch (label false-branch4))

true-branch5
(assign val (const 1)) ;; if it's true, it will assign 1 to register "val" and go to the place in register "continue"
(goto (reg continue)) 

false-branch4 ;; if it's false
(assign proc (op lookup-variable-value) (const *) (reg env))
(save continue) ;; saves continue on stack
(save proc) ;; saves proc on stack, that's, "*"
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op list) (reg val))
(save argl) ;; saves argl on stack (which will hold the value of "n", necessary to compute the multiplication when (factorial (- n 1)) returns)
(assign proc (op lookup-variable-value) (const factorial) (reg env))
(save proc) ;; saves proc on stack, that's, "factorial"
(assign proc (op lookup-variable-value) (const -) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc)) ;; checks if "-" is a primitive procedure
(branch (label primitive-branch8))

compiled-branch7
(assign continue (label after-call6))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch8
(assign val (op apply-primitive-procedure) (reg proc) (reg argl)) ;; applies the primitive procedure "-"

after-call6
(assign argl (op list) (reg val)) ;; argl now contains the result of "(- n 1)"
(restore proc) ;; restores proc from stack, that's, "factorial"
(test (op primitive-procedure?) (reg proc)) ;; check if "factorial" is a primitive procedure
(branch (label primitive-branch11))

compiled-branch10 ;; since "factorial" is not a primitive procedure
(assign continue (label after-call9))
(assign val (op compiled-procedure-entry) (reg proc)) ;; assign to "val" the value of the "entry" of "factorial", that's, "entry2"
(goto (reg val)) ;; goes to "entry2"...but notice how we still have on the stack the procedure "*", "argl" and "continue"...this is the main difference between the recursive process and the iterative process (check ex5-34.scm)

primitive-branch11
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

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
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(goto (reg continue))

after-call12

after-if3

after-lambda1
(perform (op define-variable!) (const factorial) (reg val) (reg env))
(assign val (const ok))))



;; now, the alternative version of factorial
(define (factorial-alt n)
	(if (= n 1)
		1
		(* n (factorial-alt (- n 1)))))
		
;; the compiled code is
((env) (val) 
(
(assign val (op make-compiled-procedure) (label entry2) (reg env))
(goto (label after-lambda1))

entry2
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (n)) (reg argl) (reg env))
(save continue)
(save env)
(assign proc (op lookup-variable-value) (const =) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch17))

compiled-branch16
(assign continue (label after-call15))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch17
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call15
(restore env)
(restore continue)
(test (op false?) (reg val))
(branch (label false-branch4))

true-branch5
(assign val (const 1))
(goto (reg continue))

false-branch4
(assign proc (op lookup-variable-value) (const *) (reg env))
(save continue)
(save proc)
(save env) 				;; not present in the first version
(assign proc (op lookup-variable-value) (const factorial-alt) (reg env))
(save proc)
(assign proc (op lookup-variable-value) (const -) (reg env))
(assign val (const 1))
(assign argl (op list) (reg val))
(assign val (op lookup-variable-value) (const n) (reg env))
(assign argl (op cons) (reg val) (reg argl))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch8))

compiled-branch7
(assign continue (label after-call6))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch8
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call6
(assign argl (op list) (reg val))
(restore proc)
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch11))

compiled-branch10
(assign continue (label after-call9))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch11
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))

after-call9
(assign argl (op list) (reg val))
(restore env) ;; not present in the first version
(assign val (op lookup-variable-value) (const n) (reg env)) ;; not present in first version
(assign argl (op cons) (reg val) (reg argl))
(restore proc)
(restore continue)
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch14))

compiled-branch13
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

primitive-branch14
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(goto (reg continue))

after-call12

after-if3

after-lambda1
(perform (op define-variable!) (const factorial-alt) (reg val) (reg env))
(assign val (const ok))))

;; in the first version, inside "false-branch4", it saves continue, proc, argl, proc
;; in the alten version, inside "false-branch4", it saves continue, proc, env, proc

;; so it substitutes saving "argl" to "env"

;; the main difference is that in the first version, the data relative to calculate factorial "n" is inside "argl" and it's calculated in "primitive-branch14"...it saves and restore the register "argl"
;; in the alternative version, the data is maintained in "env" (saved in "false-branch4") and restored on "after-call9", then it's passed to argl also in "after-call9", then it's finally calculated...it saves and retore the register "env"

;; but the number of instructions is the same on both cases, and I think the speed will be the same (only if there's a differente between saving "argl" and "env" there would be a difference)

