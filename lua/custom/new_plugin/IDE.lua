-------------------------------------------------------------------------------
-- IDE like setup                                                            --
-------------------------------------------------------------------------------
require('custom.new_plugin.FileTree')
require('custom.new_plugin.BufferBar')
--- Components
-- Layout
-- Buffer line
-- Status line
-- Netrw styling
-- Commands list


function MakeLayout()
	vim.g.main_win_id = vim.api.nvim_get_current_win()
	DeleteLayout()
	local exWinOpts = {
		vertical = true,
		split = 'left',
		width = 30,
	}

	local termWinOpts = {
		height = 10,
		split = 'below',
	}

	local bufBarWinOpts = {
		height = 2,
		-- relative = 'tabline',
		split = 'above',
		style = 'minimal',
		-- width = 50,
		-- row = 0,
		-- col = 0,
	}

	local ex = vim.api.nvim_create_buf(false, true)
	local term = vim.api.nvim_create_buf(true, false)
	local bufBar = vim.api.nvim_create_buf(false, true)

	local exWin = vim.api.nvim_open_win(ex, false, exWinOpts)
	local termWin = vim.api.nvim_open_win(term, false, termWinOpts)
	local bufBarWin = vim.api.nvim_open_win(bufBar, false, bufBarWinOpts)

	vim.g.file_explorer_ns = vim.api.nvim_create_namespace('FileTree')
	vim.g.file_explorer_buf_id = ex
	vim.g.terminal_buf_id = term
	vim.g.buf_bar_buf_id = bufBar
	vim.g.file_explorer_win_id = exWin
	vim.g.terminal_win_id = termWin
	vim.g.buf_bar_win_id = bufBarWin

	vim.api.nvim_buf_call(term, function () vim.cmd.terminal() end)

	vim.bo[ex].modifiable = false
	vim.wo[exWin].wrap = false
	vim.wo[exWin].number = false
	vim.wo[exWin].winfixbuf = true

	vim.bo[term].buflisted = false
	vim.wo[termWin].winfixbuf = true

	vim.bo[bufBar].modifiable = false
	vim.bo[bufBar].buflisted = false
	vim.wo[bufBarWin].wrap = false
	vim.wo[bufBarWin].winfixbuf = true
	local tree_update = vim.schedule_wrap(UpdateFileTree)
	local tree_make = vim.schedule_wrap(MakeFileTree)
	local tree_descend = vim.schedule_wrap(DescendFileTree)
	local tree_ascend = vim.schedule_wrap(AscendFileTree)
	local tree_opts = { buffer = ex, expr = true, remap = false }
	local term_opts = { buffer = term, remap = false }
	-- vim.api.nvim_create_augroup('file_explorer', { clear = true })
	vim.keymap.set('n', 'r', tree_make, tree_opts)
	vim.keymap.set('n', '-', tree_ascend, tree_opts)
	vim.keymap.set('n', '<CR>', tree_update, tree_opts)
	vim.keymap.set('n', '<S-CR>', tree_descend, tree_opts)
	vim.keymap.set('n', '<C-M>', tree_update, tree_opts)
	vim.keymap.set('n', '<LeftMouse>', function ()
		tree_update()
		return '<LeftMouse>'
	end, tree_opts)
	vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', term_opts)

	MakeFileTree()
	MakeBufferBar()
end

local function check_is_number(variable)
	return type(variable) == 'number'
end

local function close_buf(id)
	if vim.api.nvim_buf_is_valid(id) then
		vim.api.nvim_buf_delete(id, { force = true, })
	end
end

local function close_win(id)
	if vim.api.nvim_win_is_valid(id) then
		vim.api.nvim_win_close(id, true)
	end
end

function DeleteLayout()
	local ex_win_id = vim.g.file_explorer_win_id
	local ex_buf_id = vim.g.file_explorer_buf_id
	local term_win_id = vim.g.terminal_win_id
	local term_buf_id = vim.g.terminal_buf_id
	local buf_bar_win_id = vim.g.buf_bar_win_id
	local buf_bar_buf_id = vim.g.buf_bar_buf_id
	local ex_win_exists = check_is_number(ex_win_id)
	local ex_buf_exists = check_is_number(ex_buf_id)
	local term_win_exists = check_is_number(term_win_id)
	local term_buf_exists = check_is_number(term_buf_id)
	local buf_bar_win_exists = check_is_number(buf_bar_win_id)
	local buf_bar_buf_exists = check_is_number(buf_bar_buf_id)

	local windows = vim.api.nvim_tabpage_list_wins(0)
	local main_win = vim.g.main_win_id

	if ex_win_exists then
		close_win(ex_win_id)
		vim.g.file_explorer_win_id = nil
	end

	if ex_buf_exists then
		close_buf(ex_buf_id)
		vim.g.file_explorer_buf_id = nil
	end

	if term_win_exists then
		close_win(term_win_id)
		vim.g.terminal_win_id = nil
	end

	if term_buf_exists then
		close_buf(term_buf_id)
		vim.g.terminal_buf_id = nil
	end

	if buf_bar_win_exists then
		close_win(buf_bar_win_id)
		vim.g.buf_bar_win_id = nil
	end

	if buf_bar_buf_exists then
		close_buf(buf_bar_buf_id)
		vim.g.buf_bar_buf_id = nil
	end
end

-- function RefreshLayout()
-- 	DeleteLayout()
-- 	MakeLayout()
-- end
