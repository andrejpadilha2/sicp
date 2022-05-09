(define (square-list items)
	(if (null? items)
		items
		(cons (square (car items)) (square-list (cdr items)))
	)
)

(define (square-list2 items)
	(define (iter things answer)
		(if (null? things)
			answer
			(iter (cdr things) (cons (square (car things)) answer))
		)
	)
	(iter items nil)
)
;;this will work in reverse because it gets the first term of the pair "things" and put it in front of the previously calculated square (which is going from left to right in a list order)...so "answer" starts as () -> (1) -> (2, 1) -> (9, 2, 1) -> (16, 9, 2, 1) for a starting list of (1, 2, 3, 4)

(define (square-list3 items)
	(define (iter things answer)
		(if (null? )
			answer
			(iter (cdr things) (cons answer (square (car things))))
		)
	)
	(iter items nil)
)

;;answer starts as (), but "cons" only adds a new element to the front of the list if the item is not a list itself...if the item is a list, then it will treat it as a list and add that list as the first element of the main list...-> (() . 1) -> (( () . 1) . 2) -> ((( () . 1) . 2) . 9) -> (((( () . 1) . 2) . 9) . 16) -> it's not constructing a list, it's constructing several pairs inside other pairs, where there's no final null cdr.

;;(define nil (list))
;;1 ]=> (list)
;;;Value: ()
;;1 ]=> (define list1 (list 2 3 4))
;;Value: list1
;;1 ]=> list1
;;Value: (2 3 4)
;;1 ]=> (cons 1 list1)
;;Value: (1 2 3 4)
;;1 ]=> (cons (list 1) list1)
;;Value: ((1) 2 3 4)
