;; (find-assertions query-patter frame) returns all possible frames where the assertion of query-pattern is true
;; similarly (apply-rules query-pattern frame) returns all possible frames where the unification of the corresponding rules and query-pattern makes sense

;; if we only (stream-append) these two, the application of rules could lead to infinite loops before matching the simple assertions of "find-assertions"

;; on the other hand, if we delay the evaluation of apply-rules, we can still have an infinity loop, but we would be able to at least see the result (it would be coming in an infinite stream, but the stream itself would not be stuck)


