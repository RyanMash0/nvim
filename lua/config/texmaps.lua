-------------------------------------------------------------------------------
-- LaTeX Config                                                              --
-------------------------------------------------------------------------------
local tex_opts = {
	-- Set TexMaps() to be called whenever a .tex buffer is created
	group = 'tex',
	pattern = 'tex',
	command = 'lua TexMaps()',
}
vim.api.nvim_create_augroup('tex', { clear = true })
vim.api.nvim_create_autocmd('FileType', tex_opts)

local function add_item(s, e)
	local char
	local item_str
	for i = s, e do
		char = string.char(i)
		item_str = '\\item[('..char..')] '
		vim.api.nvim_buf_set_keymap(0, 'i', '--item'..char, item_str, {})
	end
end

function TexMaps()
	-- Add "i$" and "a$" text object motion keymaps in LaTeX files
	vim.api.nvim_buf_set_keymap(0, 'o', 'i$', ':TextObjMotion i$<CR>', {})
	vim.api.nvim_buf_set_keymap(0, 'o', 'a$', ':TextObjMotion a$<CR>', {})

	-- Add "--itemx" keymaps in tex files for x in [0-9, A-Z, a-z]
	-- Outputs \item[(x)] in LaTeX document
	add_item(string.byte('0'), string.byte('9'))
	add_item(string.byte('A'), string.byte('Z'))
	add_item(string.byte('a'), string.byte('z'))

	-- Add "--x" keymaps in tex files for x in the sets variable
	-- Outputs \mathds{y} for y in the set_symbs variable
	local sets = { 'reals', 'nats', 'ints', 'rats', 'irrs' }
	local set_symbs = { 'R', 'N', 'Z', 'Q', 'I' }
	local set_str
	for i = 1, #sets do
		set_str = '\\mathds{'..set_symbs[i]..'}'
		vim.api.nvim_buf_set_keymap(0, '!', '--'..sets[i], set_str, {})
	end

	-- vim.api.nvim_buf_set_keymap(0, 'i', '$<CR>', '<Esc>:PreSurround $<CR>', {})
	-- vim.api.nvim_buf_set_keymap(0, 'i', '|<CR>', '<Esc>:PreSurround |<CR>', {})
	-- vim.api.nvim_buf_set_keymap(0, 'i', '--set', '<Esc>:MakeSet<CR>', {})

end
