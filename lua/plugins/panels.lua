return {
	src = 'RyanMash0/nvim-panels',
	opts = {
		layout = {
			right = {
				module = function() return require('nvim-panels.terminal') end,
				width = 50,
			},
			bottom = {
				module = function() return nil end,
			}
		}
	}
}
