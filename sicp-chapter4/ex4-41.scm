(define (flatmap proc seq)
	(foldr append 
		null 
		(map proc seq)))
 
(define (permutations s)
	(if (null? s)                    
		(list null)                   
		(flatmap (lambda (x)
			(map (lambda (p) (cons x p))
				(permutations (remove x s))))
				s)))
 
(define (present-solution solution)
	(map list 
		'(baker cooper fletcher miller smith)
		solution))
 
(define (multiple-dwelling)
     
	(define (invalid-solution permutation)
		(let 	((baker (first permutation))
			(cooper (second permutation))
			(fletcher (third permutation))
			(miller (fourth permutation))
			(smith (fifth permutation)))
			(and 	(not (= baker 5))
				(not (= cooper 1))
				(not (= fletcher 5))
				(not (= fletcher 1))
				(> miller cooper)
				(not (= (abs (- smith fletcher)) 1))
				(not (= (abs (- fletcher cooper)) 1)))))
	   
	(map present-solution
		(filter invalid-solution
			(permutations (list 1 2 3 4 5)))))
			
;;I started doing this exercise with nested loops and ifs...way better to solve it using list operatings, i.e., flatmap, permutations and filter
