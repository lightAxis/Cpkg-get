---@class &{Builder.Name}&.Enum_INV
local a = {}

&[for k,Enum in pairs(Builder.Enums) do]&
---&{Enum.Desc}&
---@enum &{Builder:__makeEnumClassName(Enum.Name)}&_INV 
a.&{Enum.Name}&_INV = {
    &[for kk,EnumElm in pairs(Enum.Table) do]&
    [&{EnumElm.Value}&] = "&{EnumElm.Key}&", -- &{EnumElm.Desc}&
    &[end]&
}

&[end]&

return a