-- Locally installed parsers
-- TODO: Reenable ron and graphql
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
-- parser_config.graphql = {
--   install_info = {
--     url = "~/build/tree-sitter-graphql", -- local path or git repo
--     files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
--     -- optional entries:
--     branch = "main", -- default branch in case of git repo if different from master
--     generate_requires_npm = false, -- if stand-alone parser without npm dependencies
--     requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--   },
--   filetype = "graphql", -- if filetype does not match the parser name
--   injection = {
--     enable = true, -- enable injections
--   },
-- }
parser_config.rescript = {
  install_info = {
    url = "https://github.com/rescript-lang/tree-sitter-rescript.git",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "main",
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
    filetype = "rescript",
    injection = {
      enable = true, -- enable injections
    },
    highlight = {
      enable = true, -- enable highlight
    },
  },
}
-- # For Nix i am removing .ron and graphql as
-- i really dont use them that much, and relies on
-- local script. I will solve those later.
-- parser_config.ron = {
--   install_info = {
--     url = "~/build/tree-sitter-ron", -- local path or git repo
--     files = { "src/parser.c", "src/scanner.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
--     -- optional entries:
--     generate_requires_npm = false, -- if stand-alone parser without npm dependencies
--     requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--   },
--   filetype = "ron", -- if filetype does not match the parser name
--   injection = {
--     enable = true, -- enable injections
--   },
-- }
-- Default ron parser does not support `raw_strings` and I need it,
-- thus I build locally from the PR in the upstream repo
-- https://github.com/tree-sitter-grammars/tree-sitter-ron/pull/1
-- Tree-sitter default supported languages
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "rust",
    "nu",
    "python",
    "json",
    "graphql",
    "rescript",
    "ocaml",
    "elixir",
    "eex",
    "erlang",
    "heex",
    "html",
  },
  -- I had to enable this only for Elixir
  -- Without it, it was working fine for all other languages
  -- Watch if it messes up indentaiton on new files
  indent = {
    enable = true,
  },
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  -- enable injections
  injections = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  refactor = {
    highlight_definitions = { enable = true },
    hightlight_current_scope = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        -- these dont work somehow?
        goto_next_usage = "<A-*>",
        goto_previous_usage = "<A-#>",
      },
    },
  },
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = true,
    },
  },
}
