;; a) we can substitute (assign n (reg val)) and (restore val) to only one (restore n)...
;; this will invert the values that n and val hold...n will now hold Fib(n-1) and val will hold Fib(n-20, but the + operation will still work

;; b) 
(define (make-save inst machine stack pc)
	(let ((reg (get-register machine (stack-inst-reg-name inst))))
		(lambda ()
			(push stack (cons (stack-inst-reg-name inst) (get-contents reg)))
			(advance-pc pc))))
			
(define (make-restore inst machine stack pc)
	(let ((reg (get-register machine (stack-inst-reg-name inst))))
		(lambda ()
			(let ((popped-reg (pop stack)))
				(if (= (stack-inst-reg-name inst) (car popped-reg))
					(begin (set-contents! reg (cdr popped-reg))
						(advance-pc pc))
					(error "The value to be restored is not from the corresponding register - MAKE-RESTORE" (stack-inst-reg-name inst)))))))
					
;; c) skipping
				
