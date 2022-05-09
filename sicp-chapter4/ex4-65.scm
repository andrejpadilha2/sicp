;; The rule in wheel will return results for all frames that the bindings correclty assert

;; It starts binding ?person to ?who and creating a new frame

;; so in the first expression of the "and", it will return all frames that the assertion (supervisor ?middle-manager ?who), basically showing every employee that has a supervisor, creating one new frame for each match

;; these new frames are then used to qeval the second expression of "and", which is the assertion (supervisor ?x ?middle-manager)...so it will see all matches where someone who was supervised by "?who" is also a supervisor for "?x" (which can be anyone)...

;; Warbucks Oliver is the supervisor of Ben Bitdiddle....
;; but Ben Bitdiddle is the supervisor of Alyssa, Cy D Fect and Lem E Tweakit.... 3 cases that makes Warbucks Oliver a wheel
;; Warbucks Oliver is also the supervisor of Scrooge Eben, which in turn is the supervisor of Cratchet Robert... this makes Warbucks Oliver a wheel once again, totalizing 4 times


;; Ben Bitdiddle is also a wheel because he supervises Alyssa, which in turn is the supervisor of Louis Reasoner
