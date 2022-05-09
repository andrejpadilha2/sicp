;;Let's say a1 is already protected and a2 is already protected...then when one of the process tries to access a proteced procedure, it will not stall because it can now compair the number of each account and choose the lowest one

(define (serialized-exchange account1 account2)
	(let   ((serializer1 (account1 'serializer))
		(serializer2 (account2 'serializer))
		(account1-number (account1 'number))
		(account2-number (account2 'number))
		)
		(if (> account1-number account2-number)
			((serializer1 (serializer2 exchange))
			account1
			account2)
			((serializer2 (serializer1 exchange))
			account1
			account2)
		)
	)
)


