;; the streams of chapter 3 had only the cdr delayed, but the car wasn't

;; when we defined the integral procedure
(define (integral integrand initial-value dt)
	(define int
		(cons initial-value
			(add-lists 	(scale-list integrand dt)
					int)))
	int)
	
(define (solve f yO dt)
	(define y (integral dy yO dt))
	(define dy (map f y))
y)

;; in chapter 3 this wouldn't work because when we try to evaluate the value of y, it depends on dy, and when we try to evaluate the value of dy, it depends on y
;; so we needed to add (delay dy) in the first line of y

;; now we don't need to do this, because the first element of both streams are delayed

