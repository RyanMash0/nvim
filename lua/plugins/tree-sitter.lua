return {
	src = 'nvim-treesitter/nvim-treesitter',
	lazy = false,
	opts = {
		ensure_installed = {
			'markdown',
			'markdown_inline',
			'lua',
			'latex',
		},
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	},
	config = vim.schedule(function()
		vim.cmd.TSUpdate()
	end),
}
