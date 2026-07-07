-------------------------------------------------------------------------------
-- Options                                                                   --
-------------------------------------------------------------------------------
vim.api.nvim_create_augroup('options', { clear = true })

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.timeout = false
vim.opt.mouse = 'n'
vim.opt.gdefault = true
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.conceallevel = 2
vim.cmd('colorscheme gruvbox-material')
vim.g.netrw_list_hide = '.DS_Store'
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.undofile = true

vim.opt.winborder = 'rounded'

-- Completion menu
vim.opt.complete = ''
vim.opt.completeopt = {'menuone','noselect', 'fuzzy'}

-- Popup menu
vim.opt.pumborder = "rounded"
vim.opt.pumheight = 10
vim.api.nvim_set_hl(0, 'PmenuBorder', { ctermbg = 'none', })
vim.api.nvim_set_hl(0, 'Pmenu', { ctermbg = 'none', })
vim.api.nvim_set_hl(0, 'PmenuExtra', { link = 'Pmenu' })
vim.api.nvim_set_hl(0, 'PmenuKind', { link = 'Pmenu' })
vim.api.nvim_set_hl(0, 'PmenuMatch', { link = 'CmpItemAbbrMatch' })

-- Mouse
vim.opt.mousetime = 0

-- Save View
vim.opt.viewoptions = { 'folds', 'cursor' }
vim.api.nvim_create_autocmd('BufWinLeave', {
	group = 'options',
	pattern = '?*',
	command = 'silent! mkview'
})
vim.api.nvim_create_autocmd('BufWinEnter', {
	group = 'options',
	pattern = '?*',
	command = 'silent! loadview'
})

-- Text Files
vim.api.nvim_create_autocmd('FileType', {
	group = 'options',
	pattern = { 'tex', 'text', 'gitcommit' },
	callback = function ()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = 'en_us'

		vim.keymap.set('n', 'j', 'gj', { buffer = true })
		vim.keymap.set('n', 'k', 'gk', { buffer = true })
	end,
})
