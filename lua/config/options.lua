-------------------------------------------------------------------------------
-- Options                                                                   --
-------------------------------------------------------------------------------
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

-- Completion menu
vim.opt.completeopt = {'menuone','noselect','popup'}
vim.opt.ignorecase = true

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
