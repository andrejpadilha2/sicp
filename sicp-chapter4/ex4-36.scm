;; Because "an-integer-starting-from" would never return all the possible triples, it would simply keep changing the inner-most integer (in this case, "k") every time it found a dead-end, and wouldn't ever change the values of "i" and "j".

(define (pythagorean-triples)
	(let ((triples (list (an-integer-starting-from 1) (an-integer-starting-from 1) (an-integer-starting-from 1))))
		(let 	((i (car triples))
			(j (cadr triples))
			(k (caddr triples)))
			(require (= (+ (* i i) (* j j)) (* k k)))
			(list i j k))))
	
;; would this work?
