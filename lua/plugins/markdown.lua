return {
	{
		src = 'jbyuki/nabla.nvim',
	},
	{
		src = 'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-mini/mini.nvim', },
		opts = {
			file_types = { 'markdown' },
			latex = { enabled = false, },
			win_options = { conceallevel = { rendered = 2 } },
			render_modes = true,
			on = {
				render = function()
					require('nabla').enable_virt({ autogen = true, silent = true })
				end,
				clear = function()
					require('nabla').disable_virt()
				end,
			},
		},
		config = function()
			vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
				pattern = {"*.md", "*.markdown"},
				callback = function()
					vim.treesitter.start(0, 'markdown')
				end
			})
		end,
	},
}
