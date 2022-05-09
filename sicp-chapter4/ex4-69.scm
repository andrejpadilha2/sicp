;;DB
(son Adam Cain)
(son Cain Enoch)
(son Enoch Irad)
(son Irad Mehujael)
(son Mehujael Methushael)
(son Methushael Lamech)
(wife Lamech Ada)
(son Ada Jabal)
(son Ada Jubal)

;; rules from 4.63
(rule (grandson ?grandfather ?child)
	(and	(son ?grandfather ?father)
		(son ?father ?child)))
		
(rule (son-of ?father ?child)
	(and	(wife ?father ?mother)
		(son ?mother ?child)))
		

;; new rules
(rule (ends-in-grandson (grandson))) ;; a relationship ends in grandson if it IS the relationship "grandson"

(rule (ends-in-grandson (?greats . ?rel)) ;; or if it is a relationship that starts with "greats" 
	(ends-in-grandson ?rel)) ;; given that the relationship itself ends-in-grandson


		
(rule ((great . ?rel) ?x ?y) ;; so ?x is the "great great ... great" grandson of ?y 
	(and	(ends-in-grandson ?rel) ;; if the relation between them "ends-in-grandson"
		(son-of ?x ?other) ;; if the "son-of" ?x is ?other
		(?rel ?other ?y))) ;; the "grandson" (or great grandson, or great...great grandson) of ?other is ?y
