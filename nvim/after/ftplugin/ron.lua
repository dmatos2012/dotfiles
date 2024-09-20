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

local embedded_graphql = vim.treesitter.query.parse(
  "ron",
  [[
((struct_entry
  (identifier) @query (#eq? @query "query")
  (string
    (raw_string) @graphql
    (#offset! @graphql 1 0 0 -3))))
    ;;(#offset! @graphql 1 0 0 0))))
]]
)

local get_root = function(bufnr)
  local root = vim.treesitter.get_parser(bufnr, "ron", {})
  -- local root = vim.treesiter.query.parse("rust", embedded_graphql)
  local tree = root:parse()[1]
  return tree:root()
end

local fmt_graphql = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local root = get_root(bufnr)
  local changes = {}
  for id, node in embedded_graphql:iter_captures(root, bufnr, 0, -1) do
    local name = embedded_graphql.captures[id]
    -- we only care about the capture named "ruststring"
    if name == "graphql" then
      -- {start_row, start_col, end_row, end_col}
      local range = { node:range() } -- span of the capture
      -- {8,11,73,7}
      print(vim.inspect(range))
      local node_text = vim.treesitter.get_node_text(node, bufnr)
      -- print(vim.inspect(node_text))

      -- local formatted, err = vim.system({ "rustfmt" }, { stdin = node_text })
      -- print(vim.inspect(node_text))
      -- Trim the raw_string, meaning r#""# in the node_text
      local node_text_clean = string.sub(node_text, 4, string.len(node_text) - 2)
      local cmd = vim.system(
        { "prettier", "--parser", "graphql", "--print-width", "150", "--tab-width", "4" },
        { stdin = node_text_clean, text = true }
      )
      -- print(vim.inspect(node_text_clean))
      local res = cmd:wait()
      local formatted_raw = res.stdout
      -- print(vim.inspect(formatted_raw))
      -- convert the formatted string to array of lines
      local formatted_raw = formatted_raw:gsub("\n$", "")
      -- print(vim.inspect(formatted_raw))
      -- TODO: CHECK NILLL FOR \n
      -- print(vim.inspect(rw))
      print "___________________________"
      local formatted = vim.split(formatted_raw, "\n")
      -- local formatted = { "kahlua", "mayor" }
      -- print(vim.inspect(formatted))
      -- print(vim.inspect { "hello", "hello2", "}" })
      -- Add indentation to match the rest
      print(vim.inspect(range[2]))
      -- Since this is *only* for `query`, we can hardcode the indentation
      -- to match what my `formatter` should output which is 4 spaces
      -- local indent = string.rep(" ", range[2])
      local indent = string.rep(" ", 4)
      for idx, line in ipairs(formatted) do
        formatted[idx] = indent .. line
      end

      -- print(vim.inspect(node_text))
      -- print(vim.inspect(formatted))
      -- Keep track of the changes
      -- But insert in reverse order of file,
      -- so that when we make modifications, we dont have
      -- any out of date line numbers
      table.insert(changes, 1, {
        -- {10,11,57,7} ..add 1 to match your editor
        -- you can also specify start_row, start_col if you need to be more precise
        start_row = range[1] + 1, -- start line
        start_col = range[2] + 1, -- start col
        final_row = range[3] + 1, -- final line
        final_col = range[4] + 1, -- final col
        formatted = formatted,
        -- formatted = {"kahllua", "mayor"},
      })
      for _, change in ipairs(changes) do
        vim.api.nvim_buf_set_lines(bufnr, change.start_row, change.final_row, false, change.formatted)
        print(vim.inspect(change.end_row))

        print(vim.inspect(#formatted))
        -- The "# needs to account for the difference in fmt vs original text
        local actual_final_row = range[1] + #formatted
        local last_col = vim.api.nvim_buf_get_lines(bufnr, actual_final_row - 1, actual_final_row, false)[1]
        -- local new_last_line = last_col .. [["#,]]
        -- vim.api.nvim_buf_set_lines(bufnr, actual_final_row - 1, actual_final_row, false, { new_last_line })
        -- -- vim.api.nvim_buf_set_text(
        --
        --   bufnr,
        --   -- change.final_row - 1,
        --   actual_final_row - 1,
        --   #last_col, --1 WORKS
        --   actual_final_row - 1,
        --   -- change.final_row - 1,
        --   #last_col, -- 1 WORKS
        --   { [["#]] }
        -- )
      end
    end
  end
end

fmt_graphql(4)
