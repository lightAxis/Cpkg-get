local class = require("Class.middleclass")

local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2

-- properties description
---@class Tabullet.ScrollEventArgs
---@field Direction Tabullet.Enums.ScrollDirection
---@field Pos MathLib.Vector2
---@field new fun(self:Tabullet.ScrollEventArgs, direction: Tabullet.Enums.ScrollDirection, pos: MathLib.Vector2): Tabullet.ScrollEventArgs

-- public class ScrollEventArgs : JLib.UIEvent.EventArgs
---
---**require** :
--- - Class.middleclass
--- - UI.UIEvent
---@class Tabullet.ScrollEventArgs : Tabullet.EventArgs
local ScrollEventArgs = class("ScrollEventArgs", THIS.UIEvent.EventArgs)

-- constructor
---@param direction Tabullet.Enums.ScrollDirection
---@param pos MathLib.Vector2
function ScrollEventArgs:initialize(direction, pos)
    THIS.UIEvent.EventArgs.initialize(self)
    self.Direction = direction
    self.Pos = pos:Copy()
end

return ScrollEventArgs
