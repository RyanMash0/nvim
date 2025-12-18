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

local function truncate(s, max)
	if not s then return s end
	if #s <= max then return s end
	return s:sub(1, max - 1) .. "..."
end

function LspConvert(item)
	local label = item.label:match('[^ -~]*[%s]?[%w+%s?\\.?\\_?]+')
	local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind]
	or "Text"
	local icon = lsp_kind_symbol[kind_name] or " "

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
