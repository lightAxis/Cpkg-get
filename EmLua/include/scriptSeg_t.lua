---@class EmLua.ScriptSeg_t
---@field str string
---@field isRawScript boolean
---@field new fun(self:EmLua.ScriptSeg_t):EmLua.ScriptSeg_t
local seg_t = {}

function seg_t:new()
    local a = {}
    a.str = nil
    a.isRawScript = nil
    return a
end

return seg_t
