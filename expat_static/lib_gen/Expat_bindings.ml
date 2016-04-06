open Ctypes
open PosixTypes

module C(F: Cstubs.FOREIGN) = struct

type raw_xmlparser = unit
type xmlparser = raw_xmlparser ptr
let xmlparser = ptr void

let start_element_handler_t = xmlparser @-> string @-> ptr string_opt @-> returning void
let end_element_handler_t = xmlparser @-> string @-> returning void
let character_data_handler_t = xmlparser @-> ptr char @-> int @-> returning void

type start_handler = xmlparser -> string -> string list -> unit
type end_handler = xmlparser -> string -> unit
type character_handler = xmlparser -> string -> unit

let set_element_handler = F.foreign "XML_SetElementHandler" (xmlparser @-> Foreign.funptr start_element_handler_t @-> Foreign.funptr end_element_handler_t @-> returning void)

let set_character_data_handler = F.foreign "XML_SetCharacterDataHandler" (xmlparser @-> Foreign.funptr character_data_handler_t @-> returning void)

let parse = F.foreign "XML_Parse" (xmlparser @-> string @-> int @-> int @-> returning void)

let parser_create = F.foreign "XML_ParserCreate" (ptr void @-> returning xmlparser)

end
