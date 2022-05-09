(define (make-semaphore n)
	(let ((mutex-list (create-mutex-list n)))
		(define (the-semaphore m mutex-list-arg)
			(cond 
				((eq? m 'acquire)
					(if (car mutex-list-arg)
						(if (not (eq? (cdr mutex-list-arg) '()))
							(the-semaphore 'acquire (cdr mutex-list-arg))
							((car mutex-list-arg) 'acquire) ; retry
						)
						((car mutex-list-arg) 'acquire)
					)
				)
				((eq? m 'release) 
					(clear! (car mutex-list-arg))
				)
			)
		)
		the-semaphore
	)
)

(define (make-mutex)
	(let ((cell (list false)))
		(define (the-mutex m)
			(cond ((eq? m 'acquire)
				(if (test-and-set! cell)
					(the-mutex 'acquire))
				) ; retry
				((eq? m 'release) (clear! cell))
			)
		)
		the-mutex
	)
)

(define (create-mutex-list n)
	(if (= n 1)
		(list (make-mutex))
		(cons (make-mutex) (create-mutex-list (- n 1)))
	)
)

(define (clear! cell)
	(set-car! cell false)
)

(define (test-and-set! cell)
	(if (car cell)
		true
		(begin (set-car! cell true)
			false)
	) 
)

; I didn't really understand this one

