local class = require("Class.middleclass")

local THIS = PKGS.Tabullet

-- properties description
---@class Tabullet.ClickEventArgs : Tabullet.EventArgs
---@field Button Tabullet.Enums.MouseButton
---@field Pos MathLib.Vector2
---@field new fun(self:Tabullet.ClickEventArgs, button: Tabullet.Enums.MouseButton, pos: MathLib.Vector2): Tabullet.ClickEventArgs

-- public class ClickEventArgs : EventArgs
---
---**require**
--- - Class.middleclass
--- - UI.UIEvents.EventArgs
---@class Tabullet.ClickEventArgs : Tabullet.EventArgs
local ClickEventArgs = class("Tabullet.ClickEventArgs", THIS.UIEvent.EventArgs)

-- constructor
---@param button Tabullet.Enums.MouseButton
---@param pos MathLib.Vector2
function ClickEventArgs:initialize(button, pos)
    THIS.UIEvent.EventArgs.initialize(self)
    self.Button = button
    self.Pos = pos:Copy()
end

return ClickEventArgs
