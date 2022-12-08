---@class Sallo.Web.Protocol.MsgStruct.BUY_RANK : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field OwnerName string owner name of info and account
---@field InfoPasswd string info password
---@field AccountPasswd string passwd of account to send send
---@field Rank Sallo.Web.Protocol.Enum.RANK_NAME rank to buy
---@field new fun():Sallo.Web.Protocol.MsgStruct.BUY_RANK
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.BUY_RANK
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.BUY_RANK
    local a = {}

    ---@type string
    a.OwnerName = nil -- owner name of info and account
    
    ---@type string
    a.InfoPasswd = nil -- info password
    
    ---@type string
    a.AccountPasswd = nil -- passwd of account to send send
    
    ---@type Sallo.Web.Protocol.Enum.RANK_NAME
    a.Rank = -1 -- rank to buy
    
    return a
end

return struct 
