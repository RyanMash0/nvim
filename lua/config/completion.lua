-------------------------------------------------------------------------------
-- LSP Completion Menu Config                                                --
-------------------------------------------------------------------------------
require('config.lsp')
require('config.completion_utils.compare')
require('config.completion_utils.convert')

vim.api.nvim_create_augroup('lsp_completion', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
	group = 'lsp_completion',
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if not client:supports_method('textDocument/completion') then
			return
		end
		local chars = {}
		for i = 32, 126 do
			table.insert(chars, string.char(i))
		end
		client.server_capabilities.completionProvider.triggerCharacters = chars
		vim.lsp.completion.enable(true, client.id, args.buf, {
			autotrigger = true,
			convert = LspConvert,
			cmp = LspCmp,
		})
	end
})
