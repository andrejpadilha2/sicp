;; (f 'x 'y) 

;; for just looking up the symbol f (evaluation of the operator) there's no need to save "env"

;; for just looking up the value of 'x there's no need to save "env"

;; for just looking up the value of the 'x or 'y, it doesn't need to save "argl"

;; for evaluating the operand sequence, it doesn't need to save "proc"



;; ((f) 'x 'y)

;; same thing here


;; (f (g 'x) y)

;; proc will need to be saved (because it will be substituted from "f" to "g" when evaluating the first operand of "f"

;; argl will need to be saved because it will be subsstitude from "((g 'x) y)" when evaluating "f" to "('x)" when evaluating "g"

;; env will need to be saved bacause it might change the value of "y" when evaluating "(g 'x)", and "y" will be lookup right after


;; (f (g 'x) 'y)

;; same answers from before, but also doesn't need to save "env" (bacause " 'y " is quoted, so it will not be looked up in the environment to get its value
