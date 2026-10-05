-------------------------------------------------------------------------------
-- UI Config                                                                 --
-------------------------------------------------------------------------------
require('vim._core.ui2').enable({
	enable = true,
	msg = {
		targets = {
			[''] = 'msg',
			empty = 'cmd',
			bufwrite = 'msg',
			confirm = 'cmd',
			emsg = 'pager',
			echo = 'msg',
			echomsg = 'msg',
			echoerr = 'pager',
			completion = 'cmd',
			list_cmd = 'pager',
			lua_error = 'pager',
			lua_print = 'msg',
			progress = 'msg',
			rpc_error = 'pager',
			quickfix = 'msg',
			search_cmd = 'cmd',
			search_count = 'cmd',
			shell_cmd = 'pager',
			shell_err = 'pager',
			shell_out = 'pager',
			shell_ret = 'msg',
			undo = 'msg',
			verbose = 'pager',
			wildlist = 'cmd',
			wmsg = 'msg',
		},
	},
})

vim.opt.messagesopt:append({ 'maxheight:25', 'timeout:5000' })
