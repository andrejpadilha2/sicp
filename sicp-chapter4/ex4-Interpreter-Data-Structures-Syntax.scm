;; Specification of the syntax of the language
(define (self-evaluating? exp)
	(cond ((number? exp) true)
		((string? exp) true)
		(else false)))
		
(define (variable? exp) (symbol? exp))

(define (tagged-list? exp tag)
	(if (pair? exp)
		(eq? (car exp) tag)
		false))

(define (quoted? exp)
	(tagged-list? exp 'quote))
	
(define (text-of-quotation exp) (cadr exp))

(define (assignment? exp)
	(tagged-list? exp 'set!))
	
(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))

(define (definition? exp)
	(tagged-list? exp 'define))
	
(define (definition-variable exp)
	(if (symbol? (cadr exp))
		(cadr exp)
		(caadr exp)))
		
(define (definition-value exp)
	(if (symbol? (cadr exp))
		(caddr exp)
		(make-lambda (cdadr exp) ;; formal parameters
				(cddr exp)))) ;; body
				
(define (lambda? exp) (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))

(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
	(cons 'lambda (cons parameters body)))
	
(define (if? exp) (tagged-list? exp 'if))

(define (if-predicate exp) (cadr exp))

(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
	(if (not (null? (cdddr exp)))
		(cadddr exp)
		'false))
		
(define (make-if predicate consequent alternative)
	(list 'if predicate consequent alternative))
	
(define (begin? exp) (tagged-list? exp 'begin))

(define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq)))

(define (first-exp seq) (car seq))

(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
	(cond ((null? seq) seq)
		((last-exp? seq) (first-exp seq))
		(else (make-begin seq))))
		
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))

(define (operator exp) (car exp))

(define (operands exp) (cdr exp))

(define (no-operands? ops) (null? ops))

(define (first-operand ops) (car ops))

(define (rest-operands ops) (cdr ops))

(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
	(eq? (cond-predicate clause) 'else))
	
(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

(define (cond->if exp)
	(expand-clauses (cond-clauses exp)))
	
(define (expand-clauses clauses)
	(if (null? clauses)
		'false
		(let ((first (car clauses))
			(rest (cdr clauses)))
			(if (cond-else-clause? first)
				(if (null? rest)
					(sequence->exp (cond-actions first))
					(error "ELSE clause isn't last -- COND->IF" clauses))
				(make-if (cond-predicate first)
					(sequence->exp (cond-actions first))
					(expand-clauses rest))))))
					
(define (let? exp) (tagged-list? exp 'let))

(define (let-vars exp) (map car (cadr exp)))

(define (let-inits exp) (map cadr (cadr exp)))

(define (let-body exp) (cddr exp))

(define (let->combination exp)
	(cons (make-lambda (let-vars exp) (let-body exp))
		(let-inits exp)))
		
(define (let*? expr) (tagged-list? expr 'let*)) 
(define (let*-body expr) (caddr expr)) 
(define (let*-inits expr) (cadr expr)) 
(define (let*->nested-lets expr) 
	(let 	((inits (let*-inits expr)) 
		(body (let*-body expr))) 
                	(define (make-lets exprs) 
				(if (null? exprs) 
					body 
					(list 'let (list (car exprs)) (make-lets (cdr exprs))))) 
			(make-lets inits)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Data structures
(define (true? x)
	(not (eq? x false)))
	
(define (false? x)
	(eq? x false))
	
(define (make-procedure parameters body env)
	(list 'procedure parameters body env))
	
(define (compound-procedure? p)
	(tagged-list? p 'procedure))
	
(define (procedure-parameters p) (cadr p))

(define (procedure-body p) (caddr p))

(define (procedure-environment p) (cadddr p))

(define (enclosing-environment env) (cdr env))

(define (first-frame env) (car env))

(define the-empty-environment '())

(define (make-frame variables values)
	(cons variables values))
	
(define (frame-variables frame) (car frame))

(define (frame-values frame) (cdr frame))

(define (add-binding-to-frame! var val frame)
	(set-car! frame (cons var (car frame)))
	(set-cdr! frame (cons val (cdr frame))))
	
(define (extend-environment vars vals base-env)
	(if (= (length vars) (length vals))
		(cons (make-frame vars vals) base-env)
		(if (< (length vars) (length vals))
			(error "Too many arguments supplied" vars vals)
			(error "Too few arguments supplieed" vars vals))))
			
(define (lookup-variable-value var env)
	(define (env-loop env)
		(define (scan vars vals)
			(cond 	((null? vars)
					(env-loop (enclosing-environment env)))
				((eq? var (car vars))
					(if (eq? (car vals) '*unassigned*)
						(error "Unassigned variable" var)
						(car vals)))
				(else (scan (cdr vars) (cdr vals)))))
		(if (eq? env the-empty-environment)
			(error "Unbound variable" var)
			(let ((frame (first-frame env)))
				(scan (frame-variables frame)
					(frame-values frame)))))
	(env-loop env))
	
(define (set-variable-value! var val env)
	(define (env-loop env)
		(define (scan vars vals)
			(cond 	((null? vars)
					(env-loop (enclosing-environment env)))
				((eq? var (car vars))
					(set-car! vals val))
				(else (scan (cdr vars) (cdr vals)))))
		(if (eq? env the-empty-environment)
			(error "Unbound variable -- SET!" var)
			(let ((frame (first-frame env)))
				(scan (frame-variables frame)
					(frame-values frame)))))
	(env-loop env))
	
(define (define-variable! var val env)
	(let ((frame (first-frame env)))
		(define (scan vars vals)
			(cond 	((null? vars)
					(add-binding-to-frame! var val frame))
				((eq? var (car vars))
					(set-car! vals val))
				(else (scan (cdr vars) (cdr vals)))))
		(scan (frame-variables frame)
			(frame-values frame))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setting up primitive procedures and gloval env

(define (setup-environment)
	(let ((initial-env
		(extend-environment 	(primitive-procedure-names)
					(primitive-procedure-objects)
					the-empty-environment)))
		(define-variable! 'true true initial-env)
		(define-variable! 'false false initial-env)
		initial-env))

(define (primitive-procedure? proc)
	(tagged-list? proc 'primitive))
	
(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures ;; magic
	(list 	(list 'car car)
		(list 'cdr cdr)
		(list 'cons cons)
		(list 'null? null?)
		(list '+ +)
		(list '- -)
		(list '* *)
		(list '/ /)
		(list '= =)
		(list '< <)
		(list '> >)
		))
		
(define (primitive-procedure-names)
	(map car primitive-procedures))
	
(define (primitive-procedure-objects)
	(map 	(lambda (proc) (list 'primitive (cadr proc)))
		primitive-procedures))
		
(define (apply-primitive-procedure proc args)
	(apply-in-underlying-scheme
		(primitive-implementation proc) args))
		
(define the-global-environment (setup-environment))

(define apply-in-underlying-scheme apply)
























