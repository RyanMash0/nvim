-------------------------------------------------------------------------------
-- Keymaps                                                                   --
-------------------------------------------------------------------------------

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

-- LSP
local function toggle_hints()
	local enabled = vim.lsp.inlay_hint.is_enabled()
	vim.lsp.inlay_hint.enable(not enabled)
end

vim.keymap.set('n', 'gd', function () vim.lsp.buf.definition() end)
vim.keymap.set('n', 'gi', toggle_hints)

-- Completion
local function comp_act(input, default)
	return function ()
		local info = vim.fn.complete_info()
		if info.pum_visible == 1 then
			return input
		end
		return default
	end
end

vim.keymap.set('i', '<Tab>', comp_act('<C-n>', '<Tab>'), { expr = true })
vim.keymap.set('i', '<S-Tab>', comp_act('<C-p>', '<S-Tab>'), { expr = true })
vim.keymap.set('i', '<CR>', comp_act('<C-y>', '<CR>'), { expr = true })

vim.keymap.set('i', '<BS>', function()
	local pos = vim.api.nvim_win_get_cursor(0)[2] - 1
	local line = vim.api.nvim_get_current_line()
	if line:sub(pos, pos):match('%s') == nil and pos > 0 then
		vim.defer_fn(function() vim.lsp.completion.get() end, 100)
	end
	return '<BS>'
end, { expr = true })

-- IDEify
vim.keymap.set('n', L..'lo', '<Cmd>IDEifyOpen<CR>')
vim.keymap.set('n', L..'lc', '<Cmd>IDEifyClose<CR>')
vim.keymap.set('n', L..'ls', '<Cmd>IDEifyShow<CR>')
vim.keymap.set('n', L..'lh', '<Cmd>IDEifyHide<CR>')
vim.keymap.set('n', L..'lt', '<Cmd>IDEifyToggle<CR>')
vim.keymap.set('n', L..'lr', '<Cmd>IDEifyResetSize<CR>')

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
