---@enum &{Builder.Name}&.Header
local a = {
    ["NONE"] = -1,
&[local val = 0]&
&[for k, header in pairs(Builder.Headers) do]&
    ["&{header.Name}&"] = &{val}&, -- &{header.Desc}&
    &[val = val + 1]&
&[end]&
}

---@class &{Builder:__makeHeaderClassName("IMsgStruct")}&

return a