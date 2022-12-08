---@enum Sallo.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["ACK_BUY_THEMA"] = 0, -- reply msg of BUY_THEMA
    ["ACK_REGISTER_INFO"] = 1, -- reply of REGISTER_INFO
    ["ACK_GET_INFO"] = 2, -- reply msg of GET_INFO
    ["BUY_THEMA"] = 3, -- buy skill from account
    ["BUY_RANK"] = 4, -- buy skill from account
    ["GET_INFO"] = 5, -- give back info_t of sallo
    ["ACK_BUY_RANK"] = 6, -- reply msg of BUY_RANK
    ["GET_INFOS"] = 7, -- give back info list
    ["SET_INFO_CONNECTED_ACCOUNT"] = 8, -- set connection between sallo info and golkin account
    ["REGISTER_INFO"] = 9, -- register new info with passwd
    ["CHANGE_SKILL_STAT"] = 10, -- send reserve skillpoint reset to server
    ["ACK_CHANGE_SKILL_STAT"] = 11, -- reply msg of RESETVE_SKILLPT_RESET
    ["ACK_GET_INFOS"] = 12, -- reply of GET_INFOS
    ["ACK_SET_INFO_CONNECTED_ACCOUNT"] = 13, -- reply of SET_INFO_CONNECTED_ACCOUNT
}

---@class Sallo.Web.Protocol.MsgStruct.IMsgStruct

return a
