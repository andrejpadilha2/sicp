;; the purpose is to avoid an infinite loop, where THE-ASSERTIONS would be a stream where
;; stream-car is "assertion" and stream-cdr is THE-ASSERTIONS, creating an infinite loop

;; when it uses a let expression, it creates a new environment with all the previous assertions, that is, THE-ASSERTIONS bind to "old-assertions", and then it updates the value of THE-ASSERTIONS to be a stream where stream-car is "assertion" and stream-cdr is only the previous assertions (forced because of the use of "let"), with no infinite loops
