;; first we need to add to eval-dispatch
;; for that we will need to provide to the register machine the operation "cond?"...we do it similarly for "let?" and 
eval-dispatch
	...
	...
	(test (op cond?) (reg exp))
	(branch (label ev-cond))
	(test (op let?) (reg exp))
	(branch (label ev-let))
	(test (op let*?) (reg exp))
	(branch (label ev-let*))
	
;; we assume that we have these procedures already defined
(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
	(eq? (cond-predicate clause) 'clause))
	
(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

;;this next procedure we don't need, but we will need to do something similar...we need to create a procedure to extract the first clause of a set of clauses
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

;; these two procedures will make it
(define (first-clause clauses)
	(car clauses))
	
(define (rest-clause clauses)
	(cdr clauses))

;; now the REGISTER MACHINE itself
;; extract the first clause from the expression, extract its predicate and eval-dispatch it, use it's value to decide if executes the cond-actions (with ev-sequence) or if it will test the next one......if no clause is left, just keep executing the code
ev-cond-begin
	(save continue) ;; saves the place where it stopped when it entered the cond
	(assign unev (op cond-clauses) (reg exp)) ;; unev now holds all the clauses
ev-cond-loop
	(test (op null?) (reg unev)) ;; first, test to check if it's null
	(branch (label null-cond))
	(assign exp (op first-clause clauses) (reg unev)) ;; exp now holds only the first clause of unev
	(test (op cond-else-clause?) (reg exp))
	(branch (label ev-cond-else))
	;; now we have unev with all clauses and exp with only the first one...so we test the predicate of exp
	(save exp) ;; saves the first clause of unev
	(save env)
	(assign continue (label ev-cond-decide))
	(assign exp (op cond-predicate) (reg exp)) ;; exp now holds only the predicate of the first clause of unev
	(goto (label eval-dispatch))	;;now it will evaluate the first predicate
ev-cond-else
	(assign val (op clauses-rest) (reg exp))
	(test (op null?) (reg val)) ;; check to see if else clause is really the last one
	(branch (label ev-cond-action-clause))
	(goto (label ev-cond-error-else-not-last))
ev-cond-decide
	(restore env)
	(restore exp) ;; now exp holds the whole first clause of unev again
	(test (op? true) (reg val)) ;; the result of eval-dispatch is in the register val
	(branch (label ev-cond-action-clause)) ;; if it's true, it needs to ev-sequence its action and exit the cond
	(assign unev (rest-clause) (reg unev)) ;; otherwise get the rest of the clauses into unev
	(goto (label ev-cond-loop));; and ev-cond again
ev-cond-action-clause
	(restore continue) ;; register "continue" holds the place where it stopped when it began evaluating the cond
	(assign unev (op cond-actions) (reg exp)) ;; unev holds only the actions of the first clause
	(goto (label ev-sequence))
null-cond
	(restore continue)
	(assign exp (const false))
	(goto (label ev-variable))
ev-cond-error-else-not-last ;; treat the error
	(restore continue)
	(assign val (const else-not-last-clause--COND))
	(goto (label signal-error))
	
	
(cond
	((<predicate1>) 
		(<actions1>))
	((<predicate2>)
		(<actions2>))
	((<predicate3>) (<actions3>)) ;; this whole thing is a cond clause
	(else (<actions-else>))
)
