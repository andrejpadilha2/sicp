(define (up-split painter n)
	(if (= n 0)
		painter
		(let ((smaller (up-split painter (- n 1))))
			(below painter (besides smaller smaller)))
	)
)

(define (split part1 part2)
	(lambda (painter n) 
		(if (= n 0)
			painter
			(let ((smaller ((split part1 part2) painter (- n 1))))
				(part1 painter (part2 smaller smaller)))
		)
	)
)


;;now we can redefine up-split as

(define up-split
	(split below beside)
)
