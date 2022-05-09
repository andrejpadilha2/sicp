(define (cube x) (* x x ))

(define (p x) (- (* 3 x) (* 4 (cube x))))

(define (sine angle)
	(if (not (> (abs angle) 0.1))
	angle
	(p (sine (/ angle 3.0)))))
	
	
;; the procedure will p will be applied 5 times for angle = 12.15

;; for time, theta(a) = log(a) .... if you multiply the initial angle by 3, the algorithm will do only 1 step more...so the growth is a log of base 3 (log base 3 of 3 is 1, which is the 1 step more)
;; for space, theta(a) = a
