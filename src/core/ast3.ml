module W = Warnings
module S = Map.Make (String)

open Ppxlib
open Sexplib.Std


(*the terms in DVT already have ortac stuff added to them. what you really want is the terms from the original spec which are
the same type as these terms.
DECISION. DRV.T IS TOO FAR DOWN. NEED TO START FROM TAST and generate a
1) Translated.structure item list (but with the original terms)
2) type? think about this later. the type_ in a Drv.t doesnt store arguments, aliasing, etc.
  but i don't think i need any of that? maybe for polymorphic type if you have a polymorphic field.

modify file translate.ml to turn a TAST into a Translated.structure item list.
from there turn into this.
*)

(*all the types that are supported for state fields *)
type typ =
  | Int
  | String
  | Bool
  | List of typ 


type term = {
  txt : string;
  translation : ((expression, W.t) result [@sexp.opaque]);
}
[@@deriving sexp_of]

type arg = {arg_name : string; arg_label : arg_label; arg_type: typ}


(*maps the name of the fn to its argument types
*)
type cmd=  (arg list) S.t

(*will get this from the models of t (sut)
since the other types are stored as strings might as well
i think the types of the models may be thrown out by the time you get to the tast ...
definitely thrown out by the time you get to drv?
field name * field type
  really does not support polymorphism, need a much better type for types than strings
*)
type state = (string * Gospel.Ttypes.ty) list

(*type sut = NOT NECESSARY, just do module_name.t *)

type arb_cmd = (string list) S.t
(*pair up cmd constructor with Qcheck generators for args.
if arg list is empty then do Gen.return
*)

(*to get init_sut assume method in the gospel file called create? which describes how the
fields in the state are set*)
(*assume for now <5 args or whatever the highest map is *)

type init_state = expression list
  (* <- just a tuple of value. get these values from the ensures of create in gospel which in the drv.t is a term list. you have to go into the term to find the state_element_n = __expression__.
     ensures condition.*)



(*get this from the spec of the function for that state
  if <all the requires and all the checks> then <correct ending state> else <same state as passed in
  where correct ending state is computed as
  <search through the ensures for state_entry_n = ____> <- START HERE where is this put exactly? what does this look like?
  right now packaged as
  for each function, <a list of the arguments>, <A list of all the requires and checks>,
  <a list of n equalities, where there are n fields in the state>
*)

type next_state = (arg list * term list * term list) S.t 

(*command name, arguments, can raise exn*)
type run = (arg list * bool) S.t


(*iff checks then raise invalid argument
iff a raises then raise that Exn (dont support this for right now)
Otherwise need to look in the ensures for result = __
for each fn (all the checks, the result = in the ensures)
*)
type postcond = (arg list * term list * term) S.t

(*assumptions:
  1. the system under test is called 't' in the gospel file
  2. all of the functions take values of base types as arguments
  3. system under test*)