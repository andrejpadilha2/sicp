;; fibonacci would run slower

;; with memoization:
;; the first output would be: 100

;; the second output would be: 1

;; this is why when it memoizes, only the first time (id 10) is called it will enter it's body....the next time it's called, the value "10" is already memoized, so it will only "set! count (+ count 1)" once

;; without memoization:
;; the first output would be: 100

;; the second output would be: 2
