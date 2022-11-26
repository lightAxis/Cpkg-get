---@class Golkin.App.Data
local a = {}

---@type Golkin.Web.Protocol.Struct.Owner_t
a.CurrentOwner = nil

---@type Golkin.Web.Protocol.Struct.Account_t
a.CurrentAccount = nil

---@type table<number, string>
a.AccountNames = {}

---@type table<number, Golkin.Web.Protocol.Struct.Account_t>
a.AccountInfos = {}

return a
