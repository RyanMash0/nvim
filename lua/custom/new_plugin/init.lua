require('custom.new_plugin.IDE')
vim.g.file_explorer_header = nil
vim.g.file_explorer_cache = true
vim.g.buffer_name_max_length = 20
vim.g.main_win_id = vim.api.nvim_get_current_win()
vim.opt.laststatus = 3

vim.schedule(MakeLayout)

vim.api.nvim_create_user_command('MakeBufferBar',
function ()
	MakeBufferBar()
end,
{ nargs = 0 })

vim.api.nvim_create_user_command('ChangeFileTreeDir',
function (opts)
	ChangeFileTreeDir(opts.args)
end,
{ nargs = 1 })

vim.api.nvim_create_user_command('MakeFileTree',
function ()
	MakeFileTree()
end,
{ nargs = 0 })

vim.api.nvim_create_user_command('MakeLayout',
function ()
	MakeLayout()
end,
{ nargs = 0 })

vim.api.nvim_create_user_command('DeleteLayout',
function ()
	DeleteLayout()
end,
{ nargs = 0 })
