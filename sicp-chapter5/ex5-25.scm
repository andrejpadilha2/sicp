;; the main change from the "vanilla" evaluator to the "lazy evaluator" is the application of procedures (we don't evaluate the operands with "list-of-vals", we just pass them directly to apply
;; we need some "auxialiary" procedures 
;; and eval-if also changes, because we need to get the "actual-value" of if's predicate
eval-dispatch
	(test (op self-evaluating?) (reg exp))
	(branch (label ev-self-eval))
	...
	...
	(test (op application?) (reg exp))
	(branch (label ev-application))
	(goto (label unknown-expression-type))
	
	
ev-application
	(save continue)
	(save env)
	(assign unev (op operands) (reg exp))
	(save unev)
	(assign exp (op operator) (reg exp))
	(assign continue (label ev-appl-did-operator))
	(goto (label eval-dispatch))
	
ev-appl-did-operator
	(restore unev) ;; the operands
	(restore env)
	(assign proc (reg val)) ;; we save the operator in "proc"
	(test (op no-operands?) (reg unev))
	(branch (label apply-dispatch))
	(save proc) ;; we actually don't need to save the procedure
	(goto (label ev-last-arg))
ev-last-arg
;; here we don't need to cycle through "unev" to evaluate the operands!
	(assign argl (reg unev))
	(restore proc) ;; if we don't save it, we also won't need to restore the procedure
	(goto (label apply-dispatch))
	
	
;; and the change in apply-dispatch
apply-dispatch
	(test (op primitive-procedure?) (reg proc))
	(branch (label primitive-apply))
	(test (op compound-procedure?) (reg proc))
	(branch (label compound-apply))
	(goto (label unknown-procedure-type))
	
primitive-apply
	(assign argl (op list-of-arg-values) (reg argl) (reg env)) ;; since the argument list is not yet evaluated, we need to evaluate it
	(assign val 	(op apply-primitive-procedure)
			(reg proc)
			(reg argl))
	(restore continue)
	(goto (reg continue))
	
compound-apply
	(assign unev (op procedure-parameters) (reg proc))
	(assign env (op procedure-environment) (reg proc))
	(assign argl (op list-of-delayed-args) (reg argl) (reg env)) ;; if it's a compound apply, we don't to evaluate the operands yet
	(assign env 	(op extend-environment)
			(reg unev) (reg argl) (reg env))
	(assign unev (op procedure-body) (reg proc))
	(goto (label ev-sequence))
	
	
;; and finally, the change in ev-if
ev-if
	(save exp)
	(save env)
	(save continue)
	(assign continue (label ev-if-decide))
	(assign exp (op if-predicate) (reg exp))
	(assign exp (op actual-value) (reg exp) (reg env))
	(goto (label eval-dispatch))
	
	
	
	
;; procedures necessary for lazy evaluation, we can assume these are already implemented		
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
			
(define (force-it obj)
	(cond ((thunk? obj)
		(let ((result (actual-value (thunk-exp obj) (thunk-env obj))))
			(set-car! obj 'evaluated-thunk)
			(set-car! (cdr obj) result)
			(set-cdr! (cdr obj) '())
			result))
		((evaluated-thunk? obj)
			(thunk-value obj))
		(else obj)))

(define (delay-it exp env)
	(list 'thunk exp env))
	
(define (thunk? obj)
	(tagged-list? obj 'thunk))

(define (thunk-exp thunk) (cadr thunk))

(define (thunk-env thunk) (caddr thunk))

(define (evaluated-thunk? obj)
	(tagged-list? obj 'evaluated-thunk))
	
(define (thunk-value evaluated-thunk) (cadr evaluated-thunk))


