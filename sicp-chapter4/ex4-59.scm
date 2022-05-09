(meeting ?division (Friday . ?hour))

(rule (meeting-time ?person ?day-and-time)
	(or 	(meeting whole-company ?day-and-time)
		(and	(meeting ?division ?day-and-time)
			(job ?person (?division . ?position)))))
			
(meeting-time (Hacker Alyssa P) (Wednesday . ?time))
