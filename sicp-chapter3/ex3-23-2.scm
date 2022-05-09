(define (front-ptr deque) (car deque))

(define (rear-ptr deque) (cdr deque))

(define (set-front-ptr! deque item) (set-car! deque item))

(define (set-rear-ptr! deque item) (set-cdr! deque item))

(define (empty-deque? deque) (or (null? (front-ptr deque)) (null? (rear-ptr deque))))

(define (make-deque) (cons '() '()))

(define (front-deque deque) 
	(if (empty-deque? deque)
		(error "FRONT called with an empty deque")
		(car (front-ptr deque))
	)
)

(define (rear-deque deque) 
	(if (empty-deque? deque)
		(error "REAR called with an empty deque")
		(car (rear-ptr deque))
	)
)

(define (rear-insert-deque! deque item)
	(let ((new-pair (cons item '())))
		(cond ((empty-deque? deque)
			(set-front-ptr! deque new-pair)
			(set-rear-ptr! deque new-pair)
			(print-deque))
					
		(else
			(set-cdr! (rear-ptr deque) new-pair)
			(set-rear-ptr! deque new-pair)
			(print-deque))
		)		
	)
)

(define (front-insert-deque! deque item)
	(let ((new-pair (cons item deque)))
		(cond ((empty-deque? deque)
			(set-front-ptr! deque new-pair)
			(set-rear-ptr! deque new-pair)
			(print-deque))
					
		(else
			(set-front-ptr! deque new-pair)
			(print-deque))
		)		
	)
)

(define (front-delete-deque! deque)
	(cond ((empty-deque? deque)
		(error "DELETE! called with an empty deque"))
	(else
		(set-front-ptr! deque (cdr (front-ptr deque)))
		(print-deque))
	)
)

;;;;;it's impossible to implement rear-delete-deque! using this data abstraction I started with, so I will need to think of a data abstraction which keeps track of the next item in the list, but also the previous (somehow)!!!!!!!!!

(define (rear-delete-deque! deque)
	(cond ((empty-deque? deque)
		(error "DELETE! called with an empty deque"))
	(else
		(set-rear-ptr! deque (cdr (front-ptr deque)))
		(print-deque))
	)
)

;;;;;;;;so now I will start, below, the exercise AGAIN;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; check my notes to understand the abstraction better and ex3-23.scm for a solution






















