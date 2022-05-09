(load "ExplicitControlEvaluatorMachineSyntaxStructureOperations.scm") ;; Syntax Structure and some Operations of eceval
(load "RegisterMachineSimulator.scm") ;; the simulator is responsible of simulating eceval as a register machine
(load "compiler.scm") 
(load "scan-out-defines.scm")

(define (print-stack-statistics)
	((eceval 'stack) 'print-statistics))
	

		

(define eceval ;; EXPLICIT CONTROL EVALUATOR MACHINE
	(make-machine
		'(exp env val proc argl continue unev arg1 arg2 compapp) ;; all register of the ECE
		(list ;; all operations considered primitives of the ECE
			(list 'print-stack-statistics print-stack-statistics)
			(list 'prompt-for-input prompt-for-input)
			(list 'read read)
			(list 'get-global-environment get-global-environment)
			(list 'announce-output announce-output)
			(list 'user-print user-print)
			(list 'self-evaluating? self-evaluating?) 
			(list 'variable? variable?)
			(list 'quoted? quoted?)
			(list 'assignment? assignment?)
			(list 'definition? definition?)
			(list 'if? if?)
			(list 'lambda? lambda?)
			(list 'begin? begin?)
			(list 'cond? cond?)
			(list 'let? let?)
			(list 'let*? let*?)
			(list 'application? application?)
			(list 'lookup-variable-value lookup-variable-value)
			(list 'text-of-quotation text-of-quotation)
			(list 'lambda-parameters lambda-parameters)
			(list 'lambda-body lambda-body)
			(list 'make-procedure make-procedure)
			(list 'operands operands)
			(list 'operator operator)
			(list 'empty-arglist empty-arglist)
			(list 'no-operands? no-operands?)
			(list 'first-operand first-operand)
			(list 'last-operand? last-operand?)
			(list 'adjoin-arg adjoin-arg)
			(list 'rest-operands rest-operands)
			(list 'begin-actions begin-actions)
			(list 'first-exp first-exp)
			(list 'last-exp? last-exp?)
			(list 'rest-exps rest-exps)
			(list 'if-predicate if-predicate)
			(list 'true? true?)
			(list 'false? false?)
			(list 'if-alternative if-alternative)
			(list 'if-consequent if-consequent)
			(list 'assignment-variable assignment-variable)
			(list 'assignment-value assignment-value)
			(list 'lexical-address-lookup lexical-address-lookup)
			(list 'set-variable-value! set-variable-value!)
			(list 'lexical-address-set! lexical-address-set!)
			(list 'definition-variable definition-variable)
			(list 'definition-value definition-value)
			(list 'define-variable! define-variable!)
			(list 'cond->if cond->if)
			(list 'let->combination let->combination)
			(list 'let*->nested-lets let*->nested-lets)
			(list 'primitive-procedure? primitive-procedure?)
			(list 'compound-procedure? compound-procedure?)
			(list 'compiled-procedure? compiled-procedure?)
			(list 'apply-primitive-procedure apply-primitive-procedure)
			(list 'procedure-parameters procedure-parameters)
			(list 'procedure-environment procedure-environment)
			(list 'extend-environment extend-environment)
			(list 'procedure-body procedure-body)
			(list 'compiled-procedure-entry compiled-procedure-entry)
			(list 'make-compiled-procedure make-compiled-procedure)
			(list 'compiled-procedure-env compiled-procedure-env)
			(list 'list list)
			(list 'cons cons)
			(list '+ +)
			(list '- -)
			(list '* *)
			(list '/ /)
			(list '= =)
			(list '< <)
			(list '> >)
			(list 'compile-run? compile-run?)
			(list 'compile-text compile-text)
			(list 'compile-instructions compile-instructions))
			
		'(
			(assign compapp (label compound-apply))
			(branch (label external-entry)) ;; branch if "flag" is set
		;; DRIVER-LOOP
		read-eval-print-loop
			(perform (op initialize-stack))
			(perform (op prompt-for-input) (const ";;; EC-Eval input:"))
			(assign exp (op read))
			(assign env (op get-global-environment))
			(assign continue (label print-result))
			(goto (label eval-dispatch))
		print-result
			(perform (op print-stack-statistics))
			(perform (op announce-output) (const ";;; EC-Eval value:"))
			(perform (op user-print) (reg val))
			(goto (label read-eval-print-loop))
		unknown-expression-type
			(assign val (const unknown-expression-type-error))
			(goto (label signal-error))
		unknown-procedure-type
			(restore continue)
			(assign val (const unknown-procedure-type-error))
			(goto (label signal-error))
		signal-error						 ;; if there's an error, print it's value and start the driver-loop again
			(perform (op user-print) (reg val))
			(goto (label read-eval-print-loop))
		;; EVAL DISPATCH
		eval-dispatch
			(test (op self-evaluating?) (reg exp))
			(branch (label ev-self-eval))
			(test (op variable?) (reg exp))
			(branch (label ev-variable))
			(test (op quoted?) (reg exp))
			(branch (label ev-quoted))
			(test (op assignment?) (reg exp))
			(branch (label ev-assignment))
			(test (op definition?) (reg exp))
			(branch (label ev-definition))
			(test (op if?) (reg exp))
			(branch (label ev-if))
			(test (op lambda?) (reg exp))
			(branch (label ev-lambda))
			(test (op begin?) (reg exp))
			(branch (label ev-begin))
			(test (op cond?) (reg exp))
			(branch (label ev-cond))
			(test (op let?) (reg exp))
			(branch (label ev-let))
			(test (op let*?) (reg exp))
			(branch (label ev-let*))
			(test (op compile-run?) (reg exp))
			(branch (label ev-compile))
			(test (op application?) (reg exp))
			(branch (label ev-application))
			(goto (label unknown-expression-type))
		;; evaluating simple expressions	
		ev-self-eval
			(assign val (reg exp))
			(goto (reg continue))
		ev-variable
			(assign val (op lookup-variable-value) (reg exp) (reg env))
			(goto (reg continue))
		ev-quoted
			(assign val (op text-of-quotation) (reg exp))
			(goto (reg continue))
		ev-lambda
			(assign unev (op lambda-parameters) (reg exp))
			(assign exp (op lambda-body) (reg exp))
			(assign val 	(op make-procedure)
					(reg unev) (reg exp) (reg env))
			(goto (reg continue))
		;; evaluating procedure applications
		ev-application
			(save continue)
			(save env)
			(assign unev (op operands) (reg exp))
			(save unev)
			(assign exp (op operator) (reg exp))
			(assign continue (label ev-appl-did-operator))
			(goto (label eval-dispatch))
		ev-appl-did-operator
			(restore unev)
			(restore env)
			(assign argl (op empty-arglist))
			(assign proc (reg val))
			(test (op no-operands?) (reg unev))
			(branch (label apply-dispatch))
			(save proc)
		ev-appl-operand-loop
			(save argl)
			(assign exp (op first-operand) (reg unev))
			(test (op last-operand?) (reg unev))
			(branch (label ev-appl-last-arg))
			(save env)
			(save unev)
			(assign continue (label ev-appl-accumulate-arg))
			(goto (label eval-dispatch))
		ev-appl-accumulate-arg
			(restore unev)
			(restore env)
			(restore argl)
			(assign argl (op adjoin-arg) (reg val) (reg argl))
			(assign unev (op rest-operands) (reg unev))
			(goto (label ev-appl-operand-loop))
		ev-appl-last-arg
			(assign continue (label ev-appl-accum-last-arg))
			(goto (label eval-dispatch))
		ev-appl-accum-last-arg
			(restore argl)
			(assign argl (op adjoin-arg) (reg val) (reg argl))
			(restore proc)
			(goto (label apply-dispatch))
		;; evaluating sequences
		ev-begin
			(assign unev (op begin-actions) (reg exp))
			(save continue)
			(goto (label ev-sequence))
		ev-sequence
			(assign exp (op first-exp) (reg unev))
			(test (op last-exp?) (reg unev))
			(branch (label ev-sequence-last-exp))
			(save unev)
			(save env)
			(assign continue (label ev-sequence-continue))
			(goto (label eval-dispatch))
		ev-sequence-continue
			(restore env)
			(restore unev)
			(assign unev (op rest-exps) (reg unev))
			(goto (label ev-sequence))
		ev-sequence-last-exp
			(restore continue)
			(goto (label eval-dispatch))
		;; evaluating if conditionals
		ev-if
			(save exp)
			(save env)
			(save continue)
			(assign continue (label ev-if-decide))
			(assign exp (op if-predicate) (reg exp))
			(goto (label eval-dispatch))
		ev-if-decide
			(restore continue)
			(restore env)
			(restore exp)
			(test (op true?) (reg val))
			(branch (label ev-if-consequent))
		ev-if-alternative
			(assign exp (op if-alternative) (reg exp))
			(goto (label eval-dispatch))
		ev-if-consequent
			(assign exp (op if-consequent) (reg exp))
			(goto (label eval-dispatch))
		;; evaluating assignments 
		ev-assignment
			(assign unev (op assignment-variable) (reg exp))
			(save unev)
			(assign exp (op assignment-value) (reg exp))
			(save env)
			(save continue)
			(assign continue (label ev-assignment-1))
			(goto (label eval-dispatch))
		ev-assignment-1
			(restore continue)
			(restore env)
			(restore unev)
			(perform (op set-variable-value!) (reg unev) (reg val) (reg env))
			(assign val (const ok))
			(goto (reg continue))
		;; evaluating definitions
		ev-definition
			(assign unev (op definition-variable) (reg exp))
			(save unev)
			(assign exp (op definition-value) (reg exp))
			(save env)
			(save continue)
			(assign continue (label ev-definition-1))
			(goto (label eval-dispatch))
		ev-definition-1
			(restore continue)
			(restore env)
			(restore unev)
			(perform (op define-variable!) (reg unev) (reg val) (reg env))
			(assign val (const ok))
			(goto (reg continue))
		ev-cond
			(assign exp (op cond->if) (reg exp))
			(goto (label eval-dispatch))
		ev-let
			(assign exp (op let->combination) (reg exp))
			(goto (label eval-dispatch))
	
		ev-let*
			(assign exp (op let*->nested-lets) (reg exp))
			(goto (label eval-dispatch))
		;; APPLY
		apply-dispatch
			(test (op primitive-procedure?) (reg proc))
			(branch (label primitive-apply))
			(test (op compound-procedure?) (reg proc))
			(branch (label compound-apply))
			(test (op compiled-procedure?) (reg proc))
			(branch (label compiled-apply))
			(goto (label unknown-procedure-type))
		;; primitive procedure
		primitive-apply
			(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
			(restore continue)
			(goto (reg continue))
		;; interpreted compound procedure
		compound-apply
			(assign unev (op procedure-parameters) (reg proc))
			(assign env (op procedure-environment) (reg proc))
			(assign env (op extend-environment) (reg unev) (reg argl) (reg env))
			(assign unev (op procedure-body) (reg proc))
			(goto (label ev-sequence))
		;; compiled compound procedure
		compiled-apply
			(restore continue)
			(assign val (op compiled-procedure-entry) (reg proc))
			(goto (reg val))
		
		;; external entry, jumping directly to a place specified in register "val"
		external-entry
			(perform (op initialize-stack))
			(assign env (op get-global-environment))
			(assign continue (label print-result))
			(goto (reg val))
		
		;; parts of the evaluator that make it able to compile code	
		ev-compile
			(save continue)
			(assign exp (op compile-text) (reg exp))
			(assign continue (label ev-compile-text))
			(goto (label eval-dispatch))
		ev-compile-text
			(restore continue)
			(assign val (op compile-instructions) (reg val))
			(goto (reg val)))))

;; now the commands to start the machine directly in the interpreter, not compiling any code before
(define (start-eceval)
	(set! the-global-environment (setup-environment))
	(set-register-contents! eceval 'flag false)
;;	(eceval 'trace-on)
	(start eceval))

;; command to start the machine already compiling a piece of code
(define (compile-and-go expression)
	(let 	((instructions 
			(assemble (statements
					(compile expression 'val 'return compile-time-environment))
					eceval)))
		(set! the-global-environment (setup-environment))
		(set-register-contents! eceval 'val instructions)
		(set-register-contents! eceval 'flag true)
;;		(eceval 'trace-on)
		(start eceval)))
