;; "u" and "v" are in the same environment that "e3"...but "a" and "b" are not visible to "e3"...but the "set!" procedure changes de value of "u" and "v" while "a" and "b" are accessible inside the inner "let"...

;; but "a" and "b" both need the values of "u" and "v" themselves, so it wouldn't work because that value is "*unassigned*"

;; but in the original form
(define (solve f y0 dt)
  (let ((y '*unassigned*)
        (dy '*unassigned*))
    (set! y (integral (delay dy) y0 dt))
    (set! dy (stream-map f y))
    y))
    
;; it would work, because now y and dy are defined at the same time by the "let"
