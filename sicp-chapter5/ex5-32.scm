;; a)

;; will only change the eceval to "recognize as a separate class of expressions combinatios whose operator is a symbol", so that it doens't need to save the environment


		ev-application
			(save continue)
			(assign unev (op operands) (reg exp))
			(save unev)
			(assign exp (op operator) (reg exp))
			(test (op symbol?) (reg exp))					;; tests to check if the operator is a symbol
			(branch (label ev-appl-lookup-operator))	
			(save env)
			(assign continue (label ev-appl-did-operator))
			(goto (label eval-dispatch))
		ev-appl-lookup-operator
			(assign continue (label ev-appl-looked-operator))		;; only lookup the operator, doesn't save "env"
			(goto (label eval-dispatch))
		ev-appl-looked-operator
			(restore unev) 						;; if it just looked up the value of the operator, doesn't restore "env"
			(goto (label ev-appl-operator))
		ev-appl-did-operator
			(restore unev)
			(restore env)	
		ev-appl-operator	
			(assign argl (op empty-arglist))				;; now it normally proceeds to accumulate the arguments into "argl" or to 
			(assign proc (reg val))
			(test (op no-operands?) (reg unev))
			(branch (label apply-dispatch))				;; apply the operator if there are no arguments
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
		
		
;; b)
;; The compilator would still be able to make some optimzations that the interpreter couldn't...since the compilator scans all the code first, then it can check which types of saves and restores are unnecessary...even with special cases, some of these eliminations would not be possible with the interpreter because it only "see" one operation at a time
