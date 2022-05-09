;;when you call expmod two times, you are not taking advantage of the exponent being divided by two anymore

;;you are creating 2^n branches in a recursion tree (for each call of expmod, it creates 2 new calls)

;; so you have a THETA(log n) growth, but now you have a THETA(log 2^n) which is the same thing as THETA(n log2), and since the constant is negligible, we have THETA(n)
