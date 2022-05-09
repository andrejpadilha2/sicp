(define (pascal-triangle row col)
	(cond 
		((> col row) 0)
		((< col 0) 0)
		((or (= col 1) (= col row)) 1)
		(else (+ 
			(pascal-triangle (- row 1) col) 
			(pascal-triangle (- row 1) (- col 1))
			)
		)
	)
)
