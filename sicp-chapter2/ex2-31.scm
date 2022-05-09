(define (tree-map fn tree)
	(if (list? tree)
		(map (lambda (element) (tree-map fn element)) tree)
		(fn tree)
	)
)


(define (square-tree tree)
	(tree-map square tree)
)


(define (tree-map2 fn tree)
	(cond
		((null? tree) tree)
		((not (pair? tree)) (fn tree))
		(else (cons (tree-map2 fn (car tree)) (tree-map2 fn (cdr tree))))
	)
)

(define (square-tree2 tree)
	(tree-map2 square tree)
)
