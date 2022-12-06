---@enum Sallo.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["ACK_REGISTER_INFO"] = 0, -- reply of REGISTER_INFO
    ["ACK_GET_INFO"] = 1, -- reply msg of GET_INFO
    ["GET_INFO"] = 2, -- give back info_t of sallo
    ["GET_INFOS"] = 3, -- give back info list
    ["SET_INFO_CONNECTED_ACCOUNT"] = 4, -- set connection between sallo info and golkin account
    ["REGISTER_INFO"] = 5, -- register new info with passwd
    ["CHANGE_SKILL_STAT"] = 6, -- send reserve skillpoint reset to server
    ["ACK_CHANGE_SKILL_STAT"] = 7, -- reply msg of RESETVE_SKILLPT_RESET
    ["ACK_GET_INFOS"] = 8, -- reply of GET_INFOS
    ["ACK_SET_INFO_CONNECTED_ACCOUNT"] = 9, -- reply of SET_INFO_CONNECTED_ACCOUNT
}

---@class Sallo.Web.Protocol.MsgStruct.IMsgStruct

return a
