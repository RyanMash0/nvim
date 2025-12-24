
local function get_split_opts(plugin_wins)
	if plugin_wins[vim.g.terminal_win_id] then
		vim.api.nvim_set_current_win(vim.g.terminal_win_id)
		return { split = 'above' }
	elseif plugin_wins[vim.g.file_explorer_win_id] then
		vim.api.nvim_set_current_win(vim.g.file_explorer_win_id)
		return { split = 'right' }
	elseif plugin_wins[vim.g.buf_bar_win_id] then
		vim.api.nvim_set_current_win(vim.g.buf_bar_win_id)
		return { split = 'below' }
	end
end

function CheckValid(variable, check_type)
	if type(variable) ~= 'number' then return false end
	if check_type == 'window' and not vim.api.nvim_win_is_valid(variable) then
		return false
	end
	if check_type == 'buffer' and not vim.api.nvim_buf_is_valid(variable) then
		return false
	end
	return true
end

function CheckOrMakeWin()
	if vim.api.nvim_win_is_valid(vim.g.main_win_id) then return end

	local wins = vim.api.nvim_tabpage_list_wins(0)
	local ex_win_id = vim.g.file_explorer_win_id
	local term_win_id = vim.g.terminal_win_id
	local buf_bar_win_id = vim.g.buf_bar_win_id
	local ex_win_exists = CheckValid(ex_win_id, 'window')
	local term_win_exists = CheckValid(term_win_id, 'window')
	local buf_bar_win_exists = CheckValid(buf_bar_win_id, 'window')

	local exclude_wins = {
		[ex_win_id] = ex_win_exists,
		[term_win_id] = term_win_exists,
		[buf_bar_win_id] = buf_bar_win_exists,
	}

	local check
	for _, win in ipairs(wins) do
		check = true
		for key, val in pairs(exclude_wins) do
			if win == key and val then
				check = false
				break
			end
		end
		if check then
			vim.g.main_win_id = win
			break
		end
	end
	if not check then
		local bufId = vim.api.nvim_create_buf(true, false)
		local win_opts = get_split_opts(exclude_wins)
		vim.g.main_win_id = vim.api.nvim_open_win(bufId, true, win_opts)
	end
end

