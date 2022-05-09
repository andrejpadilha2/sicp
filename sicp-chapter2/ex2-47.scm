(define (make-frame-1 origin edge1 edge2)
	(list origin edge1 edge2)
)

(define (make-frame-2 origin edge1 edge2)
	(cons origin (cons edge1 edge2))
)


(define (origin-1 frame)
	(car frame)
)

(define (edge1-1 frame)
	(cadr frame)
)

(define (edge2-1 frame)
	(caddr frame)
)

(define (origin-2 frame)
	(car frame)
)

(define (edge1-2 frame)
	(car (cdr frame)) ;;(which is the same as edge1-1, that is, (cadr frame)
)

(define (edge2-2 frame)
	(cdr (cdr frame))
)
