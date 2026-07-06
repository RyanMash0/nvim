-------------------------------------------------------------------------------
-- Neovim Built-in Package Manager                                           --
-------------------------------------------------------------------------------
table.unpack = table.unpack or unpack

local plugin_dir = 'plugins'
local full_dir = vim.fs.joinpath('lua', plugin_dir)
local config_dir = vim.fn.stdpath('config')
full_dir = vim.fs.joinpath(config_dir, full_dir)
Plugins = {}
PluginsPre = {}
local names = {}

local function add_plugin_from_file(self, file)
	if file.src then self[#self+1] = file return end
	for _, plugin in ipairs(file) do
		self[#self+1] = plugin
	end
end

local function install_deps(dependencies, list)
	for _, plugin in ipairs(dependencies) do
		list[#list+1] = { src = plugin }
	end
end

local function format_config(plugin)
	plugin.name = plugin.src:match('[^/]+$')
	plugin.src = 'https://www.github.com/' .. plugin.src
end

local function plugins_setup(self)
	for _, plugin in ipairs(self) do
		if plugin.opts then
			require(plugin.name:match('^[^%.]+')).setup(plugin.opts)
		end
		if plugin.config then plugin.config() end
		if plugin.build then
			vim.schedule(function() vim.cmd(plugin.build) end)
		end
	end

	for i, plugin in ipairs(self) do
		names[i] = plugin.name
	end
end

local plugin_files = vim.fs.find(function(name)
	return name:match('%.lua$') and true or false
end, {
	limit = math.huge,
	type = 'file',
	path = full_dir,
})

local path_str
local plugin_file
for _, path in ipairs(plugin_files) do
	path_str = plugin_dir .. '.' .. vim.fs.basename(path):match('^[^%.]+')
	plugin_file = require(path_str)
	if plugin_file.preload then
		add_plugin_from_file(PluginsPre, plugin_file)
	else
		add_plugin_from_file(Plugins, plugin_file)
	end
end

for _, plugin in ipairs(Plugins) do
	format_config(plugin)
	if plugin.dependencies then
		install_deps(plugin.dependencies, Plugins)
	end
end

vim.pack.add(PluginsPre)
plugins_setup(PluginsPre)

function PluginsAdd()
	vim.pack.add(Plugins)
	plugins_setup(Plugins)
end

function PluginsUpdate()
	vim.pack.update(names, { force = true })
end

vim.api.nvim_create_user_command('PluginsAdd',
	function()
		PluginsAdd()
	end,
	{ nargs = 0 }
)

-- vim.pack.get()
vim.api.nvim_create_user_command('PluginsUpdate',
	function()
		PluginsUpdate()
	end,
	{ nargs = 0 }
)

vim.api.nvim_create_augroup('pack', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
	group = 'pack',
	callback = function()
		PluginsAdd()
	end
})

vim.api.nvim_create_autocmd('VimEnter', {
	group = 'pack',
	callback = function()
		vim.defer_fn(PluginsUpdate, 1000)
	end
})
