;;remember that (magnitude z) is defined as

;; (define (magnitude z) (apply-generic 'magnitude z)) 

;; and apply-generic is defined as

;;(define (apply-generic op . args)
;;	(let type-tags (map type-tag args)))
;;		(let proc (get op type-tags)))
;;			(if proc
;;				(apply proc (map contents args))
;;				(error
;;				"No method for these types -- APPLY-GENERIC"
;;				(list op type-tags))))))


;;'magnitude wasn't put in the table, so it would never find that operation....Alyssa gives a solution to that, simply putting it in the table

;;we also need to remember that the rectangular and polar packages are ALREADY installed, so we have the procedures magnitude for rectangular form and magnitude for polar form....we simply didn't have the procedure magnitude for COMPLEX form (which rectangular and polar are subsets of)

;;if we evaluate (magnitude z) after that we have

;; the first iteration ripping off the 'complex tag, and a second iteration actually computing the magnitude in either the rectangular or polar form
