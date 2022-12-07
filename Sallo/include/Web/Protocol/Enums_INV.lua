---@class Sallo.Web.Protocol.Enum_INV
local a = {}

---reply enum of ACK_BUY_SKILL
---@enum Sallo.Web.Protocol.Enum.ACK_BUY_SKILL_R_INV 
a.ACK_BUY_SKILL_R_INV = {
    [-1] = "NONE", -- this is error!
    [-601] = "NO_INFO", -- no owner exist in owner names
    [-602] = "SALLO_PASSWORD_UNMET", -- password of sallo info unmnet
    [-603] = "SKILL_UNLOCK_CONDITION_UNMET", -- the unlock condition of this skill is unmet
    [-604] = "BANKING_REQUEST_TIMEOUT", -- banking request timeout
    [-605] = "BANKING_ERROR", -- when banking error occurs
    [0] = "NORMAL", -- standard for success
    [601] = "SUCCESS", -- success
}

---enum name
---@enum Sallo.Web.Protocol.Enum.RANK_NAME_INV 
a.RANK_NAME_INV = {
    [-1] = "NONE", -- this is error
    [0] = "UNRANKED", -- level 0
    [1] = "BRONZE", -- level 1
    [2] = "SILVER", -- level 2
    [3] = "GOLD", -- level 3
    [4] = "PLATINUM", -- level 4
    [5] = "DIAMOND", -- level 5
    [6] = "MASTER", -- level 6
    [7] = "GRANDMASTER", -- level 7
    [8] = "CHALLENGER", -- level 8
    [9] = "MASTERCHALLENGER", -- level 9
    [10] = "SELENDIS", -- level 10
    [11] = "HONOR", -- level 11
    [12] = "RAGE", -- level 12
    [13] = "BAHAR", -- level 13
    [14] = "ARCANE", -- level 14
    [15] = "BLUEHOLE", -- level 15
    [16] = "SKULL", -- level 16
    [17] = "HALLOFFAME", -- level inf
}

---reply enum of ACK_REGISTER_INFO
---@enum Sallo.Web.Protocol.Enum.ACK_REGISTER_INFO_R_INV 
a.ACK_REGISTER_INFO_R_INV = {
    [-1] = "NONE", -- this is error
    [-101] = "INFO_ALREADY_EXISTS", -- info file is already exists
    [0] = "NORMAL", -- standard for success
    [101] = "SUCCESS", -- success
}

---reply enum of ACK_CHANGE_SKILL_STAT
---@enum Sallo.Web.Protocol.Enum.ACK_CHANGE_SKILL_STAT_R_INV 
a.ACK_CHANGE_SKILL_STAT_R_INV = {
    [-1] = "NONE", -- this is error
    [-501] = "NO_OWNER_EXIST", -- no owner exist in ownerName
    [-502] = "TOTAL_SKILLPT_UNMET", -- total skillpoint in larger than current info
    [-503] = "SKILL_UNLOCK_CONDITION_UNMET", -- skill unlock state does not make sense
    [0] = "NORMAL", -- standard for success
    [501] = "SUCCESS", -- success
}

---reply enum of ACK_BUY_THEMA
---@enum Sallo.Web.Protocol.Enum.ACK_BUY_THEMA_R_INV 
a.ACK_BUY_THEMA_R_INV = {
    [-1] = "NONE", -- this is error!
    [-701] = "NO_INFO", -- no owner exist in owner names
    [-702] = "SALLO_PASSWORD_UNMET", -- password of sallo info unmnet
    [-703] = "THEMA_UNLOCK_CONDITION_UNMET", -- the unlock condition of this thema is unmet
    [-704] = "BANKING_REQUEST_TIMEOUT", -- banking request timeout
    [-705] = "BANKING_ERROR", -- when banking error occurs
    [0] = "NORMAL", -- standard for success
    [701] = "SUCCESS", -- success
}

---reply enum of ACK_GET_INFO
---@enum Sallo.Web.Protocol.Enum.ACK_GET_INFO_R_INV 
a.ACK_GET_INFO_R_INV = {
    [-1] = "NONE", -- this is error!
    [0] = "NORMAL", -- standard for success or not
    [-301] = "INFO_NOT_EXIST", -- info file is corrupted
    [301] = "SUCCESS", -- success
}

---thema of sallo
---@enum Sallo.Web.Protocol.Enum.THEMA_INV 
a.THEMA_INV = {
    [-1] = "NONE", -- this is error
    [0] = "NO_THEMA", -- no thema
    [1] = "LESS_THAN_WORM", -- level 1, brown
    [2] = "QUICKSILVER", -- level 2, gray
    [3] = "GOLDILOCKS_ZONE", -- level 3 yellow
    [4] = "PLATINA_DISCO", -- level 4, green
    [5] = "DIAMOND_FOR_EVER", -- level 5 cyan
    [6] = "MASTERPIECE", -- level 6 lime
    [7] = "GRAND_MOMS_TOUCH", -- level 7 yellow red 
    [8] = "CHALLENGER_DEEP", -- level 8 dark, blue
    [9] = "MONSTER_CHALLANGE", -- level 9 purple
    [10] = "ARTANIS", -- level 10 white
    [11] = "HONOR_OF_MANKIND", -- level 11 light gray
    [12] = "OUTRAGED_JELLYBIN", -- level 12 pink
    [13] = "BA(NJU)HAR(A)", -- level 13 magenta
    [14] = "THE_ONYX_NIGHT_SKY", -- level 14 light orange
    [15] = "EYE_OF_EVENT_HORIZON", -- level 15 purple, yellow
    [16] = "PETROLLIC_REPUBLIC", -- level 16 black
    [17] = "HALLOFFAME", -- level inf
    [18] = "BACK_TO_NORMAL", -- level 0 normal
}

---reply enum of ACK_SET_INFO_CONNECTED_ACCOUNT
---@enum Sallo.Web.Protocol.Enum.ACK_SET_INFO_CONNECTED_ACCOUNT_R_INV 
a.ACK_SET_INFO_CONNECTED_ACCOUNT_R_INV = {
    [-1] = "NONE", -- this is error
    [-201] = "INFO_NOT_EXIST", -- info not exist in sallo server
    [-202] = "INFO_PASSWD_UNMET", -- info password is not matching
    [-203] = "ACCOUNT_NOT_EXIST", -- account not exist in golkin server
    [-204] = "ACCOUNT_OWNER_UNMET", -- account owner in unmet in  golkin server
    [-205] = "ACCOUNT_PASSWD_UNMET", -- account password in unmnet in golkin server
    [-206] = "BANKING_REQUEST_TIMEOUT", -- timeout for banking request
    [0] = "NORMAL", -- standard for success
    [201] = "SUCCESS", -- success
}

---reply enum of ACK_GET_INFOS
---@enum Sallo.Web.Protocol.Enum.ACK_GET_INFOS_R_INV 
a.ACK_GET_INFOS_R_INV = {
    [-1] = "NONE", -- this is error!
    [-401] = "NO_INFO_EXIST", -- no info is registered in server
    [0] = "NORMAL", -- standard for success or not
    [401] = "SUCCESS", -- success
}


return a
