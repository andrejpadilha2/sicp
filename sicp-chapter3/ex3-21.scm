;;when the interpreter prints the queue, it is actually printing the pair that represents that queue..that pair consists of the whole queue (a b c d) and the last item of the queue (d)...that's why it's printing "twice"


(define (print-queue queue)
	(front-prt queue)
)
