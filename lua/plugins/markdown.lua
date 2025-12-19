return {
	{ 'jbyuki/nabla.nvim' },
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
		opts = {
			latex = { enabled = false },
			win_options = { conceallevel = { rendered = 2 } },
			on = {
				render = function()
					require('nabla').enable_virt({ autogen = true })
				end,
				clear = function()
					require('nabla').disable_virt()
				end,
			},
		},
	},
}
