;;First interpreter of Chapter 4 - SICP
;; to run this evaluator just load this file in scheme and run "(driver-loop)"

(load "ex4-Interpreter-Data-Structures-Syntax-ScanOutDefines.scm")
;;(load "ex4-Interpreter-Data-Structures-Syntax.scm")

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
			(apply (eval (operator exp) env)
				(list-of-values (operands exp) env)))
		(else (error "Unknown expression type -- EVAL" exp))))
			
(define (apply procedure arguments)
	(cond	((primitive-procedure? procedure)
			(apply-primitive-procedure procedure arguments))
		((compound-procedure? procedure)
			(eval-sequence
				(procedure-body procedure)
				(extend-environment
					(procedure-parameters procedure)
					arguments
					(procedure-environment procedure))))
		(else
			(error "Unknown procedure type -- APPLY" procedure))))
			

(define (list-of-values exps env)
	(if (no-operands? exps)
		'()
		(cons (eval (first-operand exps) env)
			(list-of-values (rest-operands exps) env))))
			
(define (eval-if exp env)
	(if (true? (eval (if-predicate exp) env))
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
(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

(define (driver-loop)
	(prompt-for-input input-prompt)
	(let ((input (read)))
		(let 	((output (eval input the-global-environment)))
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
		


