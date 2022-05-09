(define (make-unbound? exp) (tagged-list? exp 'make-unbound!))

;; add in the evaluator the following clause
;; ((make-unbound? exp) (unbind-variable exp env))

;;let's say make-unbound is called in the following form
;; (make-unbound! <var>), which means it will remove the binding of <var> in the CURRENT environment only
;; if it wishes to remove from all other environments, it will need to create another procedure
;; make-unbound! returns an error if there's no variable <var> in the current environment

(define (unbind-variable exp env)
	(make-unbound (cadr exp) env))

(define (unbound-variable exp) (cadr exp))

(define (make-unbound! variable env) 
         (let ((vars (frame-variables (first-frame env))) 
                   (vals (frame-values (first-frame env)))) 
                 (define (unbound vars vals new-vars new-vals) 
                         (cond ((null? vars) 
                                    (error "variable is not in the environment -- MAKE-UNBOUND" variable)) 
                                  ((eq? (car vars) variable) 
                                   (set-car! env  
                                                 (cons (append new-vars (cdr vars))  
                                                          (append new-vals (cdr vals))))) 
                                  (else (unbound (cdr vars) (cdr vals)  
                                                           (cons (car vars) new-vars)  
                                                           (cons (car vals) new-vals))))) 
                 (unbound vars vals '() '()))) 

;; this implementation is using the frame implementation of the book SICP, that is, a frame is a pair of a list of VARS and a list of VALS
