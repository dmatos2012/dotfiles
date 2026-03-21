require("luasnip.session.snippet_collection").clear_snippets "zig"
local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("zig", {
  s(
    "print",
    -- fmt('std.debug.print("<>", .{<>});', {
    fmt('print("<>", .{<>});', {
      i(1),
      i(2),
    }, {
      delimiters = "<>",
    })
  ),
})
