-- We only install basedpyright for completions,
-- because Ruff doesnt provide it. For the rest,
-- we use the `Ruff` lsp in /after/lsp/ruff.lua
return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyrightconfig.json",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	settings = {
		basedpyright = {
			-- Using Ruff's import organizer
			disableOrganizeImports = true,
			analysis = {
				-- Ignore all files for analysis to exclusively use Ruff for Linting
				ignore = { "*" },
			},
		},
	},
}
