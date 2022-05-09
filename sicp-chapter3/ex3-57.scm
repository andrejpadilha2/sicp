;; since we memoize the result, it will perform 

;; fib(n) = fib(n-1) + fib(n-2)
;; fib(1) = 1
;; fib(2) = 1
;; fib(3) = fib(2) + fib(1) -> 1 addition
;; fib(4) = fib(3) + fib(2) -> 1 addition
;; ...
;; fib(n) = fib(n-1) + fib(n-2) -> n additions - 2 -> theta(n)

;; if it wasn't memoized, for every fib, we would need to calculate fib(n-1) and fib(n-2) again, which is exponentially big when we increase n (because to compute fib(n-1) we would also need to compute fib(n-2) and fib(n-3), so every fib computation creates 2 new fib computations, except for the base cases fib(1) and fib(2)).
