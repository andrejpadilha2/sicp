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
