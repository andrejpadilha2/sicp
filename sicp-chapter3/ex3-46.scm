suppose the two processes are already running, both serialized

at the same time they are inside the (eq? m 'acquire) clause

both enter the (test-and-set! cell) procedure

inside the test-and-set! procedure, both test (if (car cell) ...) at the same time

now let's say P1 is false, so it enter (begin ....)

before it (set-car! cell true), process 2 evaluates (car cell) as well and cell is still false, because it wasn't set to true yet. That's when the problem arrise. Both processes will be executed and use the same resource not serialized, even though they were supposed to be serialized.


