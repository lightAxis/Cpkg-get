---@class EmLua.Stringseg_t
---@field str string
---@field scptLevel number
---@field varLevel number
---@field new fun(self:EmLua.Stringseg_t):EmLua.Stringseg_t
local seg_t = {}

function seg_t:new()
    local a = {}
    a.str = nil
    a.scptLevel = nil
    a.varLevel = nil
    return a
end

return seg_t
