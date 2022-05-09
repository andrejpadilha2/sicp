;; first we need to add to eval-dispatch
;; for that we weill need to provide to the register machine the operation "cond?"...we do it similarly for "let?" and 
eval-dispatch
	...
	...
	(test (op cond?) (reg exp))
	(branch (label ev-cond))
	(test (op let?) (reg exp))
	(branch (label ev-let))
	(test (op let*?) (reg exp))
	(branch (label ev-let*))
	

;; then we begin ev-cond, ev-let and ev-let*

ev-cond
	(assign exp (op cond->if) (reg exp))
	(goto (label eval-dispatch)) ;; so here I see some online solution as (goto (label ev-if)), which I can definitely understand since it's an if expression, we are just going to skip directly to the part of the machine that evaluates it....but why then, in exercise 4.5, 4.6 and so on, we didn't add the following clause to eval: ((cond? exp) (eval-if (cond->if exp) env))? Wouldn't it be the same? 


ev-let
	(assign exp (op let->combination) (reg exp))
	(goto (label eval-dispatch))
	
ev-let*
	(assign exp (op let*->nested-lets) (reg exp))
	(goto (label eval-dispatch))

