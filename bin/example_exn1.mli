exception Exn1 of int
exception Exn2 of int


val silly : int -> int
(*@
raises Exn1 s -> 0 = 0
raises Exn1 t -> 1 = 1
raises Exn2 t -> 2 = 2 | Exn2 w -> 3 = 3
*) 
