return {
	{
		-- Set the PDF viewer to be Skim and the compiler to lualatex
	  "lervag/vimtex",
	  lazy = false,
	  init = function()
	    vim.g.vimtex_view_method = "skim"
			local latexmk_engine = {}
			latexmk_engine._ = '-lualatex'
			vim.g.vimtex_compiler_latexmk_engines = latexmk_engine
	  end
	},
}
