-------------------------------------------------------------------------------
-- Reload Neovim Plugin                                                      --
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command('Reload',
function ()
	local path = '~/.config/nvim/nvim_reload_session.vim'
	vim.cmd('mksession! ' .. path)
	vim.cmd('restart source ' .. path)
end,
{ nargs = 0 })
