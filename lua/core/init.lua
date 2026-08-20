-------------------------------------------------------------------------------
-- Core Configs                                                              --
-------------------------------------------------------------------------------
local config = 'core.config.'
package.loaded[config..'pack'] = nil
package.loaded[config..'keymaps'] = nil
package.loaded[config..'options'] = nil
package.loaded[config..'lsp'] = nil
package.loaded[config..'completion'] = nil
package.loaded[config..'ui'] = nil

require(config..'pack')
require(config..'keymaps')
require(config..'options')
require(config..'lsp')
require(config..'completion')
require(config..'ui')

-------------------------------------------------------------------------------
-- Custom Plugins                                                            --
-------------------------------------------------------------------------------
local custom = 'core.custom.'
package.loaded[custom..'surround.PostSurround'] = nil
package.loaded[custom..'surround.PreSurround'] = nil
package.loaded[custom..'surround.DeleteSurround'] = nil
package.loaded[custom..'surround.ChangeSurround'] = nil
package.loaded[custom..'surround.TextObjMotion'] = nil
package.loaded[custom..'Reload'] = nil

require(custom..'surround.PostSurround')
require(custom..'surround.PreSurround')
require(custom..'surround.DeleteSurround')
require(custom..'surround.ChangeSurround')
require(custom..'surround.TextObjMotion')
require(custom..'Reload')
