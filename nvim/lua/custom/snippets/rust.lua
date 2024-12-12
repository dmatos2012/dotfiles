require("luasnip.session.snippet_collection").clear_snippets "rust"
local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
ls.add_snippets("rust", {
  s(
    "fn",
    fmt(
      [[
fn {name}({params}) -> {return_type} {{
    {body}
}}
]],
      {
        name = i(1, "name"),
        params = i(2),
        return_type = i(3, "i32"),
        body = i(4),
      }
    )
  ),

  s(
    "match",
    fmt(
      [[
match {} {{
    {} => {},{}
    _ => {},
}}
      ]],
      {
        i(1, "expression"),
        i(2, "pattern"),
        i(3, "result"),
        i(4),
        i(5, "default_result"),
      }
    )
  ),

  -- dbg!() snippet
  s(
    "dbg",
    fmt("dbg!(&{});", {
      i(1, "expression"),
    })
  ),
  -- panic!() snippet
  s(
    "panic",
    fmt('panic!("{{:?}}", {});', {
      i(1, "expression"),
    })
  ),

  -- println!("{:?}") snippet
  s(
    "pdbg",
    fmt('println!("{{:?}}", {});', {
      i(1, "expression"),
    })
  ),
})
