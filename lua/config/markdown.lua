-------------------------------------------------------------------------------
-- Markdown File Config                                                      --
-------------------------------------------------------------------------------
vim.api.nvim_create_augroup('markdown', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
	group = 'markdown',
	pattern = 'markdown',
	callback = function ()
		vim.treesitter.start(0, 'markdown')
	end
})
