local function get_ci(entry)
  return entry
    and entry.user_data
    and entry.user_data.nvim
    and entry.user_data.nvim.lsp
    and entry.user_data.nvim.lsp.completion_item
end

local function str(s)
	if type(s) ~= "string" then return "" end
	return s
end

local function case_prefix_score(label, prefix)
  if prefix == "" then return 0 end

	-- full match
  if label == prefix then return 2 end

	-- partial match
  if label:sub(1, #prefix) == prefix then return 1 end

	-- case-insensitive match
  if label:find(prefix, 1, true) then return -1 end

	-- no match
  return -2
end

local function compare(x, y, weight)
	-- Negative weight will prioritize the smaller value
	if x == y then
		return 0
	elseif x < y then
		return -weight
	end
	return weight
end

function LspCmp(a, b)
  local a_ci = get_ci(a)
  local b_ci = get_ci(b)
  if not a_ci or not b_ci then return 0 end

	local cur = vim.api.nvim_win_get_cursor(0)[2]
  local prefix = vim.fn.matchstr(vim.fn.getline("."):sub(1, cur), [[\k*$]])

  local a_label = str(a_ci.label):gsub('%b()', ''):match('[!-~]+')
  local b_label = str(b_ci.label):gsub('%b()', ''):match('[!-~]+')
	local min_label_len = math.min(#a_label, #b_label)
	local a_format_label = a_label:sub(1, min_label_len):lower()
	local b_format_label = b_label:sub(1, min_label_len):lower()
	local a_case = case_prefix_score(a_label, prefix)
	local b_case = case_prefix_score(b_label, prefix)

	local cmp = {
		label = compare(a_format_label, b_format_label, -10),
		label_len = compare(#a_label, #b_label, -100),
		case = compare(a_case, b_case, 1000),
	}

	local a_sort = 0
	for _, n in pairs(cmp) do
		a_sort = a_sort + n
	end

	local b_sort = -a_sort

	return a_sort > b_sort
end
