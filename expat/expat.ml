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
   let start' p s a =
     let a = ptr_string_opt_to_list a in
     start p s a in
   let end' p s =
     let s = s in
     ed p s in
   aux parser start' end'
  )

let set_character_data_handler =
  let aux = foreign "XML_SetCharacterDataHandler" (xmlparser @-> funptr character_data_handler_t @-> returning void) in
  (fun parser handler ->
   let handler' p c l =
     let c = CArray.from_ptr c l |> CArray.to_list |> List.map Char.escaped |> List.fold_left (^) "" in
     handler p c in
   aux parser handler')

let parse =
  let aux = foreign "XML_Parse" (xmlparser @-> string @-> int @-> int @-> returning void) in
  (fun parser buffer ->
   let len = String.length buffer in
   let i = 0 in
   aux parser buffer len i)

let parser_create =
  let aux = foreign "XML_ParserCreate" (ptr void @-> returning xmlparser) in
  (fun _ -> aux null)
