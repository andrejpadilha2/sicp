(define (add-interval x y)
	(make-interval (+ (lower-bound x) (lower-bound y))
			(+ (upper-bound x) (upper-bound y))
	)
)

(define (mul-interval x y)
	(let ((p1 (* (lower-bound x) (lower-bound y)))
		(p2 (* (lower-bound x) (upper-bound y)))
		(p3 (* (upper-bound x) (lower-bound y)))
		(p4 (* (upper-bound x) (upper-bound y)))
		)
		(make-interval (min p1 p2 p3 p4) (max p1 p2 p3 p4))
	)
)

(define (div-interval x y)
	(if (<= (* (upper-bound y) (lower-bound y)) 0)
		(display "Division error: second interval spans 0.")
		(mul-interval x
			(make-interval (/ 1.0 (upper-bound y))
					(/ 1.0 (lower-bound y))
			)
		)
	)
)

(define (make-interval a b) (cons a b))
(define (make-center-percentage center percentage) (cons (- center (* center percentage)) (+ center (* center percentage))))

(define (center i)
	(/ (+ (lower-bound i) (upper-bound i)) 2)
)
(define (width i)
	(/ (- (upper-bound i) (lower-bound i)) 2)
)

(define (percentage i)
	(* 100 (/ (width i) (center i)))
)



(define (lower-bound interval) (min (car interval) (cdr interval)))
(define (upper-bound interval) (max (car interval) (cdr interval)))


(define (sub-interval x y)
	(make-interval (- (lower-bound x) (upper-bound y))
			(- (upper-bound x) (lower-bound y))
	)
)


;;testing
(define a (make-interval 2 2))
(define b (make-interval -1 4))
