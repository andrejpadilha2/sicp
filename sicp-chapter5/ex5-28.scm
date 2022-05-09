;; Just copying the eceval, and then notating with *** the place where I change it (check ex5-28-support.scm)
;; also need to add only one operation
(load "ex5-28-support.scm") ;; Syntax Structure and some Operations of eceval


;; now the commands to start the machine
;;(eceval 'trace-on) ;; initially tracing is off, but uncomment this line to get tracing on
(start eceval)

;; the definition of factorial, below, is here just to make it easier to copy and paste in the evaluator
(define (factorial n)
	(define (iter product counter)
		(if (> counter n)
			product
			(iter (* counter product)
				(+ counter 1))))
	(iter 1 1))
	
;; WHAT IS EXPECTED IS THAT ITERATIVE PROCESS IS NOT TAIL RECURSIVE ANYMORE, SO IT WILL INCREASE MAXIMUM-DEPTH WITH N
;; n = 1 -> total pushes = 70 ------ maximum-depth = 17
;; n = 2 -> total pushes = 107 ------ maximum-depth = 20
;; n = 3 -> total pushes = 144 ------ maximum-depth = 23
;; n = 4 -> total pushes = 181 ------ maximum-depth = 26
;; n = 5 -> total pushes = 218 ------ maximum-depth = 29
;; n = 20 -> total pushes = 773 ------ maximum-depth = 74
;; n = 100 -> total pushes = 3733 ------ maximum-depth = 314 (maybe some error here, because the last digits are all 0s)
;; n = 1000 -> total pushes = 37033 ------ maximum-depth = 3014 (maybe some error here, because the last digits are all 0s)

;; a)
;; maximum-depth (factorial n) = 14 + 3 * n 
;; Indeed, now the iterative procedure is not tail recursive anymore

;; b)
;; total pushes (factorial n) = 33 + 37 * n




	
;; the definition of factorial, below, is here just to make it easier to copy and paste in the evaluator
(define (factorial n)
	(if (= n 1)
		1
		(* (factorial (- n 1)) n)))
	
;; n = 1 -> total pushes = 18 ------ maximum-depth = 11
;; n = 2 -> total pushes = 52 ------ maximum-depth = 19
;; n = 3 -> total pushes = 86 ------ maximum-depth = 27
;; n = 4 -> total pushes = 120 ------ maximum-depth = 35
;; n = 5 -> total pushes = 154 ------ maximum-depth = 43
;; n = 20 -> total pushes = 664 ------ maximum-depth = 163
;; n = 100 -> total pushes = 3384 ------ maximum-depth = 803 (maybe some error here, because the last digits are all 0s)
;; n = 1000 -> total pushes = 33984 ------ maximum-depth = 8003 (maybe some error here, because the last digits are all 0s)

;; a)
;; maximum-depth (factorial n) = 3 + 8 * n

;; b)
;; total pushes (factorial n) = 18 + 34 * (n - 1)





	
	
