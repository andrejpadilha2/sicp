;;Second interpreter of Chapter 4 - SICP - Lazy Evaluator
;; to run this evaluator just load this file in scheme and run "(driver-loop)"

;;(load "ex4-Interpreter-Data-Structures-Syntax-ScanOutDefines.scm")
(load "ex4-Interpreter-Data-Structures-Syntax.scm")

(load "ex4-InterpreterLazy-ThunkStructure.scm")

;;core of the evaluate, EVAL / APPLY
(define (eval exp env)
	(cond   ((self-evaluating? exp) exp)
		((variable? exp) (lookup-variable-value exp env))
		((quoted? exp) (text-of-quotation exp)) ;; special case
		((assignment? exp) (eval-assignment exp env)) ;; special case
		((definition? exp) (eval-definition exp env)) ;; special case
		((let? exp) (eval (let->combination exp) env)) ;; special case
		((let*? exp) (eval (let*->nested-lets exp) env)) ;; special case
		((if? exp) (eval-if exp env)) ;; special cases
		((lambda? exp) 
			(make-procedure (lambda-parameters exp)
					(lambda-body exp)
					env)) 			;; special case
		((begin? exp) 
			(eval-sequence (begin-actions exp) env)) ;; special case
		((cond? exp) (eval (cond->if exp) env)) ;; special case
		((application? exp)                            ;; expression aplication
			(apply (actual-value (operator exp) env) ;; every time we want the real value of an expression, we call "actual-value"
				(operands exp) ;; MAIN DIFFERENCE of the lazy evaluator! We don't call the apply procedure with the actual values resulting of the evaluation of the arguments (we did that with "list-of-values" in the first interpreter)...rather, we just call it with the expressions, not evaluating them
				env))
		(else (error "Unknown expression type -- EVAL" exp))))
			
(define (apply procedure arguments env)
	(cond	((primitive-procedure? procedure)
			(apply-primitive-procedure procedure (list-of-arg-values arguments env))) ;; also changed from "vanilla" interpreter
		((compound-procedure? procedure)
			(eval-sequence
				(procedure-body procedure)
				(extend-environment
					(procedure-parameters procedure)
					(list-of-delayed-args arguments env) ;; also changed from "vanilla" interpreter
					(procedure-environment procedure))))
		(else
			(error "Unknown procedure type -- APPLY" procedure))))
			
	
;; procedures necessary for lazy evaluation			
(define (actual-value exp env)
	(force-it (eval exp env)))
	
(define (list-of-arg-values exps env)
	(if (no-operands? exps)
		'()
		(cons (actual-value (first-operand exps) env)
			(list-of-arg-values (rest-operands exps) env))))
						
(define (list-of-delayed-args exps env)
	(if (no-operands? exps)
		'()
		(cons (delay-it (first-operand exps) env)
			(list-of-delayed-args (rest-operands exps) env))))	
			
;; EVAL PROCEDURES	
(define (eval-if exp env)
	(if (true? (actual-value (if-predicate exp) env)) ;; only change in the "eval" procedures
		(eval (if-consequent exp) env)
		(eval (if-alternative exp) env)))

(define (eval-sequence exps env)
	(cond ((last-exp? exps) (eval (first-exp exps) env))
		(else (eval (first-exp exps) env)
			(eval-sequence (rest-exps exps) env))))
			
(define (eval-assignment exp env)
	(set-variable-value! (assignment-variable exp)
				(eval (assignment-value exp) env)
				env)
	'ok)
	
(define (eval-definition exp env)
	(define-variable! (definition-variable exp)
				(eval (definition-value exp) env)
				env)
	'ok)
	
;; RUNNING THE INTERPRETER
(define input-prompt ";;; Lazy-Eval input:")
(define output-prompt ";;; Lazy-Eval value:")

(define (driver-loop)
	(prompt-for-input input-prompt)
	(let ((input (read)))
		(let 	((output (actual-value input the-global-environment)))
			(announce-output output-prompt)
			(user-print output)))
	(driver-loop))
	
(define (prompt-for-input string)
	(newline) (newline) (display string) (newline))
	
(define (announce-output string)
	(newline) (display string) (newline))
	
(define (user-print object)
	(if (compound-procedure? object)
		(display (list 'compound-procedure
				(procedure-parameters object)
				(procedure-body object)
				'<procedure-env>))
		(display object)))
		


