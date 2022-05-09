;; yes, it does affect the running time, but not the final result

;; that's because some restrictions are more "restrictive" then others....for example

;; (require (not (= baker 5))) only requires that baker does not live on the 5th floor...that's 20% of the possible combinations (1 in 5 floors)

;; but (require (> miller cooper)) states that miller lives in a higher floor than cooper...that's much more restrictive, because there are a lot of combinations of this requirement to not be fullfilled, for example (miller in 1 cooper in 2, 3, 4 or 5)...(miller in 2, cooper in 3, 4 or 5) and so on.

;; so it's a good strategy to put the most restrictives cases first (if they run at the same speed as others), and the less restrictives last

;; in total, 3125 possible outcomes exists
;; the procedure distinct runs in quadratic time, it would be better to move it last
