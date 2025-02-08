local setup = function()
  -- Autoformatting Setup
  local conform = require "conform"
  conform.setup {
    formatters = {
      ["ml-format"] = {
        command = "/home/david/.opam/5.3.0/bin/ocamlformat",
        args = {
          "--enable-outside-detected-project",
          "--name",
          "$FILENAME",
          "-",
        },
      },
    },
    formatters_by_ft = {
      ocaml = { "ml-format" },
    },
  }
end
setup()
return { setup = setup }
