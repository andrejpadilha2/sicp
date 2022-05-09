(load "get-put.scm")
(load "ex4-3.scm")
(define (predicates exp) (cdr exp)) 
(define (first-predicate seq) (car seq)) 
(define (rest-predicates seq) (cdr seq)) 
(define (no-predicates? seq) (null? seq)) 
(define (last-predicate? seq) (null? (cdr seq)))
 
(define (install-add-or-eval-package)

	;; and
	(define (eval-and exp env)
		(define (eval-and-list preds)
			(cond   ((no-predicates? preds) 'true)
				((not (true? (eval (first-predicate preds) env))) 'false)
				(else (eval-and-list (rest-predicates preds)))))
		(eval-and-list (predicates exp)))
	
	;; or
	(define (eval-or exp env)
		(define (eval-or-list preds)
			(cond   ((no-predicates? preds) 'false)
				((true? (eval (first-predicate preds) env) 'true))
				((else (eval-or-list (rest-predicates preds))))))
		(eval-or-list (predicates exp)))
			

	(put 'eval 'and eval-and)
	(put 'eval 'or eval-or)
)
(install-add-or-eval-package)



;; alternatively, implementing and/or as derived expressions
(define (install-add-or-eval-package-alternative)

	;; and
	(define (eval-and exp env)
		(eval (and->if exp) env))
	
	(define (and->if exp)
		(expand-and-predicates (predicates exp)))
		
	(define (expand-and-predicates preds)
		(if (null? preds)
			'true
			(make-if (first-predicate preds) 
				(expand-and-predicates (rest-predicates preds))
				'false)))
				
	;; or
	(define (eval-or exp env)
		(eval (or->if exp) env))
		
	(define (or->if exp)
		(expand-or-predicates (predicates exp))
	
	(define (expand-or-predicates preds)
		(if (no-predicates? preds)
			'false
			(make-if (first-predicate preds)
				'true
				(expand-or-predicates (rest-predicates preds)))))
	
	(put 'eval 'and eval-and)
	(put 'eval 'or eval-or)
)	
