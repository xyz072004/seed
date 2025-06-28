rockspec_format = "3.0"
package = "seed"
version = "dev-1"
source = {
   url = "git+https://github.com/xyz072004/seed.git",
}
description = {
   homepage = "https://072004.xyz/software/seed",
   license = "MIT",
}
build_dependencies = {
   "luarocks-build-fennel",
   "fennel",
}
build = {
   type = "fennel",
   modules = {
      ["seed.element"] = "src/seed/element.fnl",
      ["seed.cell"] = "src/seed/cell.fnl",
   },
}