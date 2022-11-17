local class = require("Class.middleclass")

---properties description
---@class Tabullet.Screen_t.Buffer
---@field Text string
---@field BG string
---@field FG string
---@field new fun(self:Tabullet.Screen_t.Buffer, text:string, fg:string, bg:string):Tabullet.Screen_t.Buffer

---@class Tabullet.Screen_t.Buffer
local Buffer = class("Tabullet.Screen_t.Buffer")

---constructor
---@param text string
---@param fg string
---@param bg string
function Buffer:initialize(text, fg, bg)
    self.Text = text
    self.FG = fg
    self.BG = bg
end

return Buffer
