;;tree-list1 appends the left branch, entry and right branch, in that order, recursively...when "tree-list1" is called, it's called with ONLY the left-branch as argument (one time) and ONLY the right-branch as argument (one time), for each iteration

;;tree-list2 on the other hand calls "copy-to-list" with the left-branch AND the whole "cons (entry tree) [another copy-to-list call]" as arguments





;; for the first tree in figure 2.16

;;tree-list1 will produce the following list: 
;;[left branch] 7 [right branch]
;; ....
;; (1 3 5 7 9 11)





;;tree-list2 will produce the following list:
;;  (copy-to-list tree '())
;; (copy-to-list [left branch1] (cons 7 (copy-to-list [right branch] '())))
;; (copy-to-list [left branch]1 (cons 7 (copy-to-list '() (cons 9 (copy-to-list [right branch2] '())))))
;; (copy-to-list [left branch1] (cons 7 (copy-to-list '() (cons 9 (copy-to-list '() (cons 11 (copy-to-list '() '())))))))
;; (copy-to-list [left branch1] (cons 7 (copy-to-list '() (cons 9 (copy-to-list '() (cons 11 '()))))))
;; (copy-to-list [left branch1] (cons 7 (copy-to-list '() (cons 9 (copy-to-list '() (11))))))
;; (copy-to-list [left branch1] (cons 7 (copy-to-list '() (cons 9 (11)))))
;; (copy-to-list [left branch1] (cons 7 (copy-to-list '() (9 11))))
;; (copy-to-list [left branch1] (cons 7 (9 11)))
;; (copy-to-list [left branch1] (7 9 11))
;; (copy-to-list [left branch2] (cons 3 (copy-to-list [left branch1->right-branch1] (7 9 11))))
;; (copy-to-list [left branch2] (cons 3 (copy-to-list '() (cons 5 (copy-to-list '() (7 9 11))))))
;; (copy-to-list [left branch2] (cons 3 (copy-to-list '() (cons 5 (7 9 11)))))
;; (copy-to-list [left branch2] (cons 3 (copy-to-list '() (5 7 9 11))))
;; (copy-to-list [left branch2] (cons 3 (5 7 9 11)))
;; (copy-to-list [left branch2] (3 5 7 9 11))
;; (copy-to-list '() (cons 1 (copy-to-list '() (3 5 7 9 11))))
;; (copy-to-list '() (cons 1 (3 5 7 9 11)))
;; (copy-to-list '() (1 3 5 7 9 11))
;; (1 3 5 7 9 11)

;;I can see that tree-list2 is slower, but I can't right now tell the order of growth
