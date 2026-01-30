-------------------------------------------------------------------------------
-- LSP Completion Menu Config                                                --
-------------------------------------------------------------------------------
require('config.lsp')
require('config.completion_utils.compare')
require('config.completion_utils.convert')
local state = require('config.completion_utils.state')

--- Autocommand to customize completion whenever an lsp recognizes a file
vim.api.nvim_create_augroup('lsp_completion', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
	group = 'lsp_completion',
	callback = function(args)
		-- This is just how you are supposed to do this part per the help pages
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if not client:supports_method('textDocument/completion') then
			return
		end

		-- Set autocomplete to trigger on any key press, also from the help pages
		local chars = {}
		for i = 32, 126 do table.insert(chars, string.char(i)) end
		client.server_capabilities.completionProvider.triggerCharacters = chars

		-- Set the functions that run whenever completion is triggered
		-- The convert field controls how each entry is displayed in the menu
		-- The cmp field controls how the entries are sorted
		vim.lsp.completion.enable(true, client.id, args.buf, {
			autotrigger = true,
			convert = LspConvert,
			cmp = LspCmp,
		})
	end
})

vim.api.nvim_create_autocmd('CompleteDone', {
	group = 'lsp_completion',
	callback = function()
		if state.pum_docs_win then
			vim.api.nvim_win_close(state.pum_docs_win, true)
			state.pum_docs_win = nil
		end
		if state.pum_docs_buf then
			vim.api.nvim_buf_delete(state.pum_docs_buf, { force = true })
			state.pum_docs_buf = nil
		end
	end
})

vim.api.nvim_create_autocmd('CompleteChanged', {
	group = 'lsp_completion',
	callback = function()
		local supported = false
		local lsp_clients = vim.lsp.get_clients()
		for _, client in ipairs(lsp_clients) do
			if client.server_capabilities.completionProvider.resolveProvider then
				supported = true
			end
		end

		local cmp_info = vim.fn.complete_info()
		if cmp_info.pum_visible == 0 or cmp_info.selected < 0 then
			return
		end
		local selected = cmp_info.items[cmp_info.selected + 1]
		if not selected then return end
		local item = selected.user_data.nvim.lsp.completion_item

		local resolve_handler = function(responses)
			if not state.pum_docs_buf then
				state.pum_docs_buf = vim.api.nvim_create_buf(false, false)
				vim.bo[state.pum_docs_buf].filetype = 'markdown'
				vim.bo[state.pum_docs_buf].modifiable = false
				--vim.bo[state.pum_docs_buf].formatlistpat = "^\\s*\\d\\+\\.\\s\\+\\|^\\s*[-*+]\\s\\+\\|^\\[^\\ze[^\\]]\\+\\]:\\&^.\\{4\\}"
				--vim.bo[state.pum_docs_buf].formatoptions = "jtcqln"
				vim.treesitter.start(state.pum_docs_buf, 'markdown')
			end

			if state.pum_docs_win then
				vim.api.nvim_win_close(state.pum_docs_win, true)
				state.pum_docs_win = nil
			end

			local result = responses[1].result
			if vim.fn.pumvisible() == 0 then return end
			if not result.documentation and not result.detail then return end
			local docs
			if not result.documentation then
				docs = vim.lsp.util.convert_input_to_markdown_lines(result.detail)
			else
				docs = vim.lsp.util.convert_input_to_markdown_lines(result.documentation.value)
			end
			local pum_pos = vim.fn.pum_getpos()

			local width_offset = pum_pos.col + pum_pos.width + 2
			local win_width = 0
			local win_height = 0
			for _, s in ipairs(docs) do
				if #s > win_width then
					win_width = #s
				end

				if not s:match('```') and s ~= '' then
					win_height = win_height + 1
				end
			end

			if vim.go.columns - width_offset < win_width then
				win_width = vim.go.columns - width_offset
			end

			local divider = ''
			for _ = 1, win_width do
				divider = divider .. '─'
			end

			local encoded
			for i = #docs, 1, -1 do
				encoded = docs[i]:match('!%[[^%]]+]')
				if #docs[i] > win_width and not encoded then
					win_height = win_height + math.ceil(#docs[i] / win_width) - 1
				end

				if encoded then
					win_width = #encoded - 1
				end
				if docs[i] == '' then
					table.remove(docs, i)
				end

				if docs[i] == '---' then
					docs[i] = divider
				end
			end

			vim.bo[state.pum_docs_buf].modifiable = true
			vim.api.nvim_buf_set_text(state.pum_docs_buf, 0, 0, -1, -1, docs)
			vim.bo[state.pum_docs_buf].modifiable = false

			local win_config = {
				row = pum_pos.row,
				col = width_offset,
				width = win_width,
				height = win_height,
				focusable = false,
				relative = 'editor',
				style = 'minimal',
			}

			state.pum_docs_win = vim.api.nvim_open_win(state.pum_docs_buf, false, win_config)
			vim.wo[state.pum_docs_win].winfixbuf = true
			vim.wo[state.pum_docs_win].conceallevel = 2
			vim.wo[state.pum_docs_win].linebreak = true
		end

		if not supported then
			vim.schedule(function () resolve_handler({{ result = item }}) end)
			return
		end

		vim.lsp.buf_request_all(0, 'completionItem/resolve', item, resolve_handler)
	end,
})
