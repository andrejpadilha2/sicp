;;as it's reading the register-machine code, it will first assign the pointer to the first place of "here", but then it will substitute and assign it to the second place, so register "a" will hold the value "4"

(define (label-exist? label list-of-labels)
	(assoc label list-of-labels))

(define (extract-labels text receive)
	(if (null? text)
		(receive '() '())
		(extract-labels (cdr text)
			(lambda (insts labels)
				(let ((next-inst (car text)))
					(if (symbol? next-inst)
						(if (label-exist? next-inst insts)
							(error "Label already defined -- EXTRACT-LABELS" next-inst)
							(receive insts
								(cons (make-label-entry next-inst insts) 
									labels)))
						(receive (cons (make-instruction next-inst) 
								insts)
							labels)))))))
							

