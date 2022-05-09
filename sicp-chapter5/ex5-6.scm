;;at afterfib-n-1


;; when we (restore continue)
;; then (assign n (op -) (reg n) (const 2))
;; then (save continue)

;; since we didn't change the value of continue in between the restore and save, we are basically just picking it from the stack, and putting it back. Hence, we can eliminate those two lines
