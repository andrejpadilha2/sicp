;; last-pair was a procedure that returned the last element of a given list

;; (define (last-pair li)
;;	(if (null? (cdr li))
;;		(car li)
;;		(last-pair (cdr li)))
;;)

(rule (last-pair (?x) (?x))) ;; a rule with no body, only the conclusion...this means that the conclusion holds true for any value of ?x...that's, the last pair of a one element list, is the list itself

(rule (last-pair (?x . ?y) (?z))
	(last-pair (?y) (?z))) ;; the last pair of a given list (x . y) is (z) if the last pair of the list (y) is (z)
	
	
;; (last-pair (3) ?x) will evaluate to (last-pair (3) (3)), by definition

;; (last-pair (1 2 3) ?x) will evaluate to (last-pair (1 2 3) (3))

;; (last-pair (2 ?x) (3)) will evaluate to (last-pair (2 3) (3))

;; (last-pair ?x (3)) will evaluate to an infinite number of possible solutions....

