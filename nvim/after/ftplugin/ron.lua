-- function FormatRonFile()
--   vim.cmd "echo 'Formatting ron file'"
--   print "Formatting ron file"
--   -- execute print to stdout
-- end
-- local group = vim.api.nvim_create_augroup("fmtGroup", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = "*.ron",
--   group = group,
--   callback = FormatRonFile,
-- })
--
local format_ron_str = function(buf_content)
  local cmd = vim.system(
    { "/home/david/ron-formatter/target/debug/ron-formatter" },
    { stdin = table.concat(buf_content, "\n"), text = true }
  )
  local res = cmd:wait()
  -- print(vim.inspect(res))
  local ron_str = res.stdout
  print(vim.inspect(ron_str))
  return ron_str
end
local format_graphql_str = function(node_text)
  local node_text_clean = string.sub(node_text, 4, string.len(node_text) - 2)
  -- print(vim.inspect(node_text_clean))
  local cmd = vim.system(
    { "prettier", "--parser", "graphql", "--print-width", "150", "--tab-width", "4" },
    { stdin = node_text_clean, text = true }
  )
  -- print(vim.inspect(node_text_clean))
  local res = cmd:wait()
  local formatted_raw = res.stdout
  -- print(vim.inspect(formatted_raw))
  --
  -- convert the formatted string to array of lines
  if formatted_raw ~= nil then
    formatted_raw = formatted_raw:gsub("\n$", "")
  end
  -- print(vim.inspect(formatted_raw))
  -- print "___________________________"
  local formatted = vim.split(formatted_raw, "\n")
  -- Add indentation to match the rest
  -- Since this is *only* for `query`, we can hardcode the indentation
  -- to match what my `formatter` should output which is 4 spaces
  local indent = string.rep(" ", 4)
  for idx, line in ipairs(formatted) do
    formatted[idx] = indent .. line
  end
  return formatted
end

local embedded_graphql = vim.treesitter.query.parse(
  "ron",
  [[
((struct_entry
  (identifier) @query (#eq? @query "query")
  (string
    (raw_string) @graphql)))
    ;; apparently offset isnt useful in using the captures
    ;; and it will alwayas return the same `node:range()`
    ;; so we can remove it?
]]
)

local get_root = function(bufnr)
  local root = vim.treesitter.get_parser(bufnr, "ron", {})
  -- local root = vim.treesiter.query.parse("rust", embedded_graphql)
  local tree = root:parse()[1]
  return tree:root()
end

local fmt_graphql = function(bufnr)
  local buf_content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local formatted_ron = format_ron_str(buf_content)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(formatted_ron, "\n"))
  -- print(vim.inspect(formatted_ron))
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local root = get_root(bufnr)
  local change = {}
  for id, node in embedded_graphql:iter_captures(root, bufnr, 0, -1) do
    local name = embedded_graphql.captures[id]
    -- we only care about the capture named "ruststring"
    if name == "graphql" then
      -- {start_row, start_col, end_row, end_col}
      local range = { node:range() } -- span of the capture
      -- {8,11,73,7}
      local node_text = vim.treesitter.get_node_text(node, bufnr)
      -- local preformatted = format_ron_str(j
      local formatted = format_graphql_str(node_text)
      -- Given that I replace the last line entirely, I need to add back the raw
      -- string end at the end of the last line,
      formatted[#formatted] = formatted[#formatted] .. [["#,]]
      -- range is now {8,11,16,7} in editor lines {9,12,17,8}
      change.start_row = range[1] + 1
      -- change.start_row = 1
      -- end row is inclusive so where you end it, it will remove
      --the contents of that line with whatever you put in there
      change.end_row = range[3] + 1
      change.formatted = formatted

      -- local tempbufnr = 61
      local tempbufnr = bufnr
      -- repalce the whole buffer with hello world
      -- vim.api.nvim_buf_set_lines(tempbufnr, 0, -1, false, { "kahlua" })
      vim.api.nvim_buf_set_lines(tempbufnr, change.start_row, change.end_row, false, change.formatted)
    end
  end
end

fmt_graphql(4)
