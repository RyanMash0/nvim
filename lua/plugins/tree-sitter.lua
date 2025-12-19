return {
	{
		'nvim-treesitter/nvim-treesitter',
		lazy = false,
		build = ':TSUpdate',
		ensure_installed = { "markdown", "markdown_inline", "latex" },
	},
}
