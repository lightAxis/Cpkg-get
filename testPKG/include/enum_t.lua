---@class Crotocol.enum_t
---@field Name string name of enum
---@field Table table<number, Crotocol.enumElm_t>
---@field Desc string description
---@field new fun(name:string, desc?:string, table?:table<number, Crotocol.enumElm_t>):Crotocol.enum_t
local enum_t = {}

---constructor
---@param name string
---@param desc? string
---@param table? table<number, Crotocol.enumElm_t>
---@return Crotocol.enum_t
function enum_t.new(name, desc, table)
    ---@type Crotocol.enum_t
    local a = {}
    a.Name  = name
    a.Desc  = desc or ""
    ---@type table<number, Crotocol.enumElm_t>
    a.Table = table or {}
    return a
end

return enum_t
