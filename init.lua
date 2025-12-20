-------------------------------------------------------------------------------
-- Neovim Config File                                                        --
-------------------------------------------------------------------------------

package.loaded['config.keymaps'] = nil
package.loaded['config.options'] = nil
package.loaded['config.lsp'] = nil
package.loaded['config.completion'] = nil

require('config.keymaps')
require('config.pack')
require('config.options')
require('config.lsp')
require('config.completion')

-------------------------------------------------------------------------------
-- Custom Plugins                                                            --
-------------------------------------------------------------------------------

package.loaded['custom.PostSurround'] = nil
package.loaded['custom.PreSurround'] = nil
package.loaded['custom.DeleteSurround'] = nil
package.loaded['custom.ChangeSurround'] = nil
package.loaded['custom.TextObjMotion'] = nil
package.loaded['custom.MakeSet'] = nil

require('custom.PostSurround')
require('custom.PreSurround')
require('custom.DeleteSurround')
require('custom.ChangeSurround')
require('custom.TextObjMotion')
require('custom.MakeSet')
