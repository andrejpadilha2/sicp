(rule (grandson ?grandfather ?child)
	(and	(son ?grandfather ?father)
		(son ?father ?child)))
		
(rule (son-of ?father ?child)
	(and	(wife ?father ?mother)
		(son ?mother ?child)))
