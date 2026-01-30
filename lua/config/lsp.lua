-------------------------------------------------------------------------------
-- LSP Config                                                                --
-------------------------------------------------------------------------------
vim.diagnostic.config({ virtual_text = true })

local no_opts = {}

-- Clangd options
local clangd_opts = {
	cmd = {
		"clangd",
		"--background-index",
	},
}

-- Lua language server options, adds vim commands
local lua_ls_opts = {
	settings = {
		Lua = {
			diagnostics = {
				globals = {'vim'}
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true),
			},
		},
	},
}

-- Set language server configs
vim.lsp.config('clangd', clangd_opts)
vim.lsp.config('jdtls', no_opts)
vim.lsp.config('lua_ls', lua_ls_opts)
vim.lsp.config('pyright', no_opts)
vim.lsp.config('texlab', no_opts)
vim.lsp.config('ts_ls', no_opts)
vim.lsp.config('marksman', no_opts)

-- Enable language servers
vim.lsp.enable("clangd")
vim.lsp.enable("jdtls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("texlab")
vim.lsp.enable("ts_ls")
vim.lsp.enable("marksman")

vim.api.nvim_create_augroup('lsp_treesitter', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
	group = 'lsp_treesitter',
	callback = function (args)
		-- vim.print(args)
		if args.match == 'netrw' or args.match == 'man' then return end
		local lang = vim.treesitter.language.get_lang(args.match)

		local parser_count = #vim.api.nvim_get_runtime_file(
			'parser/'..lang..'.so', true
		)

		local delay = 0
		if parser_count < 1 then
			require('nvim-treesitter').install(lang)
			delay = 30000
		end

		vim.defer_fn(function ()
			vim.treesitter.start(args.buf, lang)
		end, delay)
	end
})
