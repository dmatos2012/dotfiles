if not pcall(require, "colorbuddy") then
  return
end


if vim.env.USER == "tj-wsl" then
  rawset(require("colorbuddy").styles, "italic", require("colorbuddy").styles.none)
end

function useDarkTheme()
  vim.opt.termguicolors = true
  require("colorbuddy").colorscheme "gruvbuddy"
  require("colorizer").setup()

  local c = require("colorbuddy.color").colors
  local Group = require("colorbuddy.group").Group
  local g = require("colorbuddy.group").groups
  local s = require("colorbuddy.style").styles

  Group.new("GoTestSuccess", c.green, nil, s.bold)
  Group.new("GoTestFail", c.red, nil, s.bold)

  -- Group.new('Keyword', c.purple, nil, nil)

  Group.new("TSPunctBracket", c.orange:light():light())

  Group.new("StatuslineError1", c.red:light():light(), g.Statusline)
  Group.new("StatuslineError2", c.red:light(), g.Statusline)
  Group.new("StatuslineError3", c.red, g.Statusline)
  Group.new("StatuslineError3", c.red:dark(), g.Statusline)
  Group.new("StatuslineError3", c.red:dark():dark(), g.Statusline)

  Group.new("pythonTSType", c.red)
  Group.new("goTSType", g.Type.fg:dark(), nil, g.Type)

  Group.new("typescriptTSConstructor", g.pythonTSType)
  Group.new("typescriptTSProperty", c.blue)

  -- vim.cmd [[highlight WinSeparator guifg=#4e545c guibg=None]]
  Group.new("WinSeparator", nil, nil)

  -- I don't think I like highlights for text
  -- Group.new("LspReferenceText", nil, c.gray0:light(), s.bold)
  -- Group.new("LspReferenceWrite", nil, c.gray0:light())

  -- Group.new("TSKeyword", c.purple, nil, s.underline, c.blue)
  -- Group.new("LuaFunctionCall", c.green, nil, s.underline + s.nocombine, g.TSKeyword.guisp)

  Group.new("TSTitle", c.blue)

  -- TODO: It would be nice if we could only highlight
  -- the text with characters or something like that...
  -- but we'll have to stick to that for later.
  Group.new("InjectedLanguage", nil, g.Normal.bg:dark())

  Group.new("LspParameter", nil, nil, s.italic)
  Group.new("LspDeprecated", nil, nil, s.strikethrough)
end

function TestHighlightCommandsTheme()
  require('colorbuddy').colorscheme('snazzybuddy')
  vim.cmd[[highlight Normal cterm=NONE ctermbg=17 gui=NONE guibg=#eff0eb]]
  vim.cmd[[highlight NonText cterm=NONE ctermbg=17 gui=NONE guibg=#eff0eb]]
  vim.cmd[[highlight CursorLine cterm=NONE ctermbg=17 gui=NONE guibg=#eff0eb]]
  vim.cmd[[highlight StatusLine cterm=NONE ctermbg=231 ctermfg=160 gui=NONE guibg=#ffffff guifg=#d70000]]
  vim.cmd[[highlight MsgArea guibg=#eff0eb guifg=#ff5c57]]
  -- require('snazzybuddy').reload()
end

function useLightTheme()
  require('colorbuddy').colorscheme('snazzybuddy')
  vim.g.background='light'
  require('snazzybuddy').reload()
  vim.cmd[[highlight Normal cterm=NONE ctermbg=17 gui=NONE guibg=#eff0eb]]
end

useDarkTheme()
-- useLightTheme()
