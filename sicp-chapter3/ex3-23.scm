;;;;;;;;so now I will start, below, the exercise AGAIN;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; check my notes to understand the abstraction better

(define (front-ptr deque) (car deque))
(define (rear-ptr deque) (cdr deque))

(define (make-deque) (cons '() '()))

(define (set-front-ptr! deque item) (set-car! deque item))
(define (set-rear-ptr! deque item) (set-cdr! deque item))

(define (empty-deque? deque) (or (null? (front-ptr deque)) (null? (rear-ptr deque))))

(define (front-deque deque) 
	(if (empty-deque? deque)
		(error "FRONT-DEQUE called with an empty deque")
		(car (front-ptr deque))
	)
)

(define (rear-deque deque) 
	(if (empty-deque? deque)
		(error "REAR-DEQUE called with an empty deque")
		(car (rear-ptr deque))
	)
)

(define (set-next-item! current-item next-item)
	(set-cdr! (cdr current-item) next-item)
)

(define (set-previous-item! current-item previous-item)
	(set-car! (cdr current-item) previous-item)
)

(define (next-item item)
	(cddr item)
)

(define (previous-item item)
	(cadr item)
)

(define (front-insert-deque! deque item)
	(let ((new-item (cons item (cons '() '()))))
		(cond ((empty-deque? deque)
			(set-front-ptr! deque new-item)
			(set-rear-ptr! deque new-item)
			(print-deque deque))
					
		(else
			(set-next-item! new-item (front-ptr deque))
			(set-previous-item! (front-ptr deque) new-item)
			(set-front-ptr! deque new-item)
			(print-deque deque))
		)		
	)
)

(define (rear-insert-deque! deque item)
	(let ((new-item (cons item (cons '() '()))))
		(cond ((empty-deque? deque)
			(set-front-ptr! deque new-item)
			(set-rear-ptr! deque new-item)
			(print-deque deque))
					
		(else
			(set-previous-item! new-item (rear-ptr deque))
			(set-next-item! (rear-ptr deque) new-item)
			(set-rear-ptr! deque new-item)
			(print-deque deque))
		)		
	)
)

(define (front-delete-deque! deque)
	(cond ((empty-deque? deque)
			(error "DELETE! called with an empty deque"))
		((and (eq? (next-item (front-ptr deque)) '()) (eq? (previous-item (front-ptr deque)) '())) 
			(set-front-ptr! deque '())
			(set-rear-ptr! deque '())
			(print-deque deque)
			)
		(else
			(set-previous-item! (next-item (front-ptr deque)) '())
			(set-front-ptr! deque (next-item (front-ptr deque)))
			(print-deque deque))
		)
)

(define (rear-delete-deque! deque)
	(cond ((empty-deque? deque)
		(error "DELETE! called with an empty deque"))
		((and (eq? (next-item (front-ptr deque)) '()) (eq? (previous-item (front-ptr deque)) '())) 
			(set-front-ptr! deque '())
			(set-rear-ptr! deque '())
			(print-deque deque)
			)
		(else
			(set-next-item! (previous-item (rear-ptr deque)) '())
			(set-rear-ptr! deque (previous-item (rear-ptr deque)))
			(print-deque deque))
		)
)

(define (print-deque deque)
	(define (print-item item)
		(cond   ((null? item) item)
			((null? (next-item item)) (car item))
			(else (cons (car item) (print-item (next-item item))))
		)
	)
	
	(display (print-item (front-ptr deque)))
	(newline)
)





































