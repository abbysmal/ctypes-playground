open Expat

let () =
  let ch = open_in "food.xml" in
  let len = in_channel_length ch in
  let xml_buffer = Bytes.create len in
  really_input ch xml_buffer 0 len;
  close_in ch;
  let parser = Expat.parser_create () in
  Expat.set_element_handler parser (fun _ s _ -> Printf.printf "<%s>" s) (fun _ s -> Printf.printf "</%s>\n" s);
  Expat.set_character_data_handler parser (fun _ s -> Printf.printf "%s" s);
  Expat.parse parser xml_buffer;
  ()
