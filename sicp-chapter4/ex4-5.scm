(load "get-put.scm")
(load "ex4-3.scm")

;; cond
(define eval-cond
	(lambda (exp env)
		(eval (cond->if exp) env)))
			
(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
	(eq? (cond-predicate clause) 'else))
		
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))

(define (cond-recipient-clause? clause) (eq? (cadr clause) '=>))
(define (cond-recipient-cluase clause) (caddr clause))
	
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
				(if (cond-recipient-clause? first)
					(make-if (cond-predicate first)
						(list (cond-recipient-clause first) (cond-predicate first))
						(expand-clauses rest))
					(make-if (cond-predicate first)
						(sequence-exp (cond-actions first))
						(expand-clauses rest)))))))
			
					
(put 'eval 'cond eval-cond)
