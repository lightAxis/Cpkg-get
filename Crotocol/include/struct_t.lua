---@class Crotocol.struct_t
---@field Name string
---@field Fields table<number, Crotocol.field_t>
---@field Desc string
---@field new fun(name:string, desc?:string, fields?:table<number, Crotocol.field_t>, ):Crotocol.struct_t
local struct_t = {}

---constructor
---@param name string
---@param fields? table<number, Crotocol.field_t>
---@param desc? string
---@return Crotocol.struct_t
function struct_t.new(name, desc, fields)
    ---@type Crotocol.struct_t
    local a = {}
    a.Name = name
    ---@type table<number, Crotocol.field_t>
    a.Fields = fields or {}
    a.Desc = desc or ""
    return a
end

return struct_t
