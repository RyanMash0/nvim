-------------------------------------------------------------------------------
-- Reload Plugin                                                             --
-------------------------------------------------------------------------------
local dir = vim.fn.stdpath('data')
dir = vim.fs.joinpath(dir, 'sessions')

vim.uv.fs_mkdir(dir, tonumber('755', 8))

local def_path = vim.fs.joinpath(dir, 'reload_session.vim')

vim.api.nvim_create_user_command('Reload',
function (args)
	local path
	if args.args == '' then
		path = def_path
	else
		path = vim.fs.joinpath(dir, args.args .. '.vim')
	end

	vim.cmd('mksession! ' .. path)
	vim.cmd('restart source ' .. path)
end,
{ nargs = '?' })

vim.api.nvim_create_user_command('Load',
function (args)
	local path
	if args.args == '' then
		path = def_path
	else
		path = vim.fs.joinpath(dir, args.args .. '.vim')
	end

	vim.cmd('source ' .. path)
end,
{ nargs = '?' })
