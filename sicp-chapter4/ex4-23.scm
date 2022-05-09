;;text version

(define (analyze-sequence exps)
	(define (sequentially proc1 proc2) ;; 4) here it creates a procedure which takes an environment as argument and executes each procedure of the sequence sequentially, with respect to this environment
		(lambda (env) (proc1 env) (proc2 env)))
	(define (loop first-proc rest-procs) ;; 3) in the loop it will extract one expression at a time, until the last one
		(if (null? rest-procs)
			first-proc
			(loop (sequentially first-proc (car rest-procs))
				(cdr rest-procs))))
	(let ((procs (map analyze exps))) ;; 1) map "analyze" to all expressions in the sequence
		(if (null? procs)
			(error "Empty sequence -- ANALYZE"))
		(loop (car procs) (cdr procs)))) ;; 2) if the sequence is not null, it will loop through it
		
;; Alyssa P. Hacker version
(define (analyze-sequence exps)
	(define (execute-sequence procs env) 
		(cond ((null? (cdr procs)) ((car procs) env)) ;; 3) now it will loop in the sequence, until the last one...but it will keep executing each expression while it is in the loop
			(else ((car procs) env) ;;"((car procs) env)" is a procedure execution...so it is executing one expression at time, and then starting the loop again with the rest of the expressions
				(execute-sequence (cdr procs) env))))
	(let ((procs (map analyze exps))) ;; 1) map "analyze" to all expressions in the sequence
		(if (null? procs)
			(error "Empty sequence -- ANALYZE"))
		(lambda (env) (execute-sequence procs env)))) ;; 2) if the sequence is not null, it creates a procedure which takes an environment as argument and executes all the expressions in the sequence with respect to that environment...it needs to wait the environment in order to start "(execute-sequence procs env)", thus, this is done at runtime
		
;; in the case where the procedure body has only one expression, example exp = (e1)
;; the text version will be

procs = (map analyze (e1))
(loop (car (analyze e1)) (cdr (analyze e1)))

(if (null? '()) ;; because (cdr (analyze e1)) = '()
it will return only "analyze e1", because it's the "first-proc" of "loop"
the "analyze e1" will create a lambda procedure which takes (env) as argument and does what the expression is supposed to do in that environment

;; in Alyssa's version
procs = (map analyze (e1))
(lambda (env) (execute-sequence (analyze e1) env))
;; then, in run time
(cond ((null? (cdr (analyze e1))) ((car (analyze e1) env)))

(car (analyze e1) env)
;; analyze e1 will return a procedure which takes an environment as argument and executes it
