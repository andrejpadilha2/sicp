(define (simple-flatten stream)
	(stream-map stream-car ;; we created a singleton because we were using a lambda function in each frame individually...now we are mapping a given function on ALL stream of frames, and then the result should be equivalent to singleton on a individual frame....the given function that we are looking for is "stream-car", which returns a list of one frame, just like (singleton-stream frame)
		(stream-filter (lambda (s) (not (stream-null? s))) stream)))
		

