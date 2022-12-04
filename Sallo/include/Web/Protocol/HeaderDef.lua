---@enum Sallo.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["ACK_GET_INFO"] = 0, -- reply msg of GET_INFO
    ["ACK_RESERVE_SKILLPT_RESET"] = 1, -- reply msg of RESETVE_SKILLPT_RESET
    ["RESERVE_SKILLPT_RESET"] = 2, -- send reserve skillpoint reset to server
    ["GET_INFO"] = 3, -- give back info_t of sallo
}

---@class Sallo.Web.Protocol.MsgStruct.IMsgStruct

return a
