local class = require("Class.middleclass")

local THIS = PKGS.Tabullet

-- properties description
---@class Tabullet.CharEventArgs : Tabullet.EventArgs
---@field Char string
---@field new fun(self:Tabullet.CharEventArgs, char: string): Tabullet.CharEventArgs

--- public class CharEventArgs : EventArgs
---
---**require**
--- - Class.middleclass
--- - UI.UIEvents.EventArgs
---@class Tabullet.CharEventArgs : Tabullet.EventArgs
local CharEventArgs = class("Tabullet.CharEventArgs", THIS.UIEvent.EventArgs)


-- consturctor
---@param char string
function CharEventArgs:initialize(char)
    THIS.UIEvent.EventArgs.initialize(self)
    self.Char = char
end

return CharEventArgs;
