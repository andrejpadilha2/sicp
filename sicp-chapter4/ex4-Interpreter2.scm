;;First interpreter of Chapter 4 - SICP - Variaton of analyze -> eval -> apply
;; to run this evaluator just load this file in scheme and run "(driver-loop)"

;;the main idea of this INTERPRETER is that we can analyze the expressions (and not bother with the environments in a first moment) as deep as it is possible, before we actually RUN the program (that is, we analyze at analysis time)....once the program runs, we execute the ANALYZED expressions and just substitutes the values of variables to get the final result..the analyzed expressions are SAVED and will only be analysis ONCE (this is done with "let")

;; remember that a "let" is a lambda+a call to this same lambda...so when we analyze the expression and put the result in a "let", the "let" creates an environment which BINDS the value of the analyzed expression to a given variable name (doesn't matter the name)...this way it's saved

;; what we are actually writing is a COMPILER! But it doesn't compile Scheme -> machine language...it compiles (Metacircular) Scheme -> Scheme, but in a way that we extract the analyzed code of the original expressions

;;(load "ex4-Interpreter-Data-Structures-Syntax-ScanOutDefines.scm")
(load "ex4-Interpreter-Data-Structures-Syntax.scm")

;;core of the evaluate, EVAL (now it's split into eval+analyze) / APPLY (now we call it execute-application)
(define (eval exp env)
	((analyze exp) env))

(define (analyze exp)
	(cond   ((self-evaluating? exp) (analyze-self-evaluating exp))
		((variable? exp) (analyze-variable exp))
		((quoted? exp) (analyze-quoted exp)) ;; special case
		((assignment? exp) (analyze-assignment exp)) ;; special case
		((definition? exp) (analyze-definition exp)) ;; special case
		((let? exp) (analyze (let->combination exp))) ;; special case
		((let*? exp) (analyze (let*->nested-lets exp))) ;; special case
		((if? exp) (analyze-if exp)) ;; special cases
		((lambda? exp) (analyze-lambda exp)) ;; special case
		((begin? exp) (analyze-sequence (begin-actions exp))) ;; special case
		((cond? exp) (analyze (cond->if exp))) ;; special case
		((application? exp) (analyze-application exp))                     ;; expression aplication
		(else (error "Unknown expression type -- EVAL" exp))))

(define (execute-application proc args)
	(cond 	((primitive-procedure? proc)
			(apply-primitive-procedure proc args))
		((compound-procedure? proc)
			((procedure-body proc)
				(extend-environment (procedure-parameters proc)
					args
					(procedure-environment proc))))
		(else (error "Unknown procedure type -- EXECUTE-APPLICATION" proc))))

(define (analyze-self-evaluating exp)
	(lambda (env) exp))
	
(define (analyze-quoted exp)
	(let ((qval (text-of-quotation exp)))	;; effectively, this let is done in the underlying Lisp, so it SAVES the value of qval, and it doesn't need to interpreted every time we call that quotation...it's already there, already analyzed...it takes the (text-of-quotation exp) out of execution time and put it in analysis time
		(lambda (env) qval)))
		
(define (analyze-variable exp)
	(lambda (env) (lookup-variable-value exp env)))
	
(define (analyze-assignment exp) ;; (set! var value)
	(let 	((var (assignment-variable exp))
		(vproc (analyze (assignment-value exp)))) ;; say "(assignment-value exp)" is a big complicated expression....this way, it will be analyzed only ONCE...every time we call "(set! var value)", "var" will already be analyzed as well as "value" (the big complicated expression)...all it is left to do is to evaluate the expression in the current environment for each time (set! var value) is called....this is done in the next few lines of code
			(lambda (env)
				(set-variable-value! var (vproc env) env)
				'ok)))
				
(define (analyze-definition exp)
	(let 	((var (definition-variable exp))
		(vproc (analyze (definition-value exp))))
			(lambda (env)
				(define-variable! var (vproc env) env)
				'ok)))
				
(define (analyze-if exp)
	(let 	((pproc (analyze (if-predicate exp)))
		(cproc (analyze (if-consequent exp)))
		(aproc (analyze (if-alternative exp))))
			(lambda (env)
				(if (true? 	(pproc env))
						(cproc env)
						(aproc env)))))
						
(define (analyze-lambda exp) ;; (lambda <var> <body>)
	(let	((vars (lambda-parameters exp))
		(bproc (analyze-sequence (lambda-body exp)))) ;; this is the BIGGEST advantage of this interpreter... the list of expressions inside the lambda <body> will be analyzed ONLY ONCE! Even if our procedure is called several hundreds of time (say (fact 100) for example), it will only substitute the value of the arguments in each iteration, it won't need to analyze the whole procedure over and over again!! We don't store the text of the procedure <body>...all we store is the ANALYZED text of the procedure <body>
			(lambda (env) (make-procedure vars bproc env))))
			
(define (analyze-sequence exps)
	(define (sequentially proc1 proc2)
		(lambda (env) (proc1 env) (proc2 env)))
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
			(lambda (env)
				(execute-application (fproc env)
					(map (lambda (aproc) (aproc env))
						aprocs)))))
						

	
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
		


