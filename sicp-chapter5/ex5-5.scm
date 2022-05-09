(factorial 3)

;;immediately before the first iteration
*** continue <- fact-done
*** n = 3
*** stack
empty



;;immediately after the first iteration
*** continue <- after-fact
*** n <- 2
*** stack
3
fact-done



;;immediately after the second iteration
*** continue <- after-fact
*** n <- 1
*** stack
2
after-fact
3
fact-done




;;In the third iteration it tests and braches to the base case, where it assigns val to "1" 
*** val <- 1
*** continue = after-fact
*** n = 1
**** stack
2
after-fact
3
fact-done
;; and goes to (reg continue) which is "after-fact"




;; in after-fact it restores n and restores continue, then it calculates val and goes to (reg continue)
*** n <- 2
*** continue <- after-fact
*** val <- 1 * 2 = 2
*** stack
3
fact-done


*** n <- 3
*** continue <- fact-done
*** val <- 2 * 3 = 6
*** stack
empty




For Fibonacci I've done on paper
