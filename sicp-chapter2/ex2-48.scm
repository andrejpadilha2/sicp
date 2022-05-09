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


;;exercise below
(define (make-segment v1 v2)
	(cons v1 v2)
)

(define (start-segment seg)
	(car seg)
)

(define (end-segment seg)
	(cdr seg)
)
