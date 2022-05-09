((lambda (n)
	((lambda (fact)
		(fact fact n))
	(lambda (ft k)
		(if (= k 1)
			1
			(* k (ft ft (- k 1)))))))
10)

((lambda (fact)
		(fact fact 10))
	(lambda (ft k)
		(if (= k 1)
			1
			(* k (ft ft (- k 1))))))
	
;;substituting the inner lambda in (fact fact 10)		
((lambda (ft k)
		(if (= k 1)			;; body
			1
			(* k (ft ft (- k 1)))))
			
		(lambda (ft k)			;; argument
		(if (= k 1)
			1
			(* k (ft ft (- k 1)))))
10)	;; argument

;; substituting the inner lambda for the outter "ft" and 10 for "k"
(if (= 10 1)
	1 ;; body
	(* 10 
		((lambda (ft k)
			(if (= k 1)
				1
				(* k (ft ft (- k 1)))))
				 
		(lambda (ft k)		;; argument
			(if (= k 1)
				1
				(* k (ft ft (- k 1))))) 
			
		(- 10 1)))) ;;argument
		
		
;; now it's easier to see that this will cycle, (- 10 1) will evaluate to "9", and will be used as argument for the outter lambda...this will repeat until it reaches 1, then everything will be multiplied

;; this is an implementation of the Y-combinator, which creates recursion using lambda calculus


(define (f x)
	((lambda (even? odd?)
		(even? even? odd? x)) ;; body
	(lambda (ev? od? n)
		(if (= n 0) true (od? ev? od? (- n 1)))) ;; first argument
	(lambda (ev? od? n)
		(if (= n 0 ) false (ev? ev? od? (- n 1)))))) ;; second argument
		
;; say we called (f 10)
((lambda (ev? od? n)
		(if (= n 0) true (od? ev? od? (- n 1)))) ;;body
		
(lambda (ev? od? n)
		(if (= n 0) true (od? ev? od? (- n 1)))) ;; first argument (the "ev?" in the outter lambda), should be something that enables the mutual recursion
		
(lambda (ev? od? n)
		(if (= n 0 ) false (ev? ev? od? (- n 1))))  ;; second argument (the "od?" in the outter lambda), should be something that enables the mutual recursion
		
10) ;; third argument

;; will evaluate to
(od? ev? od? (- 10 1))
;;
(od? ev? od? 9)
;;
((lambda (ev? od? n)
		(if (= n 0 ) false (ev? ev? od? (- n 1)))) ;; body

(lambda (ev? od? n)
		(if (= n 0) true (od? ev? od? (- n 1)))) ;; first argument

(lambda (ev? od? n)
		(if (= n 0 ) false (ev? ev? od? (- n 1)))) ;; second argument
		
9) ;; third argument
;;
(ev? ev? od? (- 9 1))
;;
(ev? ev? od? 8)
;;
((lambda (ev? od? n)
		(if (= n 0) true (od? ev? od? (- n 1)))) ;; body
		 
(lambda (ev? od? n)
		(if (= n 0) true (od? ev? od? (- n 1)))) ;; first argument

(lambda (ev? od? n)
		(if (= n 0 ) false (ev? ev? od? (- n 1)))) ;; second argument
		
8)

;;now we can see that the body keeps alternating, while the argument are always the same
