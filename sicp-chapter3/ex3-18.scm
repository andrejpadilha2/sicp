(define (has-loop? lis) 
   (define (iter searchlist seen) 
     (cond ((not (pair? searchlist)) #f) 
           ((memq searchlist seen) #t) 
           (else (or (iter (car searchlist) (cons searchlist seen)) 
                     (iter (cdr searchlist) (cons searchlist seen)))))) 
   (iter lis '())) 
   
 ;;source: http://community.schemewiki.org/?sicp-ex-3.18
