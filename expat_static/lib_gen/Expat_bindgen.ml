open Ctypes

let _ =
  let fmt = Format.formatter_of_out_channel (open_out "lib/Expat_stubs.c") in
  Format.fprintf fmt "#include <expat.h>@.";
  Cstubs.write_c fmt ~prefix:"caml_" (module Expat_bindings.C);

  let fmt = Format.formatter_of_out_channel (open_out "lib/Expat_generated.ml") in
  Cstubs.write_ml fmt ~prefix:"caml_" (module Expat_bindings.C)
