(define (ripple-carry-adder a-list b-list s-list c) ;;given a 4 bits number
   (let ((c-list (map (lambda (x) (make-wire)) (cdr a-list))) ;;creates c1, c2, c3
         (c-0 (make-wire))) ;;creates c0
     (map full-adder ;;map the full-adder function to the following lists
          a-list ;; (a1 a2 a3 a4)
          b-list ;; (b1 b2 b3 b4)
          (append c-list (list c-0))  ;; creates a list (c1 c2 c3 c0)
          s-list ;; (s1 s2 s3 s4)
          (cons c c-list))  ;;creates a list (c c1 c2 c3)
     'ok)
) 


(define (full-adder a b c-in sum c-out)
	(let ((s (make-wire))
		(c1 (make-wire))
		(c2 (make-wire)))
	(half-adder b c-in s c1)
	(half-adder a s sum c2)
	(or-gate c1 c2 c-out)
'ok))
