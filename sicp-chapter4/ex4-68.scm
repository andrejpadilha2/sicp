(rule (reverse () ()))

;;this is my original formulation...I overcomplicated somethings, but the general idea is the same
(rule (reverseV1 (?u . ?v2) (?v2 . ?u))
	(and 	(reverse (?v2) (?w . ?v))
		(append-to-form (?w . ?v) ?u (?v2 . ?u))))
		
(rule (reverse (?h . ?t) ?y)
	(and 	(reverse ?t ?reversed-t)
		(append-to-form ?reversed-t (?h) ?y))) ;; also I still can't quite understand when I use variables inside parethesis or not
	

