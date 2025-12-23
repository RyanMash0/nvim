-------------------------------------------------------------------------------
-- IDE like setup                                                            --
-------------------------------------------------------------------------------

--- Components
-- Layout
-- Buffer line
-- Status line
-- Netrw styling
-- Commands list

local function generate_tree_action(bufId, ex_table, line, func)
	vim.bo[bufId].modifiable = true
	vim.b[bufId].explorer_indent = func(bufId, ex_table, line)
	vim.bo[bufId].modifiable = false
end

local function get_cached(bufId, ex_table, line)
	local parent = ex_table[line]
	for i = 1, #parent.cached_entries do
		table.insert(ex_table, line + i, parent.cached_entries[i])
	end
	vim.api.nvim_buf_set_lines(bufId, line, line, true, parent.cached_lines)
	parent.cached = false
	parent.cached_lines = {}
	parent.cached_entries = {}
	return ex_table
end

local function print_paths(bufId, ex_table, start_line)
	local parent = ex_table[start_line]
	local depth = parent.depth + 1
	local path = parent.path
	local dir_iterator = vim.fs.dir(path)
	local prefix = ''
	for _ = 1, depth do
		prefix = prefix .. '| '
	end

	local indicator
	if depth < 0 then
		indicator = {directory = '', other = ''}
	else
		indicator = {directory = '> ', other = '+ '}
	end
	-- indicator = {directory = '', other = ''}

	local directories = 0
	local other = 0
	local line
	local entry
	for name, type in dir_iterator do
		entry = {
			depth = depth,
			path = path .. '/' .. name,
			type = type,
			expanded = false,
			cached = false,
			cached_lines = {},
			cached_entries = {},
		}

		if type == 'directory' then
			line = start_line + directories
			directories = directories + 1
			name = indicator.directory .. name .. '/'
		else
			line = start_line + directories + other
			other = other + 1
			name = indicator.other .. name
		end

		table.insert(ex_table, line + 1, entry)
		vim.api.nvim_buf_set_lines(bufId, line, line, true, {prefix..name})
	end

	return ex_table
end

local function expand(bufId, ex_table, line)
	local parent = ex_table[line]
	parent.expanded = true
	local name = vim.api.nvim_buf_get_lines(bufId, line - 1, line, true)[1]
	name = name:gsub('>', 'v')
	vim.api.nvim_buf_set_lines(bufId, line - 1, line, true, {name})
	if parent.cached then
		return get_cached(bufId, ex_table, line)
	else
		return print_paths(bufId, ex_table, line)
	end
end

local function close(bufId, ex_table, line)
	local parent = ex_table[line]
	parent.expanded = false
	parent.cached = true

	local name = vim.api.nvim_buf_get_lines(bufId, line - 1, line, true)[1]
	name = name:gsub('v', '>')
	vim.api.nvim_buf_set_lines(bufId, line - 1, line, true, {name})

	local sub_items = 0
	while ex_table[line + 1].depth > parent.depth do
		sub_items = sub_items + 1
		table.insert(parent.cached_entries, ex_table[line + 1])
		table.remove(ex_table, line + 1)
	end
	parent.cached_lines =
		vim.api.nvim_buf_get_lines(bufId, line, line + sub_items, true)

	vim.api.nvim_buf_set_lines(bufId, line, line + sub_items, true, {})
	return ex_table
end

