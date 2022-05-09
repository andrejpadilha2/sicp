;; (define count 0)

;; (define (id x)
;;	(set! count (+ count 1))
;;	x)

;; (define w (id (id 10)))

;; it will first create a binding of count to 0

;; then it will create a binding of "id" to the corresponding procedure

;; then it will (id (id 10))
;; it will evaluate the OUTTER id first, not evaluating the body

;; so it will be like binding x to (id 10) in the outter id procedure
;; it will then enter (set! count (+ count 1))
;; it will first evaluate "set!" to change the value of "count"...then it will evaluate (+ count 1), which will result in "1", and it will set! the value of count to 1

;; then it will return x
;; but "x" is a delayed expression still, and it will be return still delayed (it isn't being forced by anything)
;; this is the value of w before we "call it"..."w" is bind to the thunk (thunk (id 10) #global-environment#)
;; only when we type "w" in the prompt, that's, calling it's value, it will evaluate the inner "id"

;; then it will enter the INNER id
;; similarly, it will set! count to 2




;; answering the book
;; first count will be 1

;; w will be 10

;; count will be 2
