(define (make-account balance password)
	(let ((trials 1))
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
					(else (error "Unknown request -- MAKE-ACCOUNT"
						m))
				)
				(if (>= trials 7)
					calling-the-cops
					(begin 
						(set! trials (+ trials 1))
						(lambda (x) "Incorrect password")
					)
				)
			)
		)
		dispatch
	)
)

(define (calling-the-cops x) "Calling the cops")

(define a1 (make-account 100 'pass))
