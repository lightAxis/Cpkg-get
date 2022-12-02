---@class &{className}&
local a = {
&[for k,rank in pairs(ranks) do]&
    [&{rank.key}&] = {
        &[for k,v in pairs(rank.content) do]&
        ["&{k}&"] = &{v}&,
        &[end]&
    },
&[end]&
}
return a