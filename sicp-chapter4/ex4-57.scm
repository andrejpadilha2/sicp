(rule (can-replace ?person1 ?person2)
	(and (job ?person-1 ?job-1)
		(job ?person-2 ?job-2)
		(not (same ?person-1 ?person-2))
		(or (same ?job-1 ?job-2)
			(can-do-job ?job-1 ?job-2))))
			
(rule (same ?x ?x))

;;a) (can-replace ?person (Fect Cy D.))

;; b) (and (salary ?person1 ?salary1)
;;	(salary ?person2 ?salary2)
;;	(can-replace ?person1 ?person2)
;;	(lisp-value > ?salary2 ?salary1))
