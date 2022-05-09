(and (supervisor ?person (Bitdiddle Ben))
	(address ?person ?address))
	
	
(and (salary ?person ?salary1)
	(salary (Bitdiddle Ben) ?salary2)
	(lisp-value > ?salary2 ?salary1))
	
	
;; here I made a mistake first, because I used the "not" query nested inside the "supervisor" query...but in the query language there's no thing such as "nesting" procedures, because actually there's no thing such as procedures!
(and (supervisor ?person1 ?boss) 
	(not (job ?boss (computer . ?work)))
	(job ?boss ?job))
