-------------------------------------------------------------------------------
-- LSP Completion Menu Config                                                --
-------------------------------------------------------------------------------
require('config.lsp')
require('config.completion_utils.compare')
require('config.completion_utils.convert')

--- Autocommand to customize completion whenever an lsp recognizes a file
vim.api.nvim_create_augroup('lsp_completion', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
	group = 'lsp_completion',
	callback = function(args)
		-- This is just how you are supposed to do this part per the help pages
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if not client:supports_method('textDocument/completion') then
			return
		end

		-- Set autocomplete to trigger on any key press, also from the help pages
		local chars = {}
		for i = 32, 126 do table.insert(chars, string.char(i)) end
		client.server_capabilities.completionProvider.triggerCharacters = chars

		-- Set the functions that run whenever completion is triggered
		-- The convert field controls how each entry is displayed in the menu
		-- The cmp field controls how the entries are sorted
		vim.lsp.completion.enable(true, client.id, args.buf, {
			autotrigger = true,
			convert = LspConvert,
			cmp = LspCmp,
		})
	end
})
