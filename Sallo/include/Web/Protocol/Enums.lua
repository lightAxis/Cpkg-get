---@class Sallo.Web.Protocol.Enum
local a = {}

---reply enum of ACK_BUY_SKILL
---@enum Sallo.Web.Protocol.Enum.ACK_BUY_SKILL_R 
a.ACK_BUY_SKILL_R = {
    ["NONE"] = -1, -- this is error!
    ["NO_INFO"] = -601, -- no owner exist in owner names
    ["SALLO_PASSWORD_UNMET"] = -602, -- password of sallo info unmnet
    ["SKILL_UNLOCK_CONDITION_UNMET"] = -603, -- the unlock condition of this skill is unmet
    ["BANKING_REQUEST_TIMEOUT"] = -604, -- banking request timeout
    ["BANKING_ERROR"] = -605, -- when banking error occurs
    ["NORMAL"] = 0, -- standard for success
    ["SUCCESS"] = 601, -- success
}

---enum name
---@enum Sallo.Web.Protocol.Enum.RANK_NAME 
a.RANK_NAME = {
    ["NONE"] = -1, -- this is error
    ["UNRANKED"] = 0, -- level 0
    ["BRONZE"] = 1, -- level 1
    ["SILVER"] = 2, -- level 2
    ["GOLD"] = 3, -- level 3
    ["PLATINUM"] = 4, -- level 4
    ["DIAMOND"] = 5, -- level 5
    ["MASTER"] = 6, -- level 6
    ["GRANDMASTER"] = 7, -- level 7
    ["CHALLENGER"] = 8, -- level 8
    ["MASTERCHALLENGER"] = 9, -- level 9
    ["SELENDIS"] = 10, -- level 10
    ["HONOR"] = 11, -- level 11
    ["RAGE"] = 12, -- level 12
    ["BAHAR"] = 13, -- level 13
    ["ARCANE"] = 14, -- level 14
    ["BLUEHOLE"] = 15, -- level 15
    ["SKULL"] = 16, -- level 16
    ["HALLOFFAME"] = 17, -- level inf
}

---reply enum of ACK_REGISTER_INFO
---@enum Sallo.Web.Protocol.Enum.ACK_REGISTER_INFO_R 
a.ACK_REGISTER_INFO_R = {
    ["NONE"] = -1, -- this is error
    ["INFO_ALREADY_EXISTS"] = -101, -- info file is already exists
    ["NORMAL"] = 0, -- standard for success
    ["SUCCESS"] = 101, -- success
}

---reply enum of ACK_CHANGE_SKILL_STAT
---@enum Sallo.Web.Protocol.Enum.ACK_CHANGE_SKILL_STAT_R 
a.ACK_CHANGE_SKILL_STAT_R = {
    ["NONE"] = -1, -- this is error
    ["NO_OWNER_EXIST"] = -501, -- no owner exist in ownerName
    ["TOTAL_SKILLPT_UNMET"] = -502, -- total skillpoint in larger than current info
    ["SKILL_UNLOCK_CONDITION_UNMET"] = -503, -- skill unlock state does not make sense
    ["NORMAL"] = 0, -- standard for success
    ["SUCCESS"] = 501, -- success
}

---reply enum of ACK_BUY_THEMA
---@enum Sallo.Web.Protocol.Enum.ACK_BUY_THEMA_R 
a.ACK_BUY_THEMA_R = {
    ["NONE"] = -1, -- this is error!
    ["NO_INFO"] = -701, -- no owner exist in owner names
    ["SALLO_PASSWORD_UNMET"] = -702, -- password of sallo info unmnet
    ["THEMA_UNLOCK_CONDITION_UNMET"] = -703, -- the unlock condition of this thema is unmet
    ["BANKING_REQUEST_TIMEOUT"] = -704, -- banking request timeout
    ["BANKING_ERROR"] = -705, -- when banking error occurs
    ["NORMAL"] = 0, -- standard for success
    ["SUCCESS"] = 701, -- success
}

---reply enum of ACK_GET_INFO
---@enum Sallo.Web.Protocol.Enum.ACK_GET_INFO_R 
a.ACK_GET_INFO_R = {
    ["NONE"] = -1, -- this is error!
    ["NORMAL"] = 0, -- standard for success or not
    ["INFO_NOT_EXIST"] = -301, -- info file is corrupted
    ["SUCCESS"] = 301, -- success
}

---thema of sallo
---@enum Sallo.Web.Protocol.Enum.THEMA 
a.THEMA = {
    ["NONE"] = -1, -- this is error
    ["NO_THEMA"] = 0, -- no thema
    ["LESS_THAN_WORM"] = 1, -- level 1, brown
    ["QUICKSILVER"] = 2, -- level 2, gray
    ["GOLDILOCKS_ZONE"] = 3, -- level 3 yellow
    ["PLATINA_DISCO"] = 4, -- level 4, green
    ["DIAMOND_FOR_EVER"] = 5, -- level 5 cyan
    ["MASTERPIECE"] = 6, -- level 6 lime
    ["GRAND_MOMS_TOUCH"] = 7, -- level 7 yellow red 
    ["CHALLENGER_DEEP"] = 8, -- level 8 dark, blue
    ["MONSTER_CHALLANGE"] = 9, -- level 9 purple
    ["ARTANIS"] = 10, -- level 10 white
    ["HONOR_OF_MANKIND"] = 11, -- level 11 light gray
    ["OUTRAGED_JELLYBIN"] = 12, -- level 12 pink
    ["BA(NJU)HAR(A)"] = 13, -- level 13 magenta
    ["THE_ONYX_NIGHT_SKY"] = 14, -- level 14 light orange
    ["EYE_OF_EVENT_HORIZON"] = 15, -- level 15 purple, yellow
    ["PETROLLIC_REPUBLIC"] = 16, -- level 16 black
    ["HALLOFFAME"] = 17, -- level inf
    ["BACK_TO_NORMAL"] = 18, -- level 0 normal
}

---reply enum of ACK_SET_INFO_CONNECTED_ACCOUNT
---@enum Sallo.Web.Protocol.Enum.ACK_SET_INFO_CONNECTED_ACCOUNT_R 
a.ACK_SET_INFO_CONNECTED_ACCOUNT_R = {
    ["NONE"] = -1, -- this is error
    ["INFO_NOT_EXIST"] = -201, -- info not exist in sallo server
    ["INFO_PASSWD_UNMET"] = -202, -- info password is not matching
    ["ACCOUNT_NOT_EXIST"] = -203, -- account not exist in golkin server
    ["ACCOUNT_OWNER_UNMET"] = -204, -- account owner in unmet in  golkin server
    ["ACCOUNT_PASSWD_UNMET"] = -205, -- account password in unmnet in golkin server
    ["BANKING_REQUEST_TIMEOUT"] = -206, -- timeout for banking request
    ["NORMAL"] = 0, -- standard for success
    ["SUCCESS"] = 201, -- success
}

---reply enum of ACK_GET_INFOS
---@enum Sallo.Web.Protocol.Enum.ACK_GET_INFOS_R 
a.ACK_GET_INFOS_R = {
    ["NONE"] = -1, -- this is error!
    ["NO_INFO_EXIST"] = -401, -- no info is registered in server
    ["NORMAL"] = 0, -- standard for success or not
    ["SUCCESS"] = 401, -- success
}


return a
