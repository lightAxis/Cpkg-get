---@enum Sallo.Web.Protocol.Header
local a = {
    ["NONE"] = -1,
    ["ACK_REGISTER_INFO"] = 0, -- reply of REGISTER_INFO
    ["BUY_THEMA"] = 1, -- buy skill from account
    ["ACK_GET_INFOS"] = 2, -- reply of GET_INFOS
    ["CHANGE_SKILL_STAT"] = 3, -- send reserve skillpoint reset to server
    ["GET_LEADERBOARD_INFOS"] = 4, -- request leaderboard info to server
    ["ACK_CHANGE_SKILL_STAT"] = 5, -- reply msg of RESETVE_SKILLPT_RESET
    ["ACK_SET_INFO_CONNECTED_ACCOUNT"] = 6, -- reply of SET_INFO_CONNECTED_ACCOUNT
    ["ACK_GET_LEADERBOARD_INFOS"] = 7, -- reply of GET_LEADERBOARD_INFOS
    ["BUY_RANK"] = 8, -- buy skill from account
    ["ACK_CHANGE_THEMA"] = 9, -- reply of CHANGE_THEMA
    ["CHANGE_THEMA"] = 10, -- request change thema for info
    ["GET_INFOS"] = 11, -- give back info list
    ["SET_INFO_CONNECTED_ACCOUNT"] = 12, -- set connection between sallo info and golkin account
    ["REGISTER_INFO"] = 13, -- register new info with passwd
    ["ACK_GET_INFO"] = 14, -- reply msg of GET_INFO
    ["ACK_BUY_THEMA"] = 15, -- reply msg of BUY_THEMA
    ["GET_INFO"] = 16, -- give back info_t of sallo
    ["ACK_BUY_RANK"] = 17, -- reply msg of BUY_RANK
}

---@class Sallo.Web.Protocol.MsgStruct.IMsgStruct

return a
