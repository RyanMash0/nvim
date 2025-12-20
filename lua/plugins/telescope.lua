return {
	src = 'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function ()
		local telescope = require('telescope')

		-- Exclude these paths from Telescope search
		local exclude_dirs = {
			'**/lazy/**',
			'**/swap/**',
			'**/shada/**',
			'**/\\.git/**',
		}

		-- Exclude these filetypes from Telescope search
		local exclude_files = {
			'**/\\.DS_Store',
			'*\\.xlsx',
			'*\\.class',
			'*\\.zip',
			'*\\.jpeg',
			'*\\.jpg',
			'*\\.png',
			'*\\.docx',
			'*\\.mp3',
			'*\\.mp4',
			'*\\.mov',
			'*\\.wav',
			'*\\.pkf',
		}

		-- Exclude these LaTeX related file types from Telescope search
		local exclude_tex = {
			'*\\.pdf',
			'*\\.fls',
			'*\\.aux',
			'*\\.synctex',
			'*\\.synctex.gz',
			'*\\.fdb_latexmk',
		}

		--- ripgrep arguments for finding files
		-- Executes "rg --files --hidden ..."
		local find_args = { 'rg', '--files', '--hidden' }

		--- Remove directories from ripgrep search
		-- Adds arguments of the form "--glob=!..."
		for i = 1, #exclude_dirs, 1 do
			find_args[#find_args + 1] = '--glob=!'..exclude_dirs[i]
		end

		--- Remove files from ripgrep search
		-- Adds arguments of the form "--glob=!..."
		for i = 1, #exclude_files, 1 do
			find_args[#find_args + 1] = '--glob=!'..exclude_files[i]
		end

		--- Remove LaTeX related files from ripgrep search
		-- Adds arguments of the form "--glob=!..."
		for i = 1, #exclude_tex, 1 do
			find_args[#find_args + 1] = '--glob=!'..exclude_tex[i]
		end

		-- Set up/down keybinds and set the file finding command
		telescope.setup({
			defaults = {
				mappings = {
					i = {
						['<C-l>'] = 'move_selection_previous',
						['<C-h>'] = 'move_selection_next',
					},
				},
			},
			pickers = {
				find_files = {
					find_command = find_args,
				}
			}
		})
	end
}
