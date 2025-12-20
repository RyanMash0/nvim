-------------------------------------------------------------------------------
-- Neovim Built-in Package Manager                                           --
-------------------------------------------------------------------------------
table.unpack = table.unpack or unpack

local plugin_dir = 'plugins'
local config_dir = '.config/nvim/lua'
local home_dir = os.getenv('HOME') or os.getenv('USERPROFILE')
Plugins = {}

function Plugins:add_plugin_from_file(file)
	if file.src then self[#self+1] = file return end
	for _, plugin in ipairs(file) do
		self[#self+1] = plugin
	end
end

local plugin_files = vim.fs.find(function(name)
	return name:match('[^/%.]+%.lua$')
end, {
	limit = math.huge,
	type = 'file',
	path = home_dir..'/'..config_dir..'/'..plugin_dir,
})

local path_str
for _, path in ipairs(plugin_files) do
	path_str = plugin_dir .. '.' .. path:match('[^/]+$'):match('^[^%.]+')
	Plugins:add_plugin_from_file(require(path_str))
end

Plugins.add_plugin_from_file = nil

local function install_deps(dependencies, list)
	for _, plugin in ipairs(dependencies) do
		list[#list+1] = { src = plugin }
	end
end

local function format_config(plugin)
	plugin.name = plugin.src:match('[^/]+$')
	plugin.src = 'https://www.github.com/' .. plugin.src
end

for _, plugin in ipairs(Plugins) do
	format_config(plugin)
	if plugin.dependencies then
		install_deps(plugin.dependencies, Plugins)
	end
end

vim.pack.add(Plugins)

for _, plugin in ipairs(Plugins) do
	if plugin.opts then
		require(plugin.name:match('^[^%.]+')).setup(plugin.opts)
	end
	if plugin.config then plugin.config() end
	if plugin.build then
		vim.defer_fn(function()
			vim.cmd(plugin.build)
			vim.cmd.messages('clear')
		end, 10)
	end
end

local names = {}
for i, plugin in ipairs(Plugins) do
	names[i] = plugin.name
end

function PackUpdate()
	vim.pack.update(names, { force = true })
end

vim.api.nvim_create_user_command('PackUpdate',
	function()
		PackUpdate()
	end,
	{ nargs = 0 }
)

vim.api.nvim_create_augroup('pack', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
	group = 'pack',
	callback = function()
		vim.cmd.PackUpdate()
	end
})
