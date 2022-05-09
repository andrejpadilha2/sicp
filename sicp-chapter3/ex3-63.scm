(define (sqrt-improve guess x)
	(average guess (/ x guess)))

(define (sqrt-stream x)
	(define guesses
		(cons-stream 1.0
			(stream-map (lambda (guess)
				(sqrt-improve guess x))
				guesses)))
	guesses)
	
	
;; what if we defined sqrt-stream as

(define (sqrt-stream-alt x)
	(cons-stream 1.0
		(stream-map (lambda (guess)
			(sqrt-improve guess x))
			(sqrt-stream-alt x))))
			
;; it would recursively call sqrt-stream-alt for calculate every term of the stream, not giving a chance for the computations to be memoized, so it wouldn't be efficient... in the first implementation, guesses is created only once, and all the other times it is referenced it's not being create again, it's only being accessed...since the stream gives access to the very first element, and all subsequent elements needs to be forced, it would be the same efficieny, but this time memoization enters the game, making all previous computations be simple lookups
