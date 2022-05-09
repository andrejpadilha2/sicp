;; in the case of "disjoin", we would only see the results of the first disjunct, instead of seeing the results of all the disjuncts interleaved

;; in stream-flatmap, we could potentially see the result of the application of a procedure in only the first frame of the stream of frames, instead of seeing the result interleaved with the other frames of the input stream
