(rule (big-shot ?person ?division)
	(and (job ?person (?division . ?div-rest)) ;; person works in the division
		(or 	(not 	(supervisor ?person ?person-supervisor)) ;; first possibility: that person doesn't have a supervisor at all
			(and 	(supervisor ?person ?person-supervisor) ;; second possibility? that person has a supervisor
				(job ?person-supervisor (?person-supervisor-division . ?person-sup-div-rest)) ;;that supervisor has a job
				(not (same ?division ?person-supervisor-division))))) ;; that supervisor division is different from ?person
