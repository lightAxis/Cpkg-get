---@class Sallo.Web.Protocol.Struct.item_t
---@field ItemType Sallo.Web.Protocol.Enum.ITEM_TYPE item type enum
---@field ItemIndex number item index, by enum
---@field Name string name of the item
---@field new fun():Sallo.Web.Protocol.Struct.item_t
local struct = {}

---constructor
---@return Sallo.Web.Protocol.Struct.item_t
function struct.new()
    ---@type Sallo.Web.Protocol.Struct.item_t
    local a = {}

    ---@type Sallo.Web.Protocol.Enum.ITEM_TYPE
    a.ItemType = -1 -- item type enum
    
    ---@type number
    a.ItemIndex = nil -- item index, by enum
    
    ---@type string
    a.Name = nil -- name of the item
    
    return a
end

return struct 
