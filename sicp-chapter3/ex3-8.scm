 (define f (let ((second-last-call 0) 
                 (last-call 0)) 
            	(lambda (n) 
		       (set! second-last-call last-call) 
		       (set! last-call n) 
               second-last-call)
            )
) 


;;(+ (f 0) (f 1)) -> from left to right -> (+ 0 0) -> 0
;;(+ (f 0) (f 1)) -> from right to left -> (+ 1 0) -> 1

;;this is because when we use set!, the order that we are "setting" the variables to the new values matter
