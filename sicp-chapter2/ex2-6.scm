(define zero (lambda (f) (lambda (y) y)))

(define (add-1 n) (lambda (f) (lambda (x) (f ((n f) x)))))

;; (add-1 zero)

;; (lambda (f) (lambda (x) (f ((lambda (y) y)) x))))

;; (lambda (f) (lambda (x) (f x)))

(define one (lambda (f) (lambda (x) (f x))) )
(define two (lambda (f) (lambda (x) (f (f x))))  )

(define (add a b)
	(lambda (f)
		(lambda (x) 
			((a f) ((b f) x))
		)
	)
)
