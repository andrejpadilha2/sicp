;; we just have to create a condition for (make-operation-exp)

;; we can't simply remove the "label-exp? exp" condition from "make-primitive-exp" because, even though it's not used to make operations, it still can be used to "make-assign"

(define (make-opeartion-exp exp machine labels operations)
	(let 	((op (lookup-prim (operation-exp-op exp) operations))
		(aprocs 
			(map (lambda (e) 
				(if (label-exp? e)
					(error "Can't operate on labels -- MAKE-OPERATION-EXP" e)
					(make-primitive-exp e machine labels)))
					(operation-exp-operands exp))))
			(lambda () (apply op (map (lambda (p) (p)) aprocs)))))
