return {
	src = 'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = 'TSUpdate',
	opts = {
		ensure_installed = {
			'markdown',
			'markdown_inline',
			'latex',
		},
		-- highlight = {
		-- 	-- enable = true,
		-- },
	},
	config = function()
	end,
}
