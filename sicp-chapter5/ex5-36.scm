;; it produces from right to left

;; we just remove the "(let ((operand-codes (reverse operand-codes)))" instruction from "construct-arglist" in the compiler

;; I don't know if I should change anything else in the compiler (I guess so, but I would need to investigate deeper)

;; I also don't know how it would affect efficiency
