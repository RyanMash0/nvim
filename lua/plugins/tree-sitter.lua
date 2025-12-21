return {
	src = 'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = 'TSUpdate',
	opts = {
		ensure_installed = {
			'markdown',
			'markdown_inline',
			'latex',
			'lua',
		},
		highlight = {
			enable = true,
		},
	},
	config = function()
		-- require("nvim-treesitter").install({
		-- 	'markdown',
		-- 	'markdown_inline',
		-- 	'latex',
		-- 	'lua',
		-- })
	end,
}
