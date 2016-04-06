module E = Expat_bindings.C(Expat_generated)
open Ctypes
open PosixTypes

let ptr_string_opt_to_list ptr =
  let rec aux i acc =
    match !@(ptr +@ i) with
    | Some s -> aux (i + 1) (s::acc)
    | None -> acc in
  aux 0 []

let set_element_handler =
  (fun parser start ed ->
   let start' parser element attributes =
     let attributes' = ptr_string_opt_to_list attributes in
     start parser element attributes' in
   E.set_element_handler parser start' ed
  )

let set_character_data_handler =
  (fun parser handler ->
   let handler' parser content length =
     let content' = CArray.from_ptr content length |> CArray.to_list |> List.map Char.escaped |> List.fold_left (^) "" in
     handler parser content' in
   E.set_character_data_handler parser handler')

let parse =
  (fun parser buffer ->
   let len = String.length buffer in
   E.parse parser buffer len 0)

let parser_create =
  (fun _ -> E.parser_create null)
