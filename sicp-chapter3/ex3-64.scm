(define (stream-limit stream-iterations tolerance)
	(if (< (abs (- (stream-car (stream-cdr stream-iterations)) (stream-car stream-iterations)) tolerance))
		(stream-car (stream-cdr stream-iterations))
		(stream-limit (stream-cdr stream-iterations) tolerance)))
		
;;I could change (stream-car (stream-cdr stream-iterations)) to simply (stream-ref stream-iterations 1)


(define (sqrt x tolerance)
	(stream-limit (sqrt-stream x) tolerance))


(define (sqrt-improve guess x)
	(average guess (/ x guess)))

(define (sqrt-stream x)
	(define guesses
		(cons-stream 1.0
			(stream-map (lambda (guess)
				(sqrt-improve guess x))
				guesses)))
	guesses)
