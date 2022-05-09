(define (make-vect x y)
	(cons x y)
)

(define (xcor-vect v)
	(car v)
)

(define (ycor-vect v)
	(cdr v)
)

(define (add-vect v1 v2)
	(make-vect (+ (xcor-vect v1) (xcor-vect v2)) (+ (ycor-vect v1) (ycor-vect v2)))
)

(define (sub-vect v1 v2)
	(make-vect (- (xcor-vect v1) (xcor-vect v2)) (- (ycor-vect v1) (ycor-vect v2)))
)

(define (scalar-vect-mult s v1)
	(make-vect (* s (xcor-vect v1)) (* s (ycor-vect v1)))
)

(define (make-frame origin edge1 edge2)
	(list origin edge1 edge2)
)

(define (origin-frame frame)
	(car frame)
)

(define (edge1-frame frame)
	(cadr frame)
)

(define (edge2-frame frame)
	(caddr frame)
)

(define (make-segment v1 v2)
	(cons v1 v2)
)

(define (start-segment seg)
	(car seg)
)

(define (end-segment seg)
	(cdr seg)
)

(define (frame-coord-map frame)
	(lambda (v)
		(add-vect
			(origin-frame frame)
			(add-vect (scale-vect (xcor-vect v)
					(edge1-frame frame))
				(scale-vect (ycor-vect v)
					(edge2-frame frame))
			)
		)
	)
)

(define (segments->painter segment-list)
	(lambda (frame)
		(for-each
			(lambda (segment)
				(draw-line
					((frame-coord-map frame) (start-segment segment))
					((frame-coord-map frame) (end-segment segment))
				)
			)
			segment-list
		)
	)
)


;;exercise below
;;suppose we have a frame "designated-frame"
;;first we create the segments corresponding this frame
(define c1 (make-vect 0 0))
(define c2 (make-vect 0 1))
(define c3 (make-vect 1 1))
(define c4 (make-vect 1 0))

(define outline-painter 
	(segments->painter (list (make-segment c1 c2) (make-segment c2 c3) (make-segment c3 c4) (make-segment c4 c1)))
)

(define x-painter
	(segments->painter (list (make-segment c1 c3) (make-segment c2 c4)))
)

(define d1 (make-vect 0.5 1))
(define d2 (make-vect 0 0.5))
(define d3 (make-vect 0.5 1))
(define d4 (make-vect 1 0.5))

(define diamond-painter
	(segments-painter (list (make-segment d1 d2) (make-segment d2 d3) (make-segment d3 d4) (make-segment d4 d1)))
)
