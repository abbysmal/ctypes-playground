open Foreign
open Ctypes
open PosixTypes

type raw_xmlparser = unit
type xmlparser = raw_xmlparser ptr
let xmlparser = ptr void

let start_element_handler_t = xmlparser @-> string @-> ptr string_opt @-> returning void
let end_element_handler_t = xmlparser @-> string @-> returning void
let character_data_handler_t = xmlparser @-> ptr char @-> int @-> returning void

type start_handler = xmlparser -> string -> string list -> unit
type end_handler = xmlparser -> string -> unit
type character_handler = xmlparser -> string -> unit

let ptr_string_opt_to_list ptr =
  let rec aux i acc =
    match !@(ptr +@ i) with
    | Some s -> aux (i + 1) (s::acc)
    | None -> acc in
  aux 0 []

let set_element_handler =
  let aux = foreign "XML_SetElementHandler" (xmlparser @-> funptr start_element_handler_t @-> funptr end_element_handler_t @-> returning void) in
  (fun parser (start : start_handler) (ed : end_handler) ->
   let start' parser element attributes =
     let attributes' = ptr_string_opt_to_list attributes in
     start parser element attributes' in
   aux parser start' ed
  )

let set_character_data_handler =
  let aux = foreign "XML_SetCharacterDataHandler" (xmlparser @-> funptr character_data_handler_t @-> returning void) in
  (fun parser handler ->
   let handler' parser content length =
     let content' = CArray.from_ptr content length |> CArray.to_list |> List.map Char.escaped |> List.fold_left (^) "" in
     handler parser content' in
   aux parser handler')

let parse =
  let aux = foreign "XML_Parse" (xmlparser @-> string @-> int @-> int @-> returning void) in
  (fun parser buffer ->
   let len = String.length buffer in
   aux parser buffer len 0)

let parser_create =
  let aux = foreign "XML_ParserCreate" (ptr void @-> returning xmlparser) in
  (fun _ -> aux null)
