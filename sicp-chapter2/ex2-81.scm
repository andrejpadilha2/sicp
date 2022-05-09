 ;;a) it will get into an infinite loop, always applying the same "coercion" (which actually is not a coercion)
 
 ;;b) no. If there's no procedure defined for the type of arguments (say, two rational numbers), it will then check if there's any coercion that will transform type 1 into type 2 (or vice-versa). Since there is no coercion defined for that (originally, before Louis Reasoner changes), it would simply inform that there's no operation defined for the arguments
 
 ;;c) 
