-------------------------------------------------------------------------------
-- Neovim Built-in Package Manager                                           --
-------------------------------------------------------------------------------
table.unpack = table.unpack or unpack

local url_prefix = 'https://www.github.com/'

local config_dir = vim.fn.stdpath('config')
local path_core = vim.fs.joinpath(config_dir, 'lua', 'core', 'plugins')
local path_user = vim.fs.joinpath(config_dir, 'lua', 'user', 'plugins')

local remove_fname = 'remove.lua'
local remove_path = vim.fs.joinpath(path_user, remove_fname)
local success, remove_data = pcall(dofile, remove_path)
if not success then remove_data = nil end
local remove = {}

local plugins = {}
local names = {}

local function populate_remove_tbl()
	if not remove_data then return end
	if remove_data.src then remove[remove_data.src] = true return end
	for _, plugin in ipairs(remove_data) do
		remove[plugin.src] = true
	end
end

local function add_plugin_from_file(self, file)
	if not file then return end
	if file.src and not remove[file.src] then self[#self+1] = file return end
	for _, plugin in ipairs(file) do
		if not remove[plugin.src] then
			self[#self+1] = plugin
		end
	end
end

local function install_deps(dependencies, list)
	for _, plugin in ipairs(dependencies) do
		list[#list+1] = { src = plugin }
	end
end

local function format_config(plugin)
	plugin.name = plugin.src:match('[^/]+$')
	plugin.src = url_prefix .. plugin.src
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

local function find_func()
	return function(name)
		return name:match('%.lua$') and true or false
	end
end

local function get_find_opts(path)
	return {
		limit = math.huge,
		type = 'file',
		path = path,
	}
end

local plugin_files = vim.fs.find(find_func(), get_find_opts(path_core))
local temp_files = vim.fs.find(find_func(), get_find_opts(path_user))
for i, path in ipairs(temp_files) do
	if path:match(remove_fname) then
		table.remove(temp_files, i)
		break
	end
end
vim.list_extend(plugin_files, temp_files)

populate_remove_tbl()

for _, path in ipairs(plugin_files) do
	add_plugin_from_file(plugins, dofile(path))
end

for _, plugin in ipairs(plugins) do
	format_config(plugin)
	if plugin.dependencies then
		install_deps(plugin.dependencies, plugins)
	end
end

function PluginsAdd()
	vim.pack.add(plugins)
	plugins_setup(plugins)
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
		vim.defer_fn(PluginsUpdate, 100)
	end
})