function UpdateFileTree()
	local bufId = vim.g.file_explorer_buf_id
	local line = vim.fn.line('.')
	local header_height = vim.g.file_explorer_header_height

	if line <= header_height then
		return
	elseif line == header_height + 1 then
		AscendFileTree()
		return
	end

	local line_str = vim.api.nvim_buf_get_lines(bufId, line - 1, line, true)[1]
	line_str = line_str:gsub('| ', ''):gsub('/', ''):gsub('[>v+] ', '')

	local ex_table = vim.b[bufId].explorer_indent
	local parent = ex_table[line]
	if parent.type == 'file' then
		local winId = vim.g.file_explorer_win_id
		local main_win = vim.api.nvim_win_call(winId, function ()
			return vim.fn.win_getid(vim.fn.winnr('l'))
		end)
		-- vim.print(vim.fn.win_getid(vim.fn.winnr('l')))
		-- vim.print(main_win)
		vim.api.nvim_set_current_win(main_win)
		vim.cmd('edit ' .. parent.path)
		return
	end

	if parent.type == 'directory' and parent.expanded then
		generate_tree_action(bufId, ex_table, line, close)
	elseif parent.type == 'directory' and not parent.expanded then
		generate_tree_action(bufId, ex_table, line, expand)
	end

	HighlightFileTree()
	return ''
end

vim.g.file_explorer_header = nil

function MakeFileTree()
	local bufId = vim.g.file_explorer_buf_id
	local winId = vim.g.file_explorer_win_id
	local path = vim.fs.abspath('.')
	local header_entry = {
		depth = -1,
		path = path,
		type = 'Header',
		expanded = false,
		cached = false,
		cached_lines = {},
		cached_entries = {},
	}
	local parent_dir_entry = {
		depth = -1,
		path = path,
		type = 'directory',
		expanded = false,
		cached = false,
		cached_lines = {},
		cached_entries = {},
	}

	local border = '=========================================='
	local title_line = ' File Tree'
	local home_dir = tostring(os.getenv('HOME') or os.getenv('USERPROFILE'))
	local path_line = ' Path: ' .. path:gsub(home_dir, '~')
	if path_line ~= ' /' then path_line = path_line .. '/' end

	local user_header = vim.g.file_explorer_header
	local header_lines = user_header or {border, title_line, path_line, border}
	vim.g.file_explorer_header_height = #header_lines
	local header_height = vim.g.file_explorer_header_height
	table.insert(header_lines, '../')

	local starting_array = {}
	for _ = 1, header_height do
		table.insert(starting_array, header_entry)
	end
	table.insert(starting_array, parent_dir_entry)

	vim.b[bufId].explorer_indent = starting_array

	vim.bo[bufId].modifiable = true
	vim.api.nvim_buf_set_lines(bufId, 0, -1, false, {})
	vim.api.nvim_buf_set_lines(bufId, 0, 1, true, header_lines)
	vim.api.nvim_win_set_cursor(winId, {header_height + 1, 0})
	vim.b[bufId].explorer_indent =
		print_paths(bufId, starting_array, header_height + 1)
	vim.bo[bufId].modifiable = false
	HighlightFileTree()
end

function ChangeFileTreeDir(path)
	vim.schedule(function ()
		vim.cmd('cd ' .. path)
		MakeFileTree()
	end)
end

function AscendFileTree()
	vim.schedule(function ()
		ChangeFileTreeDir(vim.fs.abspath('.'):gsub('/[^/]+$', ''))
	end)
end

function DescendFileTree()
	local line = vim.fn.line('.')
	local bufId = vim.g.file_explorer_buf_id
	local path = vim.b[bufId].explorer_indent[line].path
	ChangeFileTreeDir(path)
end

function HighlightFileTree()
	local bufId = vim.g.file_explorer_buf_id
	local nsId = vim.g.file_explorer_ns
	vim.api.nvim_buf_clear_namespace(bufId, nsId, 0, -1)
	local ex_table = vim.b[bufId].explorer_indent
	local dir_hl = vim.api.nvim_get_hl_id_by_name('netrwDir')
	local bar_hl = vim.api.nvim_get_hl_id_by_name('netrwTreeBar')
	local plain_hl = vim.api.nvim_get_hl_id_by_name('netrwPlain')
	local header_hl = vim.api.nvim_get_hl_id_by_name('netrwComment')
	local name_start
	local line_len
	local hl_group
	for i, entry in ipairs(ex_table) do
		name_start = entry.depth > 0 and entry.depth * 2 or 0
		line_len = #vim.api.nvim_buf_get_lines(bufId, i - 1, i, true)[1]
		vim.api.nvim_buf_set_extmark(bufId, nsId, i - 1, 0, {end_col = name_start, hl_group = bar_hl})

		if entry.type == 'Header' then
			hl_group = header_hl
		elseif entry.type == 'directory' then
			hl_group = dir_hl
		else
			hl_group = plain_hl
		end

		vim.api.nvim_buf_set_extmark(bufId, nsId, i - 1, name_start, {end_col = line_len, hl_group = hl_group})
	end
