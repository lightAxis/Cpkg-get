---@class Sallo.Param.Rank
local a = {
&[for k,rank in pairs(ranks) do]&
    [&{rank.rank_name}&] = {
        &[for k,v in pairs(rank) do]&
        ["&{k}&"] = &{v}&,
        &[end]&
    },
&[end]&
}
return a