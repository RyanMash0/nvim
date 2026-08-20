-------------------------------------------------------------------------------
-- LSP Completion Conversion Utility                                         --
-------------------------------------------------------------------------------
-- Symbols that go before the kind of the completion entry
local lsp_kind = {
	Text					= {'', 'TSText'},
	Method				= {'', 'TSMethod'},
	Function			= {'', 'TSFunction'},
	Constructor		= {'', 'TSConstructor'},
	Field					= {'', 'TSField'},
	Variable			= {'', 'TSVariable'},
	Class					= {'', 'TSType'},
	Interface			= {'', 'TSType'},
	Module				= {'', 'TSNamespace'},
	Property			= {'', 'TSProperty'},
	Unit					= {'', 'Purple'},
	Value					= {'', 'Purple'},
	Enum					= {'', 'TSType'},
	Keyword				= {'', 'TSKeyword'},
	Snippet				= {'', 'Aqua'},
	Color					= {'', 'Aqua'},
	File					= {'', 'Green'},
	Reference			= {'', 'TSTextReference'},
	Folder				= {'', 'Aqua'},
	EnumMember		= {'', 'TSProperty'},
	Constant			= {'', 'TSConstant'},
	Struct				= {'', 'TSType'},
	Event					= {'', 'TSLabel'},
	Operator			= {'', 'TSOperator'},
	TypeParameter	= {'', 'TSTypeDefinition'},
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
	local label = item.label:gsub('%b()', ''):gsub('[%s%.%-:][%s%.%-:]+.*$', '')
	local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind]
	or "Text"
	local icon = lsp_kind[kind_name][1] or " "

	-- Set the info portion of the neovim complete-item to be either the 
	-- CompletionItem's documentation or its detail

	-- local menu
	-- if not item.documentation and item.detail and item.detail:match('%w%.%w') then
	-- 	menu = ''
	-- else
	-- 	menu = truncate(item.detail, 20)
	-- end

	return {
		abbr = truncate(label, 20),
		-- menu = menu,
		menu = truncate(item.detail, 20),
		info = '',
		kind = icon .. ' ' .. kind_name,
		kind_hlgroup = lsp_kind[kind_name][2],
	}
end
