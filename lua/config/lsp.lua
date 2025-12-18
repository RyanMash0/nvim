-------------------------------------------------------------------------------
-- LSP Config                                                                --
-------------------------------------------------------------------------------
vim.diagnostic.config({ virtual_text = true })

local no_opts = {}

local clangd_opts = {
	cmd = {
		"clangd",
		"--background-index",
	},
}

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

vim.lsp.config('clangd', clangd_opts)
vim.lsp.config('jdtls', no_opts)
vim.lsp.config('lua_ls', lua_ls_opts)
vim.lsp.config('pyright', no_opts)
vim.lsp.config('texlab', no_opts)
vim.lsp.config('ts_ls', no_opts)

vim.lsp.enable("clangd")
vim.lsp.enable("jdtls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("texlab")
vim.lsp.enable("ts_ls")
