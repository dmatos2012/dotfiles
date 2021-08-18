local present, orgmode = pcall(require, "orgmode")
if not present then
    return
end

orgmode.setup({
  org_agenda_files = {'~/orgmode/*', '~/orgmode/org/**/*'},
  org_default_notes_file = '~/orgmode/org/refile.org',
})

