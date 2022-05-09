(define (install-scheme-number-package) 
   ;; ... 
   (put 'equ? '(scheme-number scheme-number) =) 
   'done) 
  
 (define (install-rational-package) 
   ;; ... 
   (define (equ? x y) 
     (= (* (numer x) (denom y)) (* (numer y) (denom x)))) 
   ;; ... 
   (put 'equ? '(rational rational) equ?) 
   'done) 
  
 (define (install-complex-package) 
   ;; ... 
   (define (equ? x y) 
     (and (= (real-part x) (real-part y)) (= (imag-part x) (imag-part y)))) 
   ;; ... 
   (put 'equ? '(complex complex) equ?) 
   'done) 
  
 (define (equ? x y) (apply-generic 'equ? x y))
 
 
 
 ;;we basically add (equ? x y) in each package, and then define it in the general arithmetic package in the last line....when apply-generic evaluates for the first time, it will check the type of x and y, and then apply the corresponding implementation
