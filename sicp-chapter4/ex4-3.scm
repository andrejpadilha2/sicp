(load "get-put.scm")

(define (eval exp env)
	(cond   ((self-evaluating? exp) exp)
		((variable? exp) (lookup-variable-value exp env))
		((get 'eval (operator exp)) (get 'eval (operator exp) exp env)) ;; special cases
		((application? exp)                                             ;; expression aplication
			(apply (eval (operator exp) env)
				(list-of-values (operands exp) env)))
		(else
			(error "Unknown expression type -- EVAL" exp))))

;; self-evaluation and variable are base cases
(define (self-evaluating? exp)
	(cond ((number? exp) true)
		((string? exp) true)
		(else false)))
		
(define (variable? exp) 
	(symbol? exp))

;; now we install the eval packages, with the condition analysis for each type of expression and the specification of the syntax of our language (constructors and selectors)
(define (install-eval-package)
	;; quotation
	(define eval-quoted
		(lambda (exp env) (cadr exp)))
		
	;; assignment
	(define eval-assignment
		(lambda (exp env) 
			(set-variable-value! (assignment-variable exp)
						(eval (assignment-value exp) env)
						env)
			'ok))
	
	(define (assignment-variable exp) (cadr exp))
	(define (assignment-value exp) (caddr exp))
	
	;; define
	(define eval-definition
		(lambda (exp env)
			(define-variable! (definition-variable exp)
						(eval (definition-value exp) env)
						env)
			'ok))
			
	(define (definition-variable exp)
		(if (symbol? (cadr exp))
			(cadr exp)
			(caadr exp)))
	
	(define (definition-value exp)
		(if (symbol? (cadr exp))
			(caddr exp)
			(make-lambda (cdadr exp) ;; formal parameters
				(cddr exp))))    ;; body
			
	;; if
	(define eval-if
		(lambda (exp env)
			(if (true? (eval (if-predicate exp) env))
				(eval (if-consequent exp) env)
				(eval (if-alternative exp) env))))
	
	(define (if-predicate exp) (cadr exp))
	(define (if-consequent exp) (caddr exp))
	(define (if-alternative exp)
		(if (no (null? (cdddr exp)))
			(cadddr exp)
			'false))
	
		
	;; lambda
	(define eval-make-procedure
		(lambda (exp env)
			(make-procedure (lambda-parameters exp) (lambda-body exp) env)))
		
	
			
	;; begin
	(define eval-sequence
		(lambda (exps env)
			(cond ((last-exp? exps) (eval (first-exp exps) env))
				(else (eval (first-exp exps) env)
					(eval-sequence (rest-exps exps) env)))))
			
	(define eval-sequence-first
		(lambda (exp env)
			(eval-sequence (begin-actions exp) env)))
	
	(define (begin-actions exp) (cdr exp))
	
	
	(define (sequence->exp seq)
		(cond ((null? seq) seq)
			((last-exp? seq) (first-exp seq))
			(else (make-begin seq))))
			
	(define (make-begin seq) (cons 'begin seq))
	
	;; cond
	(define eval-cond
		(lambda (exp env)
			(eval (cond->if exp) env)))
	
	(define (cond-clauses exp) (cdr exp))
	(define (cond-else-clause? clause)
		(eq? (cond-predicate clause) 'else))
	(define (cond-predicate clause) (car clause))
	(define (cond-actions clause) (cdr clause))
	
	(define (cond->if exp)
		(expand-clauses (cond-clauses exp)))
		
	(define (expand-clauses clauses)
		(if (null? clauses)
			'false                         ;; no else clause
			(let    ((first (car clauses))
				(rest (cdr clauses)))
				(if (cond-else-clause? first)
					(if (null? rest)
						(sequence-exp (cond-actions first))
						(error "Else clause isn't last -- COJND-IF"
							clauses))
					(make-if (cond-predicate first)
						(sequence-exp (cond-actions first))
						(expand-clauses rest))))))
	

	(put 'eval 'quote eval-quoted)
	(put 'eval 'set! eval-assignment)
	(put 'eval 'define eval-definition)
	(put 'eval 'if eval-if)
	(put 'eval 'lambda eval-make-procedure)
	(put 'eval 'begin eval-sequence-first)
	(put 'eval 'cond eval-cond)
	'done
)

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

(define (make-if predicate consequent alternative)
	(list 'if predicate consequent alternative))
	
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))
	
(define (make-lambda paremeters body)
	(cons 'lambda (cons parameters body)))


(install-eval-package)
