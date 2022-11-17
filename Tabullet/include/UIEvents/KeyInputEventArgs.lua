local class = require("Class.middleclass")

local THIS = PKGS.Tabullet

-- properties description
---@class Tabullet.KeyInputEventArgs
---@field Key Tabullet.Enums.Key
---@field IsShiftPressed boolean
---@field new fun(self:Tabullet.KeyInputEventArgs, key:Tabullet.Enums.Key, isShiftPressed?: boolean): Tabullet.KeyInputEventArgs

-- public class KeyInputEventArgs : EventArgs
---
---**require** :
--- - Class.middleclass
--- - UI.UIEvents.EventArgs
---@class Tabullet.KeyInputEventArgs : Tabullet.EventArgs
local KeyInputEventArgs = class("KeyInputEventArgs", THIS.UIEvent.EventArgs)

-- constructor
---@param key Tabullet.Enums.Key
---@param isShiftPressed boolean
function KeyInputEventArgs:initialize(key, isShiftPressed)
    THIS.UIEvent.EventArgs.initialize(self)
    self.Key = key
    self.IsShiftPressed = isShiftPressed
end

return KeyInputEventArgs
