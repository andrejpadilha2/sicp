;; yes, we can just change the selectors

;; example

(define (register-exp? exp) (tagged-list? exp 'register))

(define (constant-exp? exp) (tagged-list? exp 'constant))

(define (label-exp? exp) (tagged-list? exp 'lab))


;; then we can further change the operations of our register-machine language

;; instead of (assign x (op +) (register a) (constant 3))
;; I want (assign x (register a) (op +) (constant 3))

(define (operation-exp? exp)
	(and (pair? exp) (taggest-list? (cadr exp) 'op)))
	
(define (operation-exp-op operation-exp)
	(cadr (cadr operation-exp)))
	
(define (operation-exp-operands operation-exp)
	(list (car operation-exp) (cddr operation-exp)))
