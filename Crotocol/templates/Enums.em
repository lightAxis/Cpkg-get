---@class &{Builder.Name}&.Enum
local a = {}

&[for k,Enum in pairs(Builder.Enums) do]&
---&{Enum.Desc}&
---@enum &{Builder:__makeEnumClassName(Enum.Name)}& 
a.&{Enum.Name}& = {
    &[for kk,EnumElm in pairs(Enum.Table) do]&
    ["&{EnumElm.Key}&"] = &{EnumElm.Value}&, -- &{EnumElm.Desc}&
    &[end]&
}

&[end]&

return a