end

function MakeLayout()
	local exWinOpts = {
		vertical = true,
		split = 'left',
		width = 30,
	}

	local termWinOpts = {
		height = 10,
		split = 'below',
	}
	vim.g.file_explorer_ns = vim.api.nvim_create_namespace('FileTree')
	-- validate existence
	local ex = vim.api.nvim_create_buf(false, true)
	local term = vim.api.nvim_create_buf(true, false)
	vim.g.file_explorer_buf_id = ex
	vim.g.terminal_buf_id = term

	local exWin = vim.api.nvim_open_win(ex, false, exWinOpts)
	local termWin = vim.api.nvim_open_win(term, false, termWinOpts)
	vim.g.file_explorer_win_id = exWin
	vim.g.terminal_win_id = termWin
	-- vim.wo[exWin].winbar = function () return "%f" end

	-- vim.api.nvim_win_call(exWin, function ()
	-- 	vim.cmd.Ex()
	-- 	-- vim.cmd.normal('I')
	-- end)

	-- come back
	-- vim.wo[exWin].win_min_width = 10

	vim.api.nvim_buf_call(term, function () vim.cmd.terminal() end)

	vim.bo[ex].modifiable = false
	vim.wo[exWin].wrap = false
	vim.wo[exWin].number = false
	vim.wo[exWin].winfixbuf = true

	vim.bo[term].buflisted = false
	vim.wo[termWin].winfixbuf = true
	local tree_update = vim.schedule_wrap(UpdateFileTree)
	local tree_make = vim.schedule_wrap(MakeFileTree)
	local tree_descend = vim.schedule_wrap(DescendFileTree)
	local tree_ascend = vim.schedule_wrap(AscendFileTree)
	local tree_opts = { buffer = ex, expr = true, remap = false }
	local term_opts = { buffer = term, remap = false }
	vim.api.nvim_create_augroup('file_explorer', { clear = true })
	vim.keymap.set('n', 'r', tree_make, tree_opts)
	vim.keymap.set('n', '-', tree_ascend, tree_opts)
	vim.keymap.set('n', '<CR>', tree_update, tree_opts)
	vim.keymap.set('n', '<S-CR>', tree_descend, tree_opts)
	vim.keymap.set('n', '<C-M>', tree_update, tree_opts)
	vim.keymap.set('n', '<LeftMouse>', tree_update, tree_opts)
	vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', term_opts)

	MakeFileTree()
end

function DeleteLayout()
	if type(vim.g.file_explorer_buf_id) == 'number'
		or type(vim.g.file_explorer_win_id) == 'number' then
		vim.api.nvim_win_close(vim.g.file_explorer_win_id, true)
		vim.api.nvim_buf_delete(vim.g.file_explorer_buf_id, { force = true, })

		vim.g.file_explorer_buf_id = nil
		vim.g.file_explorer_win_id = nil
	end

	if type(vim.g.terminal_buf_id) == 'number'
		or type(vim.g.terminal_win_id) == 'number' then
		vim.api.nvim_win_close(vim.g.terminal_win_id, true)
		vim.api.nvim_buf_delete(vim.g.terminal_buf_id, { force = true, })

		vim.g.terminal_buf_id = nil
		vim.g.terminal_win_id = nil
	end
end

function RefreshLayout()
	DeleteLayout()
	MakeLayout()
end

-- vim.schedule(RefreshLayout)

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

vim.api.nvim_create_user_command('RefreshLayout',
function ()
	RefreshLayout()
end,
{ nargs = 0 })
