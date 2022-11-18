---@class Golkin.Web.Protocol.Struct.Account_t
---@field Name string name of this account
---@field Owner string owner of this account. must be ingame data
---@field Password string password of account for login, sending money. MD5 hashed
---@field Balance number balance left in this account
---@field Histories table<number, Golkin.Web.Protocol.Struct.History_t> account histories
---@field new fun():Golkin.Web.Protocol.Struct.Account_t
local struct = {}

---constructor
---@return Golkin.Web.Protocol.Struct.Account_t
function struct.new()
    ---@type Golkin.Web.Protocol.Struct.Account_t
    local a = {}

    ---@type string
    a.Name = nil -- name of this account
    
    ---@type string
    a.Owner = nil -- owner of this account. must be ingame data
    
    ---@type string
    a.Password = nil -- password of account for login, sending money. MD5 hashed
    
    ---@type number
    a.Balance = 0 -- balance left in this account
    
    ---@type table<number, Golkin.Web.Protocol.Struct.History_t>
    a.Histories = {} -- account histories
    
    return a
end

return struct 
