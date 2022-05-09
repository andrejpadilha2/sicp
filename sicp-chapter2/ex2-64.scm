;; partial-tree starts with the whole list and the length of that tree as arguments

;; for each iteration, it calculates the size of the left branch (left-size) by taking the quotient of the division of "length of the list minus 1" by 2
;; with left-size it calls itself again with all the elements and left-size as arguments, so this is the "left-result"
;; then it makes "left-tree" as the car of left-result
;; and non-left-elements as the cdr of left-result
;; it calculates the size of the right side as "n - (left-size +1)"


;;it defines "this-entry" as the car of the non-left-elements
;; then it defines "right-result" as another recursive call to "partial-tree", with the (cdr of non-left-elements) as the list and "right-size" as the size

;; it then defines "right-tree" as the car of "right-result" (just like the left tree)
;; remaining-elements is the cdr of "right-result"

;; it ends creating a pair of the tree (this-entry left-tree right-tree) and the remaining-elements

;; when it reaches the end of the recursion, it creates a pair of the empty-list and the element itself
