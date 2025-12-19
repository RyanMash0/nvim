-------------------------------------------------------------------------------
-- LSP Completion Conversion Utility                                         --
-------------------------------------------------------------------------------
-- Symbols that go before the kind of the completion entry
local lsp_kind_symbol = {
	Text  = '',
	Method  = '',
	Function  = '',
	Constructor  = '',
	Field  = '',
	Variable  = '',
	Class  = '',
	Interface  = '',
	Module  = '',
	Property = '',
	Unit = '',
	Value = '',
	Enum = '',
	Keyword = '',
	Snippet = '',
	Color = '',
	File = '',
	Reference = '',
	Folder = '',
	EnumMember = '',
	Constant = '',
	Struct = '',
	Event = '',
	Operator = '',
	TypeParameter = '',
}

--- Shorten a string to be at most max characters
local function truncate(s, max)
	if not s then return s end
	if #s <= max then return s end
	return s:sub(1, max - 1) .. "..."
end

--- Set formatting for CompletionItem entries
function LspConvert(item)
	-- Format the CompletionItem label to include any number of words separated
	-- by " ", ".", or "_", optionally starting with a non-ascii symbol (clangd)
	local label = item.label:match('[^ -~]*[%s]?[%w+%s?\\.?\\_?]+')
	local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind]
	or "Text"
	local icon = lsp_kind_symbol[kind_name] or " "

	-- Set the info portion of the neovim complete-item to be either the 
	-- CompletionItem's documentation or its detail
	local info
	if type(item.documentation) == "table" then
		info = item.documentation.value
	elseif type(item.documentation) == "string" then
		info = item.documentation
	else
		info = item.detail
	end

	return {
		abbr = truncate(label, 20),
		menu = truncate(item.detail, 30),
		info = info,
		kind = icon .. ' ' .. kind_name,
		kind_hlgroup = 'CmpItemKind' .. kind_name,
	}
end
