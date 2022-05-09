;; from exercise 3.6
(define random-init 0) ;;mockup version
(define (rand-update x) (+ x 1)) ;;mockup version

(define rand
	(let ((x random-init))
		(define (dispatch message)
			(cond  ((eq? message 'generate)
					(begin (set! x (rand-update x))
						x)
				)
				((eq? message 'reset) 
					(lambda (new-value) (set! x new-value))
				)
			)
		)
		dispatch
	)
)

;; from the book
(define random-numbers
	(cons-stream random-init
		(stream-map rand-update random-numbers)))
		
(define (random-number-generator command-stream) 
	(define random-number 
		(cons-stream random-init 
			(stream-map (lambda (number command)  
				(cond ((null? command) the-empty-stream) 
					((eq? command 'generator) 
						(random-update number)) 
					((and (pair? command)  (eq? (car command) 'reset)) 
						(cdr command)) 
					(else  
						(error "bad command -- " commmand))))
				random-number command-stream)))
         random-number)
