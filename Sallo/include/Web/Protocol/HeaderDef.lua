---@enum Sallo.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["ACK_CHANGE_THEMA"] = 0, -- reply of CHANGE_THEMA
    ["CHANGE_THEMA"] = 1, -- request change thema for info
    ["ACK_BUY_THEMA"] = 2, -- reply msg of BUY_THEMA
    ["ACK_REGISTER_INFO"] = 3, -- reply of REGISTER_INFO
    ["ACK_GET_INFO"] = 4, -- reply msg of GET_INFO
    ["BUY_THEMA"] = 5, -- buy skill from account
    ["BUY_RANK"] = 6, -- buy skill from account
    ["GET_INFO"] = 7, -- give back info_t of sallo
    ["ACK_BUY_RANK"] = 8, -- reply msg of BUY_RANK
    ["GET_INFOS"] = 9, -- give back info list
    ["SET_INFO_CONNECTED_ACCOUNT"] = 10, -- set connection between sallo info and golkin account
    ["REGISTER_INFO"] = 11, -- register new info with passwd
    ["CHANGE_SKILL_STAT"] = 12, -- send reserve skillpoint reset to server
    ["ACK_CHANGE_SKILL_STAT"] = 13, -- reply msg of RESETVE_SKILLPT_RESET
    ["ACK_GET_INFOS"] = 14, -- reply of GET_INFOS
    ["ACK_SET_INFO_CONNECTED_ACCOUNT"] = 15, -- reply of SET_INFO_CONNECTED_ACCOUNT
}

---@class Sallo.Web.Protocol.MsgStruct.IMsgStruct

return a
