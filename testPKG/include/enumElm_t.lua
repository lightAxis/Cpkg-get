---@class Crotocol.enumElm_t
---@field Key string
---@field Value number
---@field Desc string
---@field new fun(key:string,value:number, desc?:string):Crotocol.enumElm_t
local enumElm = {}

---constructor
---@param key string
---@param value number
---@param desc? string
---@return Crotocol.enumElm_t
function enumElm.new(key, value, desc)
    local a = {}
    a.Key = key
    a.Value = value
    a.Desc = desc or ""
    return a
end

return enumElm
