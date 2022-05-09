(load "RegisterMachineSimulator.scm") ; for (make-machine) and (assemble) 
(load "compiler.scm") ; for (compile) 
(load "ExplicitControlEvaluatorMachineSyntaxStructureOperations.scm") ; for syntax and utility procedures 
(load "scan-out-defines.scm") ; for operation list, needed by assembler 
  

(define (print-stack-statistics)
	((ec-comp-exec 'stack) 'print-statistics))  

 ; return linkage makes compiled code return to print-result below 
 (define (compile-and-assemble expr) 
     (assemble 
         (statements (compile expr 'val 'return compile-time-environment)) 
         ec-comp-exec)) 
  
 ; compiler expects same register set as eceval 
 (define ec-comp-exec-registers 
     '(expr env val proc argl continue unev arg1 arg2 compapp)) 
      
 (define ec-comp-exec-operations  
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
		(list 'compile-instructions compile-instructions)
		(list 'compile-and-assemble compile-and-assemble)))
      
      
      
 (define ec-comp-exec-controller-text '( 
  
 ; main loop same as eceval 
 read-compile-exec-print-loop 
     (perform (op initialize-stack))  
     (perform (op prompt-for-input) (const ";;; EC-Comp-Exec input:")) 
     (assign expr (op read)) 
     (assign env (op get-global-environment)) 
     (assign continue (label print-result))  
     (goto (label compile-and-execute)) ; ** label name changed 
 print-result 
     (perform (op print-stack-statistics)) 
     (perform (op announce-output) (const ";;; EC-Comp-Exec value:")) 
     (perform (op user-print) (reg val)) 
     (goto (label read-compile-exec-print-loop)) 
  
      
 ; the entirety of the new machine! as per the problem statement,  
 ; all complexity is deferred to "primitives" (compile) and (assemble) 
 compile-and-execute 
     (assign val (op compile-and-assemble) (reg expr)) 
     (goto (reg val)) 
      
 )) 
  
  
  
 (define ec-comp-exec (make-machine 
     ec-comp-exec-registers 
     ec-comp-exec-operations  
     ec-comp-exec-controller-text)) 
  
 (define (start-ec-comp-exec) 
     (set! the-global-environment (setup-environment)) 
     (ec-comp-exec 'start) 
 ) 
  
 (start-ec-comp-exec) 
		
		
		
		
		
		
		
		
