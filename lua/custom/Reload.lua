-------------------------------------------------------------------------------
-- Reload Plugin                                                             --
-------------------------------------------------------------------------------
local path = vim.fn.stdpath('data')
path = vim.fs.joinpath(path, 'sessions')

vim.uv.fs_mkdir(path, tonumber('755', 8))

path = vim.fs.joinpath(path, 'reload_session.vim')

vim.api.nvim_create_user_command('Reload',
function ()
	vim.cmd('mksession! ' .. path)
	vim.cmd('restart source ' .. path)
end,
{ nargs = 0 })

vim.api.nvim_create_user_command('LoadLastReload',
function ()
	vim.cmd('source ' .. path)
end,
{ nargs = 0 })
