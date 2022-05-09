(define (transform-painter origin corner1 corner2)
	(lambda (frame)
		(let ((m (frame-coord-map frame)))
			(let ((new-origin (m origin)))
				(make-frame new-origin
					(sub-vect (m corner1) new-origin)
					(sub-vect (m corner2) new-origin)
				)
			)
		)
	)
)

;;always in the following order: origin, bottom edge and left edge (i.e., I need to tell where is the new "bottom left", "bottom right" and "top left" corners of images)

(define (beside painter1 painter2)
	(let ((split-point (make-vect 0.5 0.0)))
		(let 
			((paint-left
				(transform-painter painter1 (make-vect 0.0 0.0) split-point (make-vect 0.0 1.0)))
			(paint-right 
				(transform-painter painter2 split-point (make-vect 1.0 0.0) (make-vect 0.5 1.0)))
			)
			(lambda (frame) (paint-left frame) (paint-right frame))
		)
	)
)

(define (below painter1 painter2)
	(let ((split-point (make-vect 0.0 0.5)))
		(let 
			((paint-bottom
				(transform-painter painter1 (make-vect 0.0 0.0) (make-vect 1.0 0.0) split-point))
			(paint-top
				(transform-painter painter2 split-point (make-vect 1.0 0.5) (make-vect 0 1.0)))
			)
			(lambda (frame) (paint-left frame) (paint-right frame))
		)
	)
)


(define (below-2 painter1 painter2)
	(rotate90 (beside (rotate270 painter1) (rotate270 painter)))
)
