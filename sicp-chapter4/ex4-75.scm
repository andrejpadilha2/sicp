;; not my solution

(define (singleton-stream? s)
  (and (not (stream-null? s))
       (stream-null? (stream-cdr s))))
 
(define (uniquely-asserted operands frame-stream)
  (stream-flatmap	;; we will apply a function on every single frame of the input stream of frames
   (lambda (frame)	;; for each frame
     (let ((result-stream (qeval (negated-query operands) ;; we call "result-stream" as the result of qeval with the negated-query (which is simply the car of the query) of the original query and the stream of only one frame
                           (singleton-stream frame))))
       (if (singleton-stream? result-stream) ;; if result-stream (that's the extension of the input frame) is unique, 
           result-stream ;; then it correctly returns that stream
           the-empty-stream)))	;; if it's not unique, it returns the empty stream
   frame-stream))
