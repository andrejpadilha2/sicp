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
	(mul-interval x
		(make-interval (/ 1.0 (upper-bound y))
				(/ 1.0 (lower-bound y))
		)
	)
)


(define (make-interval a b) (cons a b))

(define (lower-bound interval) (max (car interval) (cdr interval)))
(define (upper-bound interval) (min (car interval) (cdr interval)))


(define (sub-interval x y)
	(make-interval (- (lower-bound x) (upper-bound y))
			(- (upper-bound x) (lower-bound y))
	)
)




;; width of [1 5] -> 2
;; width of [2 4] -> 1

;; [1 5] + [2 4] -> [3 9]
;; width of [3 9] -> 3, which is equal to 2 + 1

;; width of [1 5] -> 2
;; width of [2 4] -> 1

;; [1 5] - [2 4] -> [-3 3]
;; width of [-3 3] -> 3, which is equal to 2 + 1

;; width of [1 5] -> 2
;; width of [2 4] -> 1

;; [1 5] * [2 4] -> [2 20]
;; width of [2 20] -> 9

;; [2 6] * [3 5] -> [6 30]
;; width of [6 30] -> 12
;; the intervals [1 5] and [2 6] have the same width, as well as the intervalls [2 4] and [3 5]...but the result of the multiplication has different width (9 != 12), therefore it's not a function of the width of the intervals
