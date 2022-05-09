;; in this exercise I am just going to rewrite "compile-variable" and "compile-assignment" so that is uses "find-variable"
(load "ex5-39.scm") ;; loading lexical address operations
(load "ex5-41.scm") ;; loading "find-variable" procedure

(load "ExplicitControlEvaluatorMachineSyntaxStructureOperations.scm") ;; Syntax Structure of the compiler and eceval are the same (naturally, since we are implementing the same language), so we can simply use the syntax structure file that we already used for eceval

(define (empty-compile-time-environment)
	(list '()))

(define compile-time-environment
	(empty-compile-time-environment))

(define (compile exp target linkage cte)
	(cond 	((self-evaluating? exp)
			(compile-self-evaluating exp target linkage))
		((quoted? exp)
			(compile-quoted exp target linkage))
		((variable? exp)
			(compile-variable exp target linkage cte))
		((assignment? exp)
			(compile-assignment exp target linkage cte))
		((definition? exp)
			(compile-definition exp target linkage cte))
		((if? exp)
			(compile-if exp target linkage cte))
		((lambda? exp)
			(compile-lambda exp target linkage cte))
		((begin? exp)
			(compile-sequence (begin-actions exp) target linkage cte))
		((cond? exp)
			(compile (cond->if exp) target linkage cte))
		((application? exp)
			(compile-application exp target linkage cte))
		(else
			(error "Unknown expression type -- COMPILE" exp))))
			

;; we associate with each instruction sequence some information about its register use
;; instruction -> (<set of registers needed> <set of registers modified> <the actual instruction>)
(define (make-instruction-sequence needs modifies statements)
	(list needs modifies statements))

(define (empty-instruction-sequence)
	(make-instruction-sequence '() '() '()))
	

;; *********************************************************
;; *********************************************************
;; *********************************************************
;;						LINKAGES
;;
;; 		DESCRIBES HOW THE CODE RESULTING
;;		FROM THE COMPILATION OF THE EXPRESSION
;;		SHOULD PROCEED WHEN IT HAS FINISHED ITS
;;		EXECUTION
(define (compile-linkage linkage)
	(cond	((eq? linkage 'return)					;; if it should return the value, then it should continue from where it stopped
			(make-instruction-sequence '(continue) '() 
				'((goto (reg continue)))))		
		((eq? linkage 'next)					;; if it should go to the next instruction, simply does nothing (e.g. empty instruction)
			(empty-instruction-sequence))
		(else							;; if it should go to a specified entry, go to the label indicated
			(make-instruction-sequence '() '() 
				`((goto (label ,linkage)))))))
			
(define (end-with-linkage linkage instruction-sequence)		;; creates an instruction sequence with the indicated linkage
	(preserving '(continue)					;; should preserve "continue" because "instruction-sequence" might change its value
		instruction-sequence
		(compile-linkage linkage)))


;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 				COMPILING SIMPLE EXPRESSIONS
(define (compile-self-evaluating exp target linkage)
	(end-with-linkage linkage
		(make-instruction-sequence '() (list target)
			`((assign ,target (const ,exp))))))
			
(define (compile-quoted exp target linkage)
	(end-with-linkage linkage
		(make-instruction-sequence '() (list target)
			`((assign ,target (const ,(text-of-quotation exp)))))))
			
(define (compile-variable exp target linkage cte)				;; *** MAIN CHANGE IN THIS EXERCISE ***
	(let ((variable-address (find-variable exp cte)))
		(if (eq? variable-address 'not-found)
			(end-with-linkage linkage
				(append-instruction-sequences
					;;save env?
					(make-instruction-sequence '(env) '(env)
						'((assign env (op get-global-environment) (reg env)))) ;; if the address is not found, the variable can still be in the global environment, because it's accessible only on run-time, not on compilation time...so on run time we will need to look it up
					(make-instruction-sequence '(env) (list target)
						`((assign ,target (op lookup-variable-value) (const ,exp) (reg env))))))
					;;restore env?
			(end-with-linkage linkage
				(make-instruction-sequence '(env) (list target)
					`((assign ,target (op lexical-address-lookup) (const ,variable-address) (reg env))))))))
	
	
			
;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 		COMPILING ASSIGNMENTS AND DEFINITIONS
(define (compile-assignment exp target linkage cte)				;; *** MAIN CHANGE IN THIS EXERCISE ***
	(let* 	((var (assignment-variable exp))
		(variable-address (find-variable var cte))
		(get-value-code (compile (assignment-value exp) 'val 'next cte)))
		(if (eq? variable-address 'not-found)
			(end-with-linkage linkage
				(append-instruction-sequences
					;;save env?
					(make-instruction-sequence '(env) '(env)
						'((assign env (op get-global-environment) (reg env))))
					(preserving '(env)
						get-value-code
						(make-instruction-sequence '(env val) (list target)
							`((perform (op set-variable-value!) (const ,var) (reg val) (reg env))
							  (assign ,target (const ok)))))))
					;;restore env?
			(end-with-linkage linkage
				(preserving '(env)
					get-value-code
					(make-instruction-sequence '(env val) (list target)
						`((perform (op lexical-address-set!) (const ,variable-address) (reg val) (reg env))
						  (assign ,target (const ok)))))))))
						  
(define (compile-definition exp target linkage cte)
	(let 	((var (definition-variable exp))
		(get-value-code (compile (definition-value exp) 'val 'next cte)))
			(end-with-linkage linkage
				(preserving '(env)
					get-value-code
					(make-instruction-sequence '(env val) (list target)
						`((perform (op define-variable!) (const ,var) (reg val) (reg env))
						  (assign ,target (const ok))))))))
						  
;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 				COMPILING CONDITIONALS - IF
(define (compile-if exp target linkage cte)
	(let	((t-branch (make-label 'true-branch))
		(f-branch (make-label 'false-branch))
		(after-if (make-label 'after-if)))
			(let ((consequent-linkage (if (eq? linkage 'next) after-if linkage)))
				(let 	((p-code (compile (if-predicate exp) 'val 'next cte))
					(c-code (compile (if-consequent exp) target consequent-linkage cte))
					(a-code (compile (if-alternative exp) target linkage cte)))
						(preserving '(env continue)
							p-code
							(append-instruction-sequences
								(make-instruction-sequence '(val) '()
									`((test (op false?) (reg val))
									  (branch (label ,f-branch))))
								(parallel-instruction-sequences
									(append-instruction-sequences t-branch c-code)
									(append-instruction-sequences f-branch a-code))
								after-if))))))

;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 					COMPILING SEQUENCES
(define (compile-sequence seq target linkage cte)
	(if (last-exp? seq)
		(compile (first-exp seq) target linkage cte)
		(preserving '(env continue)
			(compile (first-exp seq) target 'next cte)
			(compile-sequence (rest-exps seq) target linkage cte))))
			
;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 					COMPILING LAMBDA
(define (compile-lambda exp target linkage cte)
	(let 	((proc-entry (make-label 'entry))
		(after-lambda (make-label 'after-lambda)))
			(let	((lambda-linkage (if (eq? linkage 'next) after-lambda linkage)))
					(append-instruction-sequences
						(tack-on-instruction-sequence
							(end-with-linkage lambda-linkage
								(make-instruction-sequence '(env) (list target)
									`((assign ,target (op make-compiled-procedure) (label ,proc-entry) (reg env)))))
							(compile-lambda-body exp proc-entry cte))
						after-lambda))))
						
(define (compile-lambda-body exp proc-entry cte)
	(let	((formals (lambda-parameters exp)))
			(append-instruction-sequences
				(make-instruction-sequence '(env proc argl) '(env)
					`(,proc-entry
					 (assign env (op compiled-procedure-env) (reg proc))
					 (assign env (op extend-environment) (const ,formals) (reg argl) (reg env))))
				(compile-sequence (lambda-body exp) 'val 'return (cons formals cte))))) 			;; *** MAIN DIFFERENCE IS HERE ***
				
;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 	COMPILING COMBINATIONS (PROCEDURE APPLICATIONS)
(define (compile-application exp target linkage cte)
	(let	((proc-code (compile (operator exp) 'proc 'next cte))
		(operand-codes (map (lambda (operand) (compile operand 'val 'next cte))
					(operands exp))))
			(preserving '(env continue)
				proc-code
				(preserving '(proc continue)
					(construct-arglist operand-codes)
					(compile-procedure-call target linkage)))))
					
(define (construct-arglist operand-codes)
	(let ((operand-codes (reverse operand-codes)))
		(if (null? operand-codes)
			(make-instruction-sequence '() '(argl)
				'((assign argl (const ()))))
			(let ((code-to-get-last-arg
				(append-instruction-sequences
					(car operand-codes)
					(make-instruction-sequence '(val) '(argl)
						'((assign argl (op list) (reg val)))))))
				(if (null? (cdr operand-codes))
					code-to-get-last-arg
					(preserving '(env)
						code-to-get-last-arg
						(code-to-get-rest-args (cdr operand-codes))))))))
						
(define (code-to-get-rest-args operand-codes)
	(let ((code-for-next-arg
		(preserving '(argl)
			(car operand-codes)
			(make-instruction-sequence '(val argl) '(argl)
				'((assign argl (op cons) (reg val) (reg argl)))))))
		(if (null? (cdr operand-codes))
			code-for-next-arg
			(preserving '(env)
				code-for-next-arg
				(code-to-get-rest-args (cdr operand-codes))))))
				
;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 					APPLYING PROCEDURES
(define (compile-procedure-call target linkage)
	(let 	((primitive-branch (make-label 'primitive-branch))
		(compiled-branch (make-label 'compiled-branch))
		(after-call (make-label 'after-call)))
			(let ((compiled-linkage (if (eq? linkage 'next) after-call linkage)))
				(append-instruction-sequences
					(make-instruction-sequence '(proc) '()
						`((test (op primitive-procedure?) (reg proc))
						  (branch (label ,primitive-branch))))
					(parallel-instruction-sequences
						(append-instruction-sequences
							compiled-branch
							(compile-proc-appl target compiled-linkage))
						(append-instruction-sequences
							primitive-branch
							(end-with-linkage linkage
								(make-instruction-sequence '(proc argl) (list target)
									`((assign ,target (op apply-primitive-procedure) (reg proc) (reg argl)))))))
					after-call))))
					
(define (compile-proc-appl target linkage)
	(cond 	((and (eq? target 'val) (not (eq? linkage 'return)))
			(make-instruction-sequence '(proc) all-regs
				`((assign continue (label ,linkage))
				  (assign val (op compiled-procedure-entry) (reg proc))
				  (goto (reg val)))))
		((and (not (eq? target 'val)) (not (eq? linkage 'return)))
			(let ((proc-return (make-label 'proc-return)))
				(make-instruction-sequence '(proc) all-regs
					`((assign continue (label ,proc-return))
					  (assign val (op compiled-procedure-entry) (reg proc))
					  (goto (reg val))
					  ,proc-return
					  (assign ,target (reg val))
					  (goto (label ,linkage))))))
		((and (eq? target 'val) (eq? linkage 'return))
			(make-instruction-sequence '(proc continue) all-regs
				'((assign val (op compiled-procedure-entry) (reg proc))
				  (goto (reg val)))))
		((and (not (eq? target 'val)) (eq? linkage 'return))
			(error "return linkage, target not val -- COMPILE" target))))
			

		
		
;; *********************************************************
;; *********************************************************
;; *********************************************************
;; 		INSTRUCTION SEQUENCES REPRESENTATION
;;		AND HOW THEY ARE COMBINED
(define (registers-needed s)
	(if (symbol? s) '() (car s)))
	
(define (registers-modified s)
	(if (symbol? s) '() (cadr s)))

(define (statements s)
	(if (symbol? s) (list s) (caddr s)))
	
(define (needs-register? seq reg)
	(memq reg (registers-needed seq)))
	
(define (modifies-register? seq reg)
	(memq reg (registers-modified seq)))
	
(define (append-instruction-sequences . seqs)
	(define (append-2-sequences seq1 seq2)
		(make-instruction-sequence
			(list-union 	(registers-needed seq1)
					(list-difference 	(registers-needed seq2)
								(registers-modified seq1)))
			(list-union	(registers-modified seq1)
					(registers-modified seq2))
			(append (statements seq1) (statements seq2))))
	(define (append-seq-list seqs)
		(if (null? seqs)
			(empty-instruction-sequence)
			(append-2-sequences (car seqs) (append-seq-list (cdr seqs)))))
	(append-seq-list seqs))

(define (list-union s1 s2)
	(cond 	((null? s1) s2)
		((memq (car s1) s2) (list-union (cdr s1) s2))
		(else (cons (car s1) (list-union (cdr s1) s2)))))
		
(define (list-difference s1 s2)
	(cond	((null? s1) '())
		((memq (car s1) s2) (list-difference (cdr s1) s2))
		(else (cons (car s1) (list-difference (cdr s1) s2)))))
		
(define (preserving regs seq1 seq2)
	(if (null? regs)
		(append-instruction-sequences seq1 seq2)
		(let ((first-reg (car regs)))
			(if (and (needs-register? seq2 first-reg) (modifies-register? seq1 first-reg))
				(preserving (cdr regs)
					(make-instruction-sequence
						(list-union (list first-reg) (registers-needed seq1))
						(list-difference (registers-modified seq1) (list first-reg))
						(append `((save ,first-reg))
							  (statements seq1)
							`((restore ,first-reg))))
					seq2)
				(preserving (cdr regs) seq1 seq2)))))
				
(define (tack-on-instruction-sequence seq body-seq)
	(make-instruction-sequence
		(registers-needed seq)
		(registers-modified seq)
		(append (statements seq) (statements body-seq))))
		
(define (parallel-instruction-sequences seq1 seq2)
	(make-instruction-sequence
		(list-union (registers-needed seq1) (registers-needed seq2))
		(list-union (registers-modified seq1) (registers-modified seq2))
		(append (statements seq1) (statements seq2))))
					
	
	

;; Creates numbered labels so that labels don't repeat throughout the program (used when 
(define label-counter 0)

(define (new-label-number)
	(set! label-counter (+ 1 label-counter))
	label-counter)
	
(define (make-label name)
	(string->symbol
		(string-append (symbol->string name) (number->string (new-label-number)))))

	
	
;; Data structure for representing compiled procedures					
(define (make-compiled-procedure entry env)
	(list 'compiled-procedure entry env))
	
(define (compiled-procedure? proc)
	(tagged-list? proc 'compiled-procedure))

(define (compiled-procedure-entry c-proc) (cadr c-proc))

(define (compiled-procedure-env c-proc) (caddr c-proc))	



				
					
(define all-regs '(env proc val argl continue))

		
		
'(COMPILER LOADED)		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
