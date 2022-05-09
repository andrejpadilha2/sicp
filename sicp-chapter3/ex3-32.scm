http://vishy-ranganath-sicp.blogspot.com/2019/02/sicp-exercise-332-agenda-queue-vs-list.html

EXPLANATION

Let us look more closely at the logic of how action-procedures run. The call sequence is:
action-proc --> after-delay --> add-to-agenda
The action-proc first computes the new value *to be set* on the output wire, and this new value becomes available to the lambda function that is constructed and passed to after-delay.
after-delay adds the delay to the current agenda time and passes this computed time and the lambda function to add-to-agenda. add-to-agenda inserts this pair into a queue that contains other pairs with the same time. All the actions within a time segment are executed one after the other in the order in which they were inserted into the agenda.

The important point to note here is that the simulation is really a record-and-play-later mechanism so the order in which we play should be the order in which we record. Each action affects the state of the circuit wires and the subsequent actions depend on the state created by the preceding actions. The gate output decisions are made whenever the input wires change state but these decisions are applied on the output wires only when propagate executes the lambdas stored in the agenda queues.

Let's look at the behavior of an AND-gate whose inputs change from 0,1 to 1,0 in the same segment.

Let the input wires to the AND-gate be 'inputA' and 'inputB'. Let the output wire be called 'output'
Further, assume that inputA is set to 0 and inputB is set to 1.
Upon wiring up the AND-gate the action procedures will be as follows:

inputA will have one element in its action-proc-list: the procedure 'and-action-procedure'
inputB will also have one element in its action-proc-list: the procedure 'and-action-procedure'

Both the procedures above (actually the same procedure) will be executed as soon as they are added to the action-proc-list of the two input wires. As shown in the call sequence above, 'new-value' is computed to be 0 in both cases since the logical-and of 0 and 1 is 0. Then the lambda function and time are inserted into the agenda. At the end of this process, the agenda will look as follows:

(list 0 (list (3.(queue (lambda 1) (lambda 2)))))

In the queue above, the first lambda function was produced when add-action! was called on inputA and the second lambda function was produced when add-action! was called on inputB. In both cases, new-value is 0.

When 'propagate' is run, it executes lambda 1 first which sets the output to 0 and then it  executes lambda 2 which again sets the output to 0. At the end of this, we have an empty agenda.

Now let's assume that inputA is set to 1. This will trigger the and-action-procedure which will compute new-value to be 1 (since both inputs are 1). Again, after-delay and add-to-agenda are called. The agenda will become:

(list 0 (list (3.(queue (lambda 1))))) <--- Here lambda 1 uses new-value of 1

Now let's assume that inputB is set to 0. This will trigger the and-action-procedure which will compute new-value to be 0 (since inputB is 0). Again, after-delay and add-to-agenda are called. The agenda will become:

(list 0 (list (3.(queue (lambda 1) (lambda 2))))) <--- Here lambda 1 uses new-value of 1 and lambda 2 uses new-value of 0

When 'propagate' is run, it executes lambda 1 first which sets the output to 1 and then it executes lambda 2 which sets the output to 0. At the end of this, we have an empty agenda.
And output is 0. This is the right behavior. The output value changes from 0 to 1 and back to 0 faithfully following the the input combinations of (0, 1), (1, 1) and (1, 0).

If we had used an ordinary list with LIFO behavior, the agenda would have looked like this:

(list 0 (list (3.(list (lambda 2) (lambda 1))))) <--- Here lambda 1 uses new-value of 1 and lambda 2 uses new-value of 0.

When 'propagate' is run, it executes lambda 2 first which sets the output to 0 and then it executes lambda 1 which sets the output to 1. At the end of this, we have an empty agenda.
And output is 1. So for inputs (1, 0) the output is 1 which is wrong.
