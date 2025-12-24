-------------------------------------------------------------------------------
-- Keymaps                                                                   --
-------------------------------------------------------------------------------
require('config.texmaps')

-- Leader
local L = '<Leader>'
vim.keymap.set('n', '-', ',')
vim.keymap.set('n', ',', '<Nop>')
vim.g.mapleader = ","

-- Mouse
vim.keymap.set('n', '<LeftDrag>', '<Nop>', { remap = false })
vim.keymap.set('n', '<LeftRelease>', '<Nop>', { remap = false })
vim.keymap.set('n', L..'<LeftDrag>', '<LeftDrag>', { remap = false })
vim.keymap.set('n', L..'<LeftRelease>', '<LeftRelease>', { remap = false })

-- Definition
vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')

-- Completion
vim.cmd("inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'")
vim.cmd("inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'")
vim.cmd("inoremap <expr> <cr> pumvisible() ? '<C-y>' : '<CR>'")
-- vim.keymap.set('i', '<Tab>', function()
-- 	if vim.fn.pumvisible() then
-- 		return '<C-n>'
-- 	end
-- 	return '<Tab>'
-- end, { expr = true })
-- vim.keymap.set('i', '<S-Tab>', function()
-- 	if vim.fn.pumvisible() then
-- 		return '<C-p>'
-- 	end
-- 	return '<S-Tab>'
-- end, { expr = true })
-- vim.keymap.set('i', '<CR>', function()
-- 	if vim.fn.pumvisible() then
-- 		return '<C-y>'
-- 	end
-- 	return '<CR>'
-- end, { expr = true })
vim.keymap.set('i', '<BS>', function()
	local pos = vim.api.nvim_win_get_cursor(0)[2] - 1
	local line = vim.api.nvim_get_current_line()
	if line:sub(pos, pos):match('%s') == nil and pos > 0 then
		vim.defer_fn(function() vim.lsp.completion.get() end, 100)
	end
	return '<BS>'
end, { expr = true })

-- Explore
vim.keymap.set('n', L..'e', '<Cmd>Ex<CR>')

-- Windows
vim.keymap.set('n', L..'w', '<C-w>')

-- Buffers
vim.keymap.set('n', L..'n', '<Cmd>bn<CR>')
vim.keymap.set('n', L..'b', '<Cmd>bp<CR>')
vim.keymap.set('n', L..'d<CR>', '<Cmd>bp | bd #<CR>')

-- Surround
vim.keymap.set('n', L..'s', ':PostSurround<CR>')
vim.keymap.set('v', L..'s', ':VPostSurround<CR>')

-- DeleteSurround
vim.keymap.set('n', L..'ds', ':DeleteSurround<CR>')

-- ChangeSurround
vim.keymap.set('n', L..'cs', ':ChangeSurround<CR>')

-- -- PreSurround
-- vim.keymap.set('i', '(<CR>', '<Esc>:PreSurround (<CR>')
-- vim.keymap.set('i', '[<CR>', '<Esc>:PreSurround [<CR>')
-- vim.keymap.set('i', '{<CR>', '<Esc>:PreSurround {<CR>')
-- vim.keymap.set('i', '{ <CR>', '<Esc>:PreSurround { <CR>')
-- vim.keymap.set('i', '<<CR>', '<Esc>:PreSurround <<CR>')
-- vim.keymap.set('i', '\"<CR>', '<Esc>:PreSurround \"<CR>')
-- vim.keymap.set('i', '\'<CR>', '<Esc>:PreSurround \'<CR>')

-- Color Column
vim.keymap.set('n', L..'c+', ':set colorcolumn=80<CR>')
vim.keymap.set('n', L..'c-', ':set colorcolumn=0<CR>')

-- Telescope
local r = 'cwd=/'
local u = 'cwd=~'
vim.keymap.set('n', L..'g', '<Cmd>Telescope git_files<CR>')
vim.keymap.set('n', L..'h', '<Cmd>Telescope help_tags<CR>')
vim.keymap.set('n', L..'f', '<Cmd>Telescope find_files<CR>')
vim.keymap.set('n', L..'lg', '<Cmd>Telescope live_grep <CR>')
vim.keymap.set('n', L..'uf', '<Cmd>Telescope find_files '..u..'<CR>')
vim.keymap.set('n', L..'ulg', '<Cmd>Telescope live_grep '..u..'<CR>')
vim.keymap.set('n', L..'rf', '<Cmd>Telescope find_files '..r..'<CR>')
vim.keymap.set('n', L..'rlg', '<Cmd>Telescope live_grep '..r..'<CR>')
