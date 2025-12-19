-------------------------------------------------------------------------------
-- LSP Completion Comparison Utility                                         --
-------------------------------------------------------------------------------
--- Helper function that gets an entry formatted as an LSP CompletionItem
-- The details of why this function is written this way are complicated and
-- hard to find. The way I was able to determine this structure was by printing
-- out the user_data field that gets set for a neovim complete-item
local function get_ci(entry)
  return entry
    and entry.user_data
    and entry.user_data.nvim
    and entry.user_data.nvim.lsp
    and entry.user_data.nvim.lsp.completion_item
end

--- Safe string function
local function str(s)
	if type(s) ~= "string" then return "" end
	return s
end

--- Rank completion items based on case match
-- Entries that match the case of what is being typed are ranked higher
local function case_prefix_score(label, prefix)
  if prefix == "" then return 0 end

	-- Full match
  if label == prefix then return 2 end

	-- Partial match
  if label:sub(1, #prefix) == prefix then return 1 end

	-- Case-insensitive match
  if label:find(prefix, 1, true) then return -1 end

	-- No match
  return -2
end

--- Compare two values and return a clear winner
-- x > y returns weight
-- x < y returns -weight
-- x == y returns 0
-- A negative weight reverses the outputs
local function compare(x, y, weight)
	if x == y then
		return 0
	elseif x < y then
		return -weight
	end
	return weight
end

--- Compare function for LSP completion entries
function LspCmp(a, b)
	-- Get the LSP CompletionItem entries for a and b
  local a_ci = get_ci(a)
  local b_ci = get_ci(b)
  if not a_ci or not b_ci then return 0 end

	-- Get the cursor position and use it to set prefix to the part of the word 
	-- before the cursor
	local cur = vim.api.nvim_win_get_cursor(0)[2]
  local prefix = vim.fn.matchstr(vim.fn.getline("."):sub(1, cur), [[\k*$]])

	-- Format the CompletionItem labels to remove anything inside () and any
	-- symbols that are not in the standard ascii range (so that the bullet point
	-- in some clangd entries is not included in the matching function)
  local a_label = str(a_ci.label):gsub('%b()', ''):match('[!-~]+')
  local b_label = str(b_ci.label):gsub('%b()', ''):match('[!-~]+')

	-- Clip both labels to be the same length for alphabetical comparison
	local min_label_len = math.min(#a_label, #b_label)
	local a_format_label = a_label:sub(1, min_label_len):lower()
	local b_format_label = b_label:sub(1, min_label_len):lower()

	-- Get whether the case of the CompletionItem matches what has been typed
	local a_case = case_prefix_score(a_label, prefix)
	local b_case = case_prefix_score(b_label, prefix)

	-- Weigh different sorting factors:
	-- -label: compares the labels alphabetically, alphabetically earlier entries
	--  	will come first, lowest weight
	-- -label_len: compares the lengths of the labels, shorter entries will come
	--  	first, middle weight
	-- -case: compares the case-sensitive match of the label and what has been
	--  	typed, entries that match case score higher, highest weight
	local cmp = {
		label = compare(a_format_label, b_format_label, -10),
		label_len = compare(#a_label, #b_label, -100),
		case = compare(a_case, b_case, 1000),
	}

	-- Sum sorting factors
	local a_sort = 0
	for _, n in pairs(cmp) do
		a_sort = a_sort + n
	end

	-- If a won, then b lost, so this is a shortcut for computing the same
	-- comparisons in reverse
	local b_sort = -a_sort

	-- Return whether a or b is a better match
	return a_sort > b_sort
end
