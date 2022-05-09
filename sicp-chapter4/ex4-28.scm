;; I just lost my answer here


;; the key takeaway is that a procedure, when passed as an argument to another procedure, would not be identified as a procedure in the next application, it would actually be a THUNK and apply would return an error

;; in my case I had an infinite loop in (list-of-delayed-args arguments env) within apply, and I don't know why
