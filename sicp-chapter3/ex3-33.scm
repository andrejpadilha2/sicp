(define (averager a b c)
	(let (
		(u (make-connector))
		(v (make-connector))
		)
	(adder a b u)
	(constant v 0.5)
	(multiplier u v c)
	'ok)
)

;;or 

(define (averager-alternative a b c) 
   (let ((u (make-connector)) 
         (v (make-connector))) 
     (adder a b u) 
     (multiplier c v u) 
     (constant 2 v) 
     'ok)) 
