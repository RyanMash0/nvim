return {
	-- Set the PDF viewer to be Skim and the compiler to lualatex
	src = "lervag/vimtex",
	lazy = false,
	config = function()
		-- Change which of these lines is commented based on os
		vim.g.vimtex_view_method = "zathura" -- Linux
		-- vim.g.vimtex_view_method = "skim" -- MacOS

		local latexmk_engine = {}
		latexmk_engine._ = '-lualatex'
		vim.g.vimtex_compiler_latexmk_engines = latexmk_engine
	end
}
