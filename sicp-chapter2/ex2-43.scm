;; In the first version, for each previously calculated queen configurations, we create n new rows for the new queen configuration,
;; then we adjoin-position of each new queen configuration (n) with the "rest-of-queens" data structure...creating n new "branches"...after that we filter it

;;in other words, we test n new queen configurations against the "rest-of-queens" set




;; in the wrong version, for each previously calculated queen configuration (rest-of-queens) we are adjoin'ing-position of a new queen position, but we test against the whole "rest-of-queens" set (because we need to)...

;;so we cycled through "rest-of-queens" inside "flatmap" and we cycle again inside "safe?"

;;in other words, we test length(rest-of-queens) against
