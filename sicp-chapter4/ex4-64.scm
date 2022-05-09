;; in the conclusion, ?staff-person binds to (Bitdiddle Ben) and ?boss binds to ?who
;; ?staff-person -> (Bitdiddle Ben)
;; ?boss -> ?who

;; in the body ?staff-person is already bound to (Bitdiddle Ben)
;; ?boss is already bound to ?who

;; then inside the "and", it calls outranked-by again with ?middle-manager bound to the supervisor of ?staff-person and ?boss bound to ?who again

;;it will keep calling the outranked-by without ever asserting a value to ?who

;; this indicates that THE ORDER in which the "and" expressions are written MATTER...big difference from the mathematical definition of "and"
