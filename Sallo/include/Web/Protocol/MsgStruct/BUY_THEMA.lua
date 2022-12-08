---@class Sallo.Web.Protocol.MsgStruct.BUY_THEMA : Sallo.Web.Protocol.MsgStruct.IMsgStruct
---@field OwnerName string owner name of info and account
---@field InfoPasswd string info password
---@field AccountPasswd string passwd of account to send send
---@field Thema Sallo.Web.Protocol.Enum.THEMA thema to buy
---@field new fun():Sallo.Web.Protocol.MsgStruct.BUY_THEMA
local struct = {}

---constructor
---@return Sallo.Web.Protocol.MsgStruct.BUY_THEMA
function struct.new()
    ---@type Sallo.Web.Protocol.MsgStruct.BUY_THEMA
    local a = {}

    ---@type string
    a.OwnerName = nil -- owner name of info and account
    
    ---@type string
    a.InfoPasswd = nil -- info password
    
    ---@type string
    a.AccountPasswd = nil -- passwd of account to send send
    
    ---@type Sallo.Web.Protocol.Enum.THEMA
    a.Thema = -1 -- thema to buy
    
    return a
end

return struct 
