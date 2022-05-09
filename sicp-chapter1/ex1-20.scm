;;(gcd 206 40)

;;(if (= 40 0) 206 (gcd 40 (remainder 206 40)))

;;(gcd 40 (remainder 206 40))

;;(gcd 40 6)

;;(if (= 6 0) 40 (gcd 6 (remainder 40 6)))

;;(gcd 6 (remainder 40 6))

;;(gcd 6 4)

;;(if (= 4 0) 6 (gcd 4 (remainder 6 4)))

;;(gcd 4 (remainder 6 4))

;;(gcd 4 2)

;;(if (= 2 0) 4 (gcd 2 (remainder 4 2)))

;;(gcd 2 (remainder 4 2))

;;(gcd 2 0)

;; 2

;; in applicative order, only 4 remainder operations are made

;; but in normal order, the arguments are not evaluated until the very end

;; (gcd 206 40)

;; (if (= 40 0) 206 (gcd 40 (remainder 206 40))) -> if is evaluated now

;; (gcd 40 (remainder 206 40))

;; (if (= (remainder 206 40) 0) 40 (gcd (remainder 206 40) (remainder 40 (remainder 206 40)))) -> now it evaluates the if statement
;;1 remainder evaluation here

;; (gcd (remainder 206 40) (remainder 40 (remainder 206 40)))

;; (if (= (remainder 40 (remainder 206 40)) 0) (remainder 206 40) (gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))) -> now it evaluates the if statement
;; 2 remainder evaluations here

;; (gcd (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))

;; (if (= (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) 0) (remainder 40 (remainder 206 40)) (gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))) -> now it evaluates the if statements
;; 4 remainder evaluations here

;; (gcd (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))))

;; (if (= (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) 0) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (gcd (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40)))) (remainder (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) (remainder (remainder 40 (remainder 206 40)) (remainder (remainder 206 40) (remainder 40 (remainder 206 40))))))) -> now it evaluates the if
;; 7 remainder evaluations here

;; (remainder (remainder 206 40) (remainder 40 (remainder 206 40))) -> now it finally evaluates this expression
;; 4 remainder evaluations here

;;total: 18 remainder evaluations


