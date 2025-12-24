
local function truncate_end(str, num)
	if #str <= num then return str end
	return str:sub(num - 3) .. '...'
end

local function truncate_middle(str, num)
	if #str <= num then return str end
	local prefix = str:match('^%./[^/]+/') or ''
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
		num = 0,
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
	local entry
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

		entry = { num = buf, first = #file_str, last = max_len + 1 }
		table.insert(buffer_info, entry)
		file_str = file_str .. ' ' .. file_name .. ' \u{2502}'
		dir_str = dir_str .. ' ' .. dir_name .. ' \u{2502}'
	end

	vim.bo[bufId].modifiable = true
	vim.api.nvim_buf_set_lines(bufId, 0, -1, true, {dir_str, file_str})
	vim.bo[bufId].modifiable = false
	-- vim.print(buf_str)

end
