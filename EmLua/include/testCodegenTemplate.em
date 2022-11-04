
---@class &{classDef.Name}&
&[for k,v in pairs(classDef.Fields) do]&
---@field &{v.param}& &{v.type}&
&[end]&
local &{classDef.tableName}& = {}

--- constructor
function &{classDef.tableName}&:initialize()
    &[for k,v in pairs(classDef.Fields) do]&
    ---@type &{v.type}&
    self.&{v.param}& = &{v.initValue}&
    &[end]&
end

return &{classDef.tableName}&