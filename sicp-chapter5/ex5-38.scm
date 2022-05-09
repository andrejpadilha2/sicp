;; constructing code generators that the procedure "compile" will dispatch for "open-coded primitives"

;; a)
;; example (+ a 1) -> is an open-coded primitive...operand list is (a 1), we should compile a, 1, targeted to successive argument register "arg1" and "arg2"...
;; since when compiling a or 1, there could be another open-coded primitive (say a = (+ b 2)), we should do so while preserving the argument registers

;;below is my original solution, where I got stuck
;;(define (spread-arguments arglist)
;;	(compile (car arglist) 'arg1 'next) ;; compile first element of arglist, targeted to arg1
;;	(preserving '(arg1)
;;		(make-instruction-sequence '(env) (list arg2)
;;			(compile (cadr arglist) 'arg2 'next))))
	
;; didn't really understand this exercise...so I am going to copy an answer for now, to make it run...the only thing really different is the last "make-instruction=sequence)" as I can see
(define (spread-arguments operands)
	(if (= 2 (length operands))     
		(preserving '(env)
			(compile (car operands) 'arg1 'next)
				(preserving '(arg1)
					(compile (cadr operands) 'arg2 'next)
					(make-instruction-sequence
					'(arg1) '() '())))
	(error "Spread-arguments expects 2 args -- COMPILE" operands)))
	
	
;; b)

;; for the primitive =
(define (primitive=? exp)
	(tagged-list? exp '=))

;;(define (compile-= exp target linkage)
;;	(end-with-linkage linkage	;; create an instruction that ends with the proper linkage
;;		(append-instruction-sequences		;; we will append spread-arguments with the primitive operation for "=" itself
;;			(spread-arguments (operands exp)) ;; first we spread the operands on the argument registers
;;			(make-instruction-sequence '(arg1 arg2) (list target)
;;				`(assign ,target (perform (op =) (reg arg1) (reg arg2)))))) ;; the instruction is the direct application of the operator "="
			

;; for the primitive +
(define (primitive+? exp)
	(tagged-list? exp '+))
	
;;(define (compile-+ exp target linkage)
;;	(end-with-linkage linkage	;; create an instruction that ends with the proper linkage
;;		(append-instruction-sequences		;; we will append spread-arguments with the primitive operation for "=" itself
;;			(spread-arguments (operands exp)) ;; first we spread the operands on the argument registers
;;			(make-instruction-sequence '(arg1 arg2) (list target)
;;				`(assign ,target (perform (op +) (reg arg1) (reg arg2)))))) ;; the instruction is the direct application of the operator "="
				
				
;; at this moment I notice that I will just repeat all of the code, just changing the operator inside (op ... ), so I can create a general procedure for that
	
(define (compile-2-args-primitive-operation operator operands target linkage)
	(end-with-linkage linkage	;; create an instruction that ends with the proper linkage
			(append-instruction-sequences		;; we will append spread-arguments with the primitive operation itself
				(spread-arguments operands) ;; first we spread the operands on the argument registers
				(make-instruction-sequence '(arg1 arg2) (list target)
					`((assign ,target (op ,operator) (reg arg1) (reg arg2))))))) ;; the instruction is the direct application of the proper primitive operator
					
;; for the primitive =
(define (compile-= exp target linkage)
	(compile-2-args-primitive-operation '= (operands exp) target linkage))
	
;; for the primitive +
(define (compile-+ exp target linkage)
	(compile-2-args-primitive-operation '+ (operands exp) target linkage))	
	
;; for the primitive -
(define (primitive-? exp)
	(tagged-list? exp '-))

(define (compile-- exp target linkage)
	(compile-2-args-primitive-operation '- (operands exp) target linkage))
	
;; for the primitive *
(define (primitive*? exp)
	(tagged-list? exp '*))
	
(define (compile-* exp target linkage)
	(compile-2-args-primitive-operation '* (operands exp) target linkage))
	


(define (compile exp target linkage)
	(cond 	((self-evaluating? exp)
			(compile-self-evaluating exp target linkage))
		((primitive=? exp)
			(compile-= exp target linkage))
		((primitive+? exp)
			(compile-+ exp target linkage))
		((primitive-? exp)
			(compile-- exp target linkage))
		((primitive*? exp)
			(compile-* exp target linkage))
		((quoted? exp)
			(compile-quoted exp target linkage))
		((variable? exp)
			(compile-variable exp target linkage))
		((assignment? exp)
			(compile-assignment exp target linkage))
		((definition? exp)
			(compile-definition exp target linkage))
		((if? exp)
			(compile-if exp target linkage))
		((lambda? exp)
			(compile-lambda exp target linkage))
		((begin? exp)
			(compile-sequence (begin-actions exp) target linkage))
		((cond? exp)
			(compile (cond->if exp) target linkage))
		((application? exp)
			(compile-application exp target linkage))
		(else
			(error "Unknown expression type -- COMPILE" exp))))
	

;; c) now we will compare the result of this new compiler with the result of ex5-33.scm (that used the vanilla compiler)
((env) (val)
(
(assign val (op make-compiled-procedure) (label entry2) (reg env))
(goto (label after-lambda1))

entry2
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (n)) (reg argl) (reg env))
(assign arg1 (op lookup-variable-value) (const n) (reg env))
(assign arg2 (const 1))
(assign val (perform (op =) (reg arg1) (reg arg2)))
(test (op false?) (reg val))
(branch (label false-branch4))

true-branch5
(assign val (const 1)) (goto (reg continue))

false-branch4
(save continue)
(save env)
(assign proc (op lookup-variable-value) (const factorial) (reg env))
(assign arg1 (op lookup-variable-value) (const n) (reg env))
(assign arg2 (const 1))
(assign val (perform (op -) (reg arg1) (reg arg2)))
(assign argl (op list) (reg val))
(test (op primitive-procedure?) (reg proc))
(branch (label primitive-branch8))

compiled-branch7
(assign continue (label proc-return9))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))

proc-return9
(assign arg1 (reg val))
(goto (label after-call6))

primitive-branch8
(assign arg1 (op apply-primitive-procedure) (reg proc) (reg argl))

after-call6
(restore env)
(assign arg2 (op lookup-variable-value) (const n) (reg env))
(assign val (perform (op *) (reg arg1) (reg arg2)))
(restore continue)
(goto (reg continue))

after-if3

after-lambda1
(perform (op define-variable!) (const factorial) (reg val) (reg env))
(assign val (const ok))))

;; This compiler generates 32 instructions...the vanilla compiler generates 62 instructions!!! Almost half the instructions....
;; This doesn't mean that the code will be twice as fast, since we know that some parts of the code generated with the vanilla compiler will never be visited...
;; but the choosing between a compiled procedure and primitive procedure will not happen anymore, making it faster...


;; d) SKIPPING THIS ONE FOR NOW
;; we will change "compile-+" and "compile-*" first to handle both cases
(define (compile-+ exp target linkage)				
	(if (> 2 (length (operands exp))) 
		(let*  ((operands-exp (operands exp))
			(first-two-operands (list (car operands-exp) (cadr operands-exp))) ;; arg1 and arg2
			(rest-operands (cddr operands-exp))) ;; all other operands, or "null" if arg2 is the last operand
			(if (last-operand? (cdr first-two-operands))
				(compile-2-args-primitive-operation '+ first-two-operands target linkage))) ;; if it is the last operand, perform the compilation with the correct target and linkage
				(append-instruction-sequences
					(compile-2-args-primitive-operation '+ first-two-operands 'arg1 'next))) ;; if it isn't the last operand, perform the compilation with "arg1" as target and next as linkage
					(assign arg2 (next-element))

			
		;; if there are more than 2 arguments the strategy is: compile the primitie procedure for the first 2 arguments normally, but save the rest of the arguments on 
		(compile-2-args-primitive-operation '+ exp target linkage)))	;; if there are only 2 arguments, directly apply the normal procedure
		


(define (spread-arguments operands)
	(if (= 2 (length operands))     
		(preserving '(env)
			(compile (car operands) 'arg1 'next)
				(preserving '(arg1)
					(compile (cadr operands) 'arg2 'next)
					(make-instruction-sequence
					'(arg1) '() '())))
	(error "Spread-arguments expects 2 args -- COMPILE" operands)))


























