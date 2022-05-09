(define balance 100)

(define (withdraw amount)
	(if (>= balance amount)
		(define balance (- balance amount))
		"Insufficiente funds"
	)
)

;;this will never work, since we already defined balance above....that's why we are introduced to "set!"
