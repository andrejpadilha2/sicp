;; 3125 before and only 120 after

;;this is my first approach, but after reading http://community.schemewiki.org/?sicp-ex-4.40 I noticed that I'am actually solving a part of the program determiniscally, which is not adequate...

;;(define (multiple-dwelling)
;;	(let* 	((baker (amb 1 2 3 4))
;;		(cooper (amb 2 3 4 5)))
;;		(let ((fletcher (amb (filter-list (lambda (i) (not (= (abs (- i cooper)) 1))) (list (2 3 4))))))
;;			(let ((smith (amb (filter-list (lambda (i) (not (= (abs (- i fletcher)) 1))) (list (1 2 3 4 5))))))
;;				(let ((miller (amb (filter-list (lambda (i) (> i cooper)) (list (1 2 3 4 5))))))
;;					(list 	(list 'baker baker)
;;						(list 'cooper cooper)
;;						(list 'fletcher fletcher)
;;						(list 'miller miller)
;;						(list 'smith smith)))))))

;; so I started again
(define (multiple-dwelling)
	(let ((baker (amb 1 2 3 4 5)))
		(require (not (= baker 5)))
		(let ((cooper (amb 1 2 3 4 5)))
			(require (not (= cooper 1)))
			(let ((fletcher (amb 1 2 3 4 5)))
				(require (not (= fletcher 5)))
				(require (not (= fletcher 1)))
				(require (not (= (abs (- fletcher cooper)) 1)))
				(let ((smith (amb 1 2 3 4 5)))
					(require (not (= (abs (- smith fletcher)) 1)))
					(let ((miller (amb 1 2 3 4 5)))
						(require (> miller cooper))
						(require (distinct? (list baker cooper fletcher miller smith)))
						(list 	(list 'baker baker)
							(list 'cooper cooper)
							(list 'fletcher fletcher)
							(list 'miller miller)
							(list 'smith smith))))))))
