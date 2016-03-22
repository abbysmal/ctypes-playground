type xmlparser

type start_handler = xmlparser -> string -> string list -> unit
type end_handler = xmlparser -> string -> unit
type character_handler = xmlparser -> string -> unit

val set_element_handler : xmlparser -> start_handler -> end_handler -> unit
val set_character_data_handler : xmlparser -> character_handler -> unit
val parser_create : unit -> xmlparser
val parse : xmlparser -> string -> unit
