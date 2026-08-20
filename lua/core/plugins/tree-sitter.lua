return {
	src = 'nvim-treesitter/nvim-treesitter',
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
	build = 'TSUpdate',
}
