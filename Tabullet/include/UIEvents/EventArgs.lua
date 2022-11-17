local class = require("Class.middleclass")

-- properties description
---@class Tabullet.EventArgs
---@field Handled boolean
---@field new fun(self:Tabullet.EventArgs): Tabullet.EventArgs

---public class EventArgs
---
---**require** :
--- - Class.middleclass
---@class Tabullet.EventArgs
local EventArgs = class("Tabullet.EventArgs")

---constructor
function EventArgs:initialize() self.Handled = false end

return EventArgs
