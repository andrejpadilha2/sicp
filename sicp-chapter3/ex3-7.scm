(define (make-account balance password)
	(define (withdraw amount)
		(if (>= balance amount)
			(begin (set! balance (- balance amount))
				balance)
			"Insufficient funds"))
			
	(define (deposit amount)
		(set! balance (+ balance amount))
		balance)
		
	(define (dispatch informed-password m)
		(if (eq? informed-password password)
			(cond ((eq? m 'withdraw) withdraw)
				((eq? m 'deposit) deposit)
				((eq? m 'create-joint-account))
				(else (error "Unknown request -- MAKE-ACCOUNT"
					m))
			)
			(lambda (x) "Incorrect password - MAKE-ACCOUNT")
		)
	)
	dispatch
)

(define (make-joint acc password joint-password)
	(define (dispatch key m)
    		(cond ((not (eq? key joint-password)) 
           			(error "Incorrect password -- MAKE-JOINT"))
          		((eq? m 'withdraw) (acc password 'withdraw))
          		((eq? m 'deposit)  (acc password 'deposit))
          	(else (error "Unknown request -- MAKE-JOINT" m))))
  	dispatch
)


(define peter-acc (make-account 1000 'open-sesame))

(define paul-acc (make-joint peter-acc 'open-sesame 'rosebud))

;;((peter-acc 'open-sesame 'withdraw) 50) -> withdraws 50
;;((peter-acc 'open-sesame 'deposit) 50) -> deposit 50

;;((peter-acc 'open-sesa 'withdraw) 50) -> yields wrong password

;;((paul-acc 'open-sesame 'withdraw) 50) -> yields wrong password

;;((paul-acc 'rosebud 'withdraw) 50) -> withdraws 50 from the same balance as in peter-acc
;;((paul-acc 'rosebud 'deposit) 50) -> deposit 50 to the same balance as in peter-acc
