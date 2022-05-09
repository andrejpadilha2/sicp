;;(car ''abracadabra) -> the interpreter prints back only "quote"....what is happening?

;; when we type only 'abracadabra, the interpreter prints back the word abracadabra...
;;if we use two quotation marks the interpreter actually does (car (quote (quote abracadabra)))
;; the first quote quotes the (quote abracadabra), making it become a list of two elements, "quote" and "abracadabra"...when you car that list
;; it will naturally return the word "quote"
