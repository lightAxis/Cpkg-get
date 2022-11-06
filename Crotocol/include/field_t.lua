---@class Crotocol.field_t
---@field Name string
---@field Type string
---@field Init string
---@field Desc string
---@field new fun(name:string, type:string, init?:string, desc?:string):Crotocol.field_t
local field_t = {}

---constructor
---@param name string
---@param type string
---@param init? string
---@param desc? string
---@return Crotocol.field_t
function field_t.new(name, type, init, desc)
    ---@type Crotocol.field_t
    local a = {}
    a.Name = name
    a.Type = type
    a.Init = init or "nil"
    a.Desc = desc or ""
    return a
end

return field_t
