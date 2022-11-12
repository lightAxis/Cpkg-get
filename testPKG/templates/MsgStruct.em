---@class &{Builder:__makeHeaderClassName(MsgStruct.Name)}& : &{Builder:__makeHeaderClassName("IMsgStruct")}&
&[for k,field in pairs(MsgStruct.Fields) do]&
---@field &{field.Name}& &{field.Type}& &{field.Desc}&
&[end]&
---@field new fun():&{Builder:__makeHeaderClassName(MsgStruct.Name)}&
local struct = {}

---constructor
---@return &{Builder:__makeHeaderClassName(MsgStruct.Name)}&
function struct.new()
    ---@type &{Builder:__makeHeaderClassName(MsgStruct.Name)}&
    local a = {}

    &[for k, field in pairs(MsgStruct.Fields) do]&
    ---@type &{field.Type}&
    a.&{field.Name}& = &{field.Init}& -- &{field.Desc}&
    
    &[end]&
    return a
end

return struct 