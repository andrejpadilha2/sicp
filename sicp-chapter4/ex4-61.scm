;; base case, a list that starts with ?x, ?y and then any other subsequent elements

;; recursive case: if (?x is next-to ?y in ?z) then (?x is next-to ?y in (?v . ?z)...that's, if we have a given sequence (?v ...... ?z) and ?x is next to ?y in the part ?z, then it doesn't matter  what comes before ?z, ?x and ?y will still be next to each other

;;answers first query:
(1 next-to (2 3) in (1 (2 3) 4))
((2 3) next-to 4 in (1 (2 3) 4))

;;answers second query:
(2 next-to 1 in (2 1 3 1))
(3 next-to 1 in (2 1 3 1))
