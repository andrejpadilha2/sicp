(define (make-segment point1 point2) (cons point1 point2))

(define (start-segment line-segment) (car line-segment))

(define (end-segment line-segment) (cdr line-segment))

(define (make-point x y) (cons x y))

(define (x-point point) (car point))

(define (y-point point) (cdr point))

(define (midpoint-segment seg)
	(define (average a b) (/ (+ a b) 2))
	(make-point (average (x-point (start-segment seg)) (x-point (end-segment seg))) (average (y-point (start-segment seg)) (y-point (end-segment seg))))
)


(define (print-point p)
	(newline)
	(display "(")
	(display (x-point p))
	(display ",")
	(display (y-point p))
	(display ")")
)

(define (make-rectangle p1 p2) 
	(cons (make-segment p1 (make-point (x-point p2) (y-point p1))) (make-segment p1 (make-point (x-point p1) (y-point p2))))
)

(define (side1 rectangle) (car rectangle))
(define (side2 rectangle) (cdr rectangle))

(define (square x) (* x x))

(define (segment-abs-value seg) 
	(sqrt (+ (square (- (y-point (end-segment seg)) (y-point (start-segment seg)))) (square (- (x-point (end-segment seg)) (x-point (start-segment seg))))))
)

(define (perimeter rectangle)
	(+ (* 2 (segment-abs-value (side1 rectangle))) (* 2 (segment-abs-value (side2 rectangle))))
)

(define (area rectangle)
	(* (segment-abs-value (side1 rectangle)) (segment-abs-value (side2 rectangle)))
)



(define p1 (make-point 0 0))
(define p2 (make-point 2 2))
(define p3 (make-point 2 0))

(define rec1 (make-rectangle p1 p2))

(define (make-rectangle-alternative p1 width height) 
	(cons (make-segment p1 (make-point (+ (x-point p1) width) (y-point p1))) (make-segment p1 (make-point (x-point p1) (+ (y-point p1) height))))
)

(define rec2 (make-rectangle-alternative p1 2 2))


(define rec3 (make-rectangle (make-point 1 3) (make-point 4 9)))
(define rec4 (make-rectangle-alternative (make-point 1 3) 3 6))
