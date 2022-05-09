;; the definition of factorial, below, is here just to make it easier to copy and paste in the evaluator/compiler
(define (factorial n)
	(if (= n 1)
		1
		(* (factorial (- n 1)) n)))
	
;; n = 1 -> total pushes = 8 ------ maximum-depth = 3
;; n = 2 -> total pushes = 18 ------ maximum-depth = 6
;; n = 3 -> total pushes = 28 ------ maximum-depth = 9
;; n = 4 -> total pushes = 38 ------ maximum-depth = 12
;; n = 5 -> total pushes = 48 ------ maximum-depth = 15
;; n = 20 -> total pushes = 199 ------ maximum-depth = 60
;; n = 100 -> total pushes = 998 ------ maximum-depth = 300 (maybe some error here, because the last digits are all 0s)
;; n = 1000 -> total pushes = 9998 ------ maximum-depth = 3000 (maybe some error here, because the last digits are all 0s)


;;for the COMPILED VERSION
;; maximum-depth (factorial n) = 3*n
;; total pushes (factorial n) = 8 + 10*n


;;for the INTERPRETED VERSION
;; maximum-depth (factorial n) = 3 + 5 * n
;; total pushes (factorial n) = 16 + 32 * (n - 1)


;; Ratio of total-pushes in COMPILED VERSION to the INTERPRETED VERSION -> (8+10n)/(-16+32n) -> for large n, the ratio is 5/16
;; Ratio of maximum-depth in COMPILED VERSION to the INTERPRETED VERSION -> 3n/(3+5n) -> for large n, the ratio is 3/5


;; * Results are slightly different than other online solutions because I modified the compiler to add scan-out-defines

;; for the HAND-TAILORED MACHINE VERSION
;; n = 1 -> total pushes = 0 ------ maximum-depth = 0
;; n = 2 -> total pushes = 2 ------ maximum-depth = 2
;; n = 3 -> total pushes = 4 ------ maximum-depth = 4
;; n = 4 -> total pushes = 6 ------ maximum-depth = 6
;; n = 5 -> total pushes = 8 ------ maximum-depth = 8
;; maximum-depth (factorial n) = 2n - 2
;; total pushes (factorial n) = 2n - 2

;; Ratio of total-pushes in HAND-TAILORED MACHINE VERSION to the INTERPRETED VERSION -> (2n-2)/(-16+32n) -> for large n, the ratio is 1/16
;; Ratio of maximum-depth in HAND-TAILORED MACHINE VERSION to the INTERPRETED VERSION -> (2n-2)/(3+5n) -> for large n, the ratio is 2/5

;; so we can see that the hand-tailored machine version is still faster!

;; b) I can still add more improvements from the last exercises (which I will surely do)....and I just did....finished the "open-coded" primitives
;; now, the results
;; n = 1 -> total pushes = 5 ------ maximum-depth = 3
;; n = 2 -> total pushes = 8 ------ maximum-depth = 3
;; n = 3 -> total pushes = 11 ------ maximum-depth = 5
;; n = 4 -> total pushes = 14 ------ maximum-depth = 7
;; n = 5 -> total pushes = 17 ------ maximum-depth = 9
;; n = 20 -> total pushes = 62 ------ maximum-depth = 39

;; it's a really good improvement, and now it is closer to the hand-tailored machine version

