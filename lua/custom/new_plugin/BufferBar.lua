
local function truncate_end(str, num)
	if #str <= num then return str end
	return str:sub(num - 3) .. '...'
end

local function truncate_middle(str, num)
	if #str <= num then return str end
	if str:match('^%.//?[^/]+/$') then return str:gsub('%.//', '/') end
	if str:match('^%.//?[^/]+/[^/]+/$') then return str:gsub('%.//', '/') end
	local prefix = str:match('^%./[^/]+/') or ''
	if str:match('^%.//[^/]') then prefix = '/' end
	local suffix = str:match('/[^/]+/$') or ''
	return prefix .. '...' .. suffix
end

local function extend_length(str, num)
	if #str == num then return str end
	for _ = 1, num - #str do
		str = str .. ' '
	end
	return str
end

function MakeBufferBar()
	local bufId = vim.g.buf_bar_buf_id
	local buffers = vim.api.nvim_list_bufs()
	local normal_buffers = {}
	local term_buffers = {}
	for _, buf in ipairs(buffers) do
		if vim.bo[buf].buflisted then
			table.insert(normal_buffers, buf)
		end

		if vim.bo[buf].buftype == 'terminal' then
			table.insert(term_buffers, buf)
		end
	end

-- U+2501 - bottom of border,
-- U+2518 - corner,
-- U+2502 - vertical bars for right of tab

	-- vim.b[bufId].buffers = 
	local buffer_info = {}
	local test = {
		first = 0,
		last = 0,
	}

	local buf_name
	local file_name
	local dir_name
	local file_str = ''
	local dir_str = ''
	local truncate_len = vim.g.buffer_name_max_length
	local max_len
	for _, buf in ipairs(normal_buffers) do
		buf_name = vim.api.nvim_buf_get_name(buf)

		file_name = buf_name:match('[^/]+$') or ''
		file_name = truncate_end(file_name, truncate_len)

		dir_name = buf_name:gsub(vim.fs.abspath('.') .. '/', '')
		dir_name = './' .. dir_name:gsub('[^/]+$', '')
		dir_name = truncate_middle(dir_name, #file_name)

		max_len = math.max(#dir_name, #file_name)

		file_name = extend_length(file_name, max_len)
		dir_name = extend_length(dir_name, max_len)

		buffer_info[buf] = { first = #file_str, last = #file_str + max_len + 2 }
		file_str = file_str .. ' ' .. file_name .. ' \u{2502}'
		dir_str = dir_str .. ' ' .. dir_name .. ' \u{2502}'
	end

	vim.b[bufId].buffer_info = buffer_info
	vim.bo[bufId].modifiable = true
	vim.api.nvim_buf_set_lines(bufId, 0, -1, true, {dir_str, file_str})
	vim.bo[bufId].modifiable = false
	-- vim.print(buf_str)
	HighlightBufferBar()
end

function HighlightBufferBar()
	local bufId = vim.g.buf_bar_buf_id
	local ns = vim.g.buf_bar_ns
	vim.api.nvim_buf_clear_namespace(bufId, ns, 0, -1)
	CheckOrMakeWin()
	local main_win = vim.g.main_win_id
	local cur_buf = vim.api.nvim_win_get_buf(main_win)
	local hl_region = vim.b[bufId].buffer_info[cur_buf]
	local hl_group = vim.api.nvim_get_hl_id_by_name('TabLineSel')
	vim.api.nvim_buf_set_extmark(bufId, ns, 0, hl_region.first, {
		end_col = hl_region.last,
		hl_group = hl_group
	})
	vim.api.nvim_buf_set_extmark(bufId, ns, 1, hl_region.first, {
		end_col = hl_region.last,
		hl_group = hl_group
	})
end
