;; Comments on this exercise: all we need to change is the to remove the registers allocation from "make-machine" and then 
;; allocate the register as we "lookup-register" names inside "make-new-machine"...
;; It's another way to think about the machine, making the register allocation "automatic", but we must also be careful
;; because if we make a typo with one of the registers names, the machine WILL be created anyways, but with the
;; wrong register name created as well as the correct one (if it appears correct anywhere else)




;; Representing a specific machine, as a procedure with local state (a.k.a. a class of object in OOP).
;; Registers and the stack are also represented as a procedure with local state

;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 					THE SPECIFIC MACHINE
(define (make-machine ops controller-text)
	(let ((machine (make-new-machine))) ;; creates a general machine model
;;													** PLACE WHERE I CHANGED TO COMPLETE THIS EXERCISE
		;;(for-each
			;;(lambda (register-name)
				;;((machine 'allocate-register) register-name)) ;; allocates registers
				;;register-names)
		((machine 'install-operations) ops) ;; installs the operations of the machine corresponding to the underlying Lisp operation
		((machine 'install-instruction-sequence) (assemble controller-text machine)) ;; assembles the controller-text and install it as instruction sequence
		machine)) ;; returns the modified machine model
		
;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 						REGISTERS
(define (make-register name) 
	(let ((contents '*unassigned*)) ;; initializes the register's content
		(define (dispatch message)
			(cond 	((eq? message 'get) contents)
				((eq? message 'set) (lambda (value) (set! contents value)))
				(else
					(error "Unknown request -- REGISTER" message))))
		dispatch))
		
;; Procedures used to access registers, syntatic sugar
(define (get-contents register)
	(register 'get))
	
(define (set-contents! register value)
	((register 'set) value))
	
;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 							STACK
(define (make-stack)
	(let 	((s '())
		(number-pushes 0)
		(max-depth 0)
		(current-depth 0))
		
		(define (push x)
			(set! s (cons x s))
			(set! number-pushes (+ 1 number-pushes))
			(set! current-depth (+ 1 current-depth))
			(set! max-depth (max current-depth max-depth)))
		(define (pop)
			(if (null? s)
				(error "Empty stack -- POP")
				(let ((top (car s)))
					(set! s (cdr s))
					(set! current-depth (- current-depth 1))
					top)))
		(define (initialize)
			(set! s '())
			(set! number-pushes 0)
			(set! max-depth 0)
			(set! current-depth 0)
			'done)
		(define (print-statistics)
			(newline)
			(display (list 'total-pushes '= number-pushes
					'maximum-depth '= max-depth)))
		(define (dispatch message)
			(cond	((eq? message 'push) push)
				((eq? message 'pop) (pop))
				((eq? message 'initialize) (initialize))
				((eq? message 'print-statistics) (print-statistics))
				(else (error "Unknown request -- STACK" message))))
		dispatch))
		
;; Procedures used to access stacks, syntatic sugar
(define (pop stack)
	(stack 'pop))

(define (push stack value)
	((stack 'push) value))
	

;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 					THE BASIC MACHINE
(define (make-new-machine)
	(let 	((pc (make-register 'pc))
		(flag (make-register 'flag))
		(stack (make-stack))
		(the-instruction-sequence '()))
		
		(let 	((the-ops
				(list (list 	'initialize-stack
						(lambda () (stack 'initialize)))))
			(register-table
				(list (list 'pc pc) (list 'flag flag))))
				
			(define (allocate-register name)
				(if (assoc name register-table)
					(error "Multiply defined register: " name)
					(set! register-table
						(cons (list name (make-register name))
							register-table)))
				'register-allocated)
				
			(define (lookup-register name)
				(let ((val (assoc name register-table)))
					(if val
						(cadr val)
;;													** PLACE WHERE I CHANGED TO COMPLETE THIS EXERCISE
						(begin
							(allocate-register name)
							(lookup-register name)))))
										
			(define (execute)
				(let ((insts (get-contents pc)))
					(if (null? insts)
						'done
						(begin
							((instruction-execution-proc (car insts)))
							(execute)))))
							
			(define (dispatch message)
				(cond 	((eq? message 'start)
						(set-contents! pc the-instruction-sequence)
						(execute))
					((eq? message 'install-instruction-sequence)
						(lambda (seq) (set! the-instruction-sequence seq)))
					((eq? message 'allocate-register) allocate-register)
					((eq? message 'get-register) lookup-register)
					((eq? message 'check-register) check-register)
					((eq? message 'install-operations)
						(lambda (ops) (set! the-ops (append the-ops ops))))
					((eq? message 'stack) stack)
					((eq? message 'operations) the-ops)
					(else (error "Unknown request -- MACHINE" message))))
			dispatch)))
		
;; Procedures to interface with the machine and some syntatic sugar	
(define (start machine)
	(machine 'start))
	
(define (get-register-contents machine register-name)
	(get-contents (get-register machine register-name)))
	
(define (set-register-contents! machine register-name value)
	(set-contents! (get-register machine register-name) value)
	'done)
	
(define (get-register machine reg-name)
	((machine 'get-register) reg-name))
	
;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 						ASSEMBLER
;;	transforms the sequence of controller expressions 
;; 	for a machine into a corresponding list of machine
;;	instructions, each with its execution procedure

(define (assemble controller-text machine) ;; returns the instruction sequence to be stored in the machine model
	(extract-labels controller-text ;; extract-labels
		(lambda (insts labels)
			(update-insts! insts labels machine) ;; generates the instruction execution procedures
			insts))) ;; returns the modified list
			
(define (extract-labels text receive)  ;; returns the initial instruction list and label table
;; text = sequence of controller instruction expressions
;; receive is a procedure called with two values, a list "insts" of instruction data structures,
;; each containg an instruction from "text", and a table called "labels", which associates
;; each label from "text" with the position in the list "insts" that the label designates.
	(if (null? text)
		(receive '() '())
		(extract-labels (cdr text) ;; sequentially scans the elements of "text" 
			(lambda (insts labels)
				(let ((next-inst (car text)))
					(if (symbol? next-inst) ;; if the element is a symbol, it is a label, otherwise it is an instruction
						(receive insts
							(cons (make-label-entry next-inst insts) labels))
						(receive (cons (make-instruction next-inst) insts)
							labels)))))))
							
(define (update-insts! insts labels machine) 
;; modifies the instruction list "insts", which initially contains only the text of the instructions
;; to include the corresponding execution procedure
	(let 	((pc (get-register machine 'pc))
		(flag (get-register machine 'flag))
		(stack (machine 'stack))
		(ops (machine 'operations)))
		
		(for-each
			(lambda (inst)
				(set-instruction-execution-proc!
					inst
					(make-execution-procedure
						(instruction-text inst) labels machine
						pc flag stack ops)))
			insts)))
			
;; Instruction and labels data structures contructors and selectors
(define (make-instruction text) ;; Data structure: pairs the instruction text with the corresponding execution procedure
	(cons text '()))
	
(define (instruction-text inst)
	(car inst))
	
(define (instruction-execution-proc inst)
	(cdr inst))
	
(define (set-instruction-execution-proc! inst proc)
	(set-cdr! inst proc))
	
(define (make-label-entry label-name insts);; Data structure: elements of the label table are pairs
	(cons label-name insts))
	
(define (lookup-label labels label-name) ;; how entries are looked up in the table
	(let ((val (assoc label-name labels)))
		(if val
			(cdr val)
			(error "Undefined label -- ASSEMBLE" label-name))))

;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 			GENERATING EXECUTION PROCEDURES
;; 	for each type of machine-register instruction
;;	it creates a corresponding execution procedure
(define (make-execution-procedure inst labels machine pc flag stack ops)
	(cond 	((eq? (car inst) 'assign)
			(make-assign inst machine labels ops pc))
		((eq? (car inst) 'test)
			(make-test inst machine labels ops flag pc))
		((eq? (car inst) 'branch)
			(make-branch inst machine labels flag pc))
		((eq? (car inst) 'goto)
			(make-goto inst machine labels pc))
		((eq? (car inst) 'save)
			(make-save inst machine stack pc))
		((eq? (car inst) 'restore)
			(make-restore inst machine stack pc))
		((eq? (car inst) 'perform)
			(make-perform inst machine labels ops pc))
		(else (error "Unknown instruction type -- ASSEMBLE" inst))))
		
;; assign
(define (make-assign inst machine labels operations pc)
	(let 	((target (get-register machine (assign-reg-name inst)))
		(value-exp (assign-value-exp inst)))
		
		(let ((value-proc
			(if (operation-exp? value-exp)
				(make-operation-exp value-exp machine labels operations)
				(make-primitive-exp  (car value-exp) machine labels))))
			(lambda () ;; execution procedure for assign
				(set-contents! target (value-proc))
				(advance-pc pc)))))
				
(define (assign-reg-name assign-instruction)
	(cadr assign-instruction))
	
(define (assign-value-exp assign-instruction)
	(cddr assign-instruction))
	
;; test
(define (make-test inst machine labels operations flag pc)
	(let ((condition (test-condition inst)))
		(if (operation-exp? condition)
			(let ((condition-proc (make-operation-exp condition machine labels operations)))
				(lambda ()
					(set-contents! flag (condition-proc))
					(advance-pc pc)))
			(error "Bad TEST instruction -- ASSEMBLE" inst))))
			
(define (test-condition test-instruction)
	(cdr test-instruction))
	
;; branch
(define (make-branch inst machine labels flag pc)
	(let ((dest (branch-dest inst)))
		(if (label-exp? dest)
			(let ((insts (lookup-label labels (label-exp-label dest))))
				(lambda ()
					(if (get-contents flag)
						(set-contents! pc insts)
						(advance-pc pc))))
			(error "Bad BRANCH instruction -- ASSEMBLE" inst))))
			
(define (branch-dest branch-instruction)
	(cadr branch-instruction))
	
(define (make-goto inst machine labels pc)
	(let ((dest (goto-dest inst)))
		(cond 	((label-exp? dest)
				(let ((insts (lookup-label labels (label-exp-label dest))))
					(lambda () (set-contents! pc insts))))
			((register-exp? dest)
				(let ((reg (get-register machine (register-exp-reg dest))))
					(lambda () (set-contents! pc (get-contents reg)))))
			(else (error "Bad GOTO instruction -- ASSEMBLE" inst)))))
			
(define (goto-dest goto-instruction)
	(cadr goto-instruction))
	

;; save
(define (make-save inst machine stack pc)
	(let ((reg (get-register machine (stack-inst-reg-name inst))))
		(lambda ()
			(push stack (get-contents reg))
			(advance-pc pc))))
			
;; restore
(define (make-restore inst machine stack pc)
	(let ((reg (get-register machine (stack-inst-reg-name inst))))
		(lambda ()
			(set-contents! reg (pop stack))
			(advance-pc pc))))
			
(define (stack-inst-reg-name stack-instruction)
	(cadr stack-instruction))
	
;; perform
(define (make-perform inst machine labels operations pc)
	(let ((action (perform-action inst)))
		(if (operation-exp? action)
			(let 	((action-proc
				(make-operation-exp action machine labels operations)))
				
				(lambda ()
					(action-proc)
					(advance-pc pc)))
			(error "Bad PERFORM instruction -- ASSEMBLE" inst))))
			
(define (perform-action inst) (cdr inst))
				
;; Procedure to advance pc register
(define (advance-pc pc)
	(set-contents! pc (cdr (get-contents pc))))
	
	

;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 		EXECUTION PROCEDURES FOR SUBEXPRESSIONS

;; for primitive expressions
(define (make-primitive-exp exp machine labels)
	(cond 	((constant-exp? exp)
			(let ((c (constant-exp-value exp)))
				(lambda () c)))
		((label-exp? exp)
			(let ((insts (lookup-label labels (label-exp-label exp))))
				(lambda () insts)))
		((register-exp? exp)
			(let ((r (get-register machine (register-exp-reg exp))))
				(lambda () (get-contents r))))
		(else
			(error "Unknown expression type -- ASSEMBLE" exp))))
			
;; Selectors for reg, label and const expressions
(define (register-exp? exp) (tagged-list? exp 'reg))

(define (register-exp-reg exp) (cadr exp))

(define (constant-exp? exp) (tagged-list? exp 'const))

(define (constant-exp-value exp) (cadr exp))

(define (label-exp? exp) (tagged-list? exp 'label))

(define (label-exp-label exp) (cadr exp))


(define (tagged-list? exp tag)
	(if (pair? exp)
		(eq? (car exp) tag)
		false))

;; for operation expressions
(define (make-operation-exp exp machine labels operations)
	(let 	((op (lookup-prim (operation-exp-op exp) operations))
		(aprocs (map (lambda (e)
				(make-primitive-exp e machine labels))
				(operation-exp-operands exp))))
		
		(lambda ()
			(apply op (map (lambda (p) (p)) aprocs)))))
			
;; Syntax of operation expressions
(define (operation-exp? exp)
	(and (pair? exp) (tagged-list? (car exp) 'op)))
	
(define (operation-exp-op operation-exp)
	(cadr (car operation-exp)))

(define (operation-exp-operands operation-exp)
	(cdr operation-exp))
	
;; Procedure to lookup operation name and return the procedure
(define (lookup-prim symbol operations)
	(let ((val (assoc symbol operations)))
		(if val
			(cadr val)
			(error "Unknown operation -- ASSEMBLE" symbol))))


































							
