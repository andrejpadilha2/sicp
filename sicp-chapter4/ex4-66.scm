;; the query is supposed to sum the salary of Alyssa and Cy D...

;; It starts with (job ?x (computer programmer)) and will match ?x to every person that is a computer programmer...

;; so it will create two frames, one with ?x bound to (Hacker Alyssa P) and the other one with ?x bound to (Fect Cy D)

;; then within these two frames, it will try to unify the second expression of "and", that's (salary ?x ?amount)
;; it will extend each frame by binding the value of the salary into ?amount...

;; then the procedure will sum all of it...

;; but if Ben wants to sum the value of all "wheels", he will end up summing up the salary of Oliver Warbucks 4 times!

;; he will need to add a filter to remove duplicated occurences of "?x"
