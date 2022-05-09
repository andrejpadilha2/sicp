;; Yes, it would be faster.
;; It just generates two numbers and test it to check if the sum of their squares is smaller than the biggest square possible ("high * high"). Only then it generates the third integer and creates another test. The third integer is directly dependent into the values of the first two, and it doesn't even use "an-integer-between" to be generated.


