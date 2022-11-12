---@class &{Builder:__makeStructClassName(Struct.Name)}&
&[for k,field in pairs(Struct.Fields) do]&
---@field &{field.Name}& &{field.Type}& &{field.Desc}&
&[end]&
---@field new fun():&{Builder:__makeStructClassName(Struct.Name)}&
local struct = {}

---constructor
---@return &{Builder:__makeStructClassName(Struct.Name)}&
function struct.new()
    ---@type &{Builder:__makeStructClassName(Struct.Name)}&
    local a = {}

    &[for k, field in pairs(Struct.Fields) do]&
    ---@type &{field.Type}&
    a.&{field.Name}& = &{field.Init}& -- &{field.Desc}&
    
    &[end]&
    return a
end

return struct 