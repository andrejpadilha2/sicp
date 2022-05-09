;; I tried to solve this exercise making "compile-and-run" a primitive operation, but I couldn't. Online solutions usually solve it by making it a special case
;; of the interpreter...so I just copied the solution from https://github.com/cxphoe/SICP-solutions/blob/master/Chapter%205-Computing%20with%20Register%20Machines/5.%20Compile/5.48.rkt

; add these to the evaluator.

; ev-compile
;  (save continue)
;  (assign exp (op compile-text) (reg exp))
;  (assign continue (label ev-compile-text))
;  (goto (label eval-dispatch))
; ev-compile-text
;  (restore continue)
;  (assign val (op compile-instructions) (reg val))
;  (goto (reg val))

(define (compile-run? exp)
  (tagged-list? exp 'compile-and-run))

(define (compile-text exp)
  (cadr exp))

(define (compile-instructions text)
  (assemble (statements
             (compile text 'val 'return '()))
             eval-machine))
