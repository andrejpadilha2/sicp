(define (install-scheme-number-package) 
   ;; ... 
   (put '=zero? 'scheme-number (lambda (x) (= x 0)))
   'done)
  
 (define (install-rational-package) 
   ;; ... 
   (put '=zero? 'rational (lambda (x) (= (numer x) 0)))
   'done)
  
 (define (install-complex-package) 
   ;; ... 
   (put '=zero? 'complex (lambda (x) (= (real-part x) (imag-part x) 0)))
   'done)
  
 (define (=zero? x) (apply-generic '=zero? x))
 
 
 
 ;;we basically add (equ? x y) in each package, and then define it in the general arithmetic package in the last line....when apply-generic evaluates for the first time, it will check the type of x and y, and then apply the corresponding implementation
