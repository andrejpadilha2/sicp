(define (square-tree tree)
	(cond 
		((null? tree) tree)
		((not (pair? tree)) (square tree))
		(else (cons (square-tree (car tree)) (square-tree (cdr tree))))
	)
)



(define (square-tree-map tree)
	(if (list? tree)
		(map (lambda (element) (square-tree-map element)) tree)
		(square tree)
	)
)
