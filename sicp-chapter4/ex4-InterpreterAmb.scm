;;First interpreter of Chapter 4 - SICP - Variaton of analyze -> eval -> apply
;; to run this evaluator just load this file in scheme and run "(driver-loop)"

;;the main idea of this INTERPRETER is that we can analyze the expressions (and not bother with the environments in a first moment) as deep as it is possible, before we actually RUN the program (that is, we analyze at analysis time)....once the program runs, we execute the ANALYZED expressions and just substitutes the values of variables to get the final result..the analyzed expressions are SAVED and will only be analysis ONCE (this is done with "let")

;; remember that a "let" is a lambda+a call to this same lambda...so when we analyze the expression and put the result in a "let", the "let" creates an environment which BINDS the value of the analyzed expression to a given variable name (doesn't matter the name)...this way it's saved

;; what we are actually writing is a COMPILER! But it doesn't compile Scheme -> machine language...it compiles (Metacircular) Scheme -> Scheme, but in a way that we extract the analyzed code of the original expressions

;;(load "ex4-Interpreter-Data-Structures-Syntax-ScanOutDefines.scm")
(load "ex4-Interpreter-Data-Structures-Syntax.scm")

(load "ex4-InterpreterAmb-Structure.scm")

;;core of the evaluate, EVAL (now it's split into eval+analyze) / APPLY (now we call it execute-application)
(define (ambeval exp env succeed fail)
	((analyze exp) env succeed fail))

(define (analyze exp)
	(cond   ((self-evaluating? exp) (analyze-self-evaluating exp))
		((variable? exp) (analyze-variable exp))
		((quoted? exp) (analyze-quoted exp)) ;; special case
		((assignment? exp) (analyze-assignment exp)) ;; special case
		((definition? exp) (analyze-definition exp)) ;; special case
		((let? exp) (analyze (let->combination exp))) ;; special case
		((let*? exp) (analyze (let*->nested-lets exp))) ;; special case
		((amb? exp) (analyze-amb exp)) ;; special case
		((if? exp) (analyze-if exp)) ;; special cases
		((lambda? exp) (analyze-lambda exp)) ;; special case
		((begin? exp) (analyze-sequence (begin-actions exp))) ;; special case
		((cond? exp) (analyze (cond->if exp))) ;; special case
		((application? exp) (analyze-application exp))                     ;; expression aplication
		(else (error "Unknown expression type -- EVAL" exp))))

(define (execute-application proc args succeed fail)
	(cond 	((primitive-procedure? proc)
			(succeed (apply-primitive-procedure proc args) fail))
		((compound-procedure? proc)
			((procedure-body proc)
				(extend-environment (procedure-parameters proc)
					args
					(procedure-environment proc))
			succeed
			fail))
		(else (error "Unknown procedure type -- EXECUTE-APPLICATION" proc))))
		
(define (analyze-amb exp)
	(let ((cprocs (map analyze (amb-choices exp))))
		(lambda (env succeed fail)
			(define (try-next choices)
				(if (null? choices)
					(fail)
					((car choices) env succeed
						(lambda ()
							(try-next (cdr choices))))))
			(try-next cprocs))))

(define (analyze-self-evaluating exp)
	(lambda (env succeed fail) 
		(succeed exp fail)))
	
(define (analyze-quoted exp)
	(let ((qval (text-of-quotation exp)))
		(lambda (env succeed fail)
			(succeed qval fail))))

		
(define (analyze-variable exp)
	(lambda (env succeed fail) 
		(succeed (lookup-variable-value exp env) fail)))
	
(define (analyze-assignment exp) ;; (set! var value)
	(let 	((var (assignment-variable exp))
		(vproc (analyze (assignment-value exp)))) 
			(lambda (env succed fail)
				(vproc env
					(lambda (val fail2)
						(let ((old-value
							(lookup-variable-value var env)))
							(set-variable-value! var val env)
							(succeed 'ok
								(lambda ()
									(set-variable-value! var old-value env)
								(fail2)))))
					fail))))
				
(define (analyze-definition exp)
	(let 	((var (definition-variable exp))
		(vproc (analyze (definition-value exp))))
			(lambda (env succeed fail)
				(vproc env
					(lambda (val fail2)
						(define-variable! var val env)
						(succeed 'ok fail2))
					fail))))

(define (analyze-if exp)
	(let 	((pproc (analyze (if-predicate exp)))
		(cproc (analyze (if-consequent exp)))
		(aproc (analyze (if-alternative exp))))
			(lambda (env succeed fail)
				(pproc env
					(lambda (pred-value fail2)
						(if (true? pred-value)
							(cproc env succeed fail2)
							(aproc env sicceed fail2)))
							fail))))
						
(define (analyze-lambda exp) ;; (lambda <var> <body>)
	(let	((vars (lambda-parameters exp))
		(bproc (analyze-sequence (lambda-body exp))))
			(lambda (env succeed fail) 
				(succeed (make-procedure vars bproc env) fail))))
			
(define (analyze-sequence exps)
	(define (sequentially a b)
		(lambda (env succeed fail)
			(a env
				(lambda (a-value fail2)
					(b env succeed fail2))
				fail)))
	(define (loop first-proc rest-procs)
		(if (null? rest-procs)
			first-proc
			(loop 	(sequentially first-proc (car rest-procs))
				(cdr rest-procs))))
	(let ((procs (map analyze exps)))
		(if (null? procs)
			(error "Empty sequence -- ANALYZE!"))
		(loop (car procs) (cdr procs))))
		
(define (analyze-application exp)
	(let 	((fproc (analyze (operator exp)))
		(aprocs (map analyze (operands exp))))
			(lambda (env succeed fail)
				(fproc env
					(lambda (proc fail2)
						(get-args aprocs env
							(lambda (args fail3)
								(execute-application proc args succeed fail3))
							fail2))
					fail))))

(define (get-args aprocs env succeed fail)
	(if (null? aprocs)
		(succeed '() fail)
		((car aprocs) env
			(lambda (arg fail2)
				(get-args (cdr aprocs)
					env
					(lambda (args fail3)
						(succeed (cons arg args)
							fail3))
					fail2))
			fail)))
	
;; RUNNING THE INTERPRETER
(define input-prompt ";;; Amb-Eval input:")
(define output-prompt ";;; Amb-Eval value:")

(define (driver-loop)
	(define (internal-loop try-again)
		(prompt-for-input input-prompt)
			(let ((input (read)))
				(if (eq? input 'try-again)
					(try-again)
					(begin
						(newline)
						(display ";;; Starting a new problem ")
						(ambeval input
							the-global-environment
							(lambda (val next-alternative)
								(announce-output output-prompt)
								(user-print val)
								(internal-loop next-alternative))
							(lambda ()
								(announce-output
									";;; There are no more values of")
								(user-print input)
								(driver-loop)))))))
	(internal-loop
		(lambda ()
			(newline)
			(display ";;; There is no current problem")
			(driver-loop))))
								
	
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
		


