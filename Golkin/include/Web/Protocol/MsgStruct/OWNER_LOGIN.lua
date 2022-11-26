---@class Golkin.Web.Protocol.MsgStruct.OWNER_LOGIN : Golkin.Web.Protocol.MsgStruct.IMsgStruct
---@field Name string name of the owner
---@field Password string password for login. MD5 hashed
---@field new fun():Golkin.Web.Protocol.MsgStruct.OWNER_LOGIN
local struct = {}

---constructor
---@return Golkin.Web.Protocol.MsgStruct.OWNER_LOGIN
function struct.new()
    ---@type Golkin.Web.Protocol.MsgStruct.OWNER_LOGIN
    local a = {}

    ---@type string
    a.Name = nil -- name of the owner
    
    ---@type string
    a.Password = nil -- password for login. MD5 hashed
    
    return a
end

return struct 
