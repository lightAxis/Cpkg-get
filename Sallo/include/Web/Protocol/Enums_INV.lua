---@class Sallo.Web.Protocol.Enum_INV
local a = {}

---reply enum of ACK_BUY_THEMA
---@enum Sallo.Web.Protocol.Enum.ACK_BUY_THEMA_R_INV 
a.ACK_BUY_THEMA_R_INV = {
    [-1] = "NONE", -- this is error!
    [-701] = "NO_INFO", -- no owner exist in owner names
    [-702] = "SALLO_PASSWORD_UNMET", -- password of sallo info unmnet
    [-703] = "THEMA_ALREADY_EXIST", -- thema already exist in item
    [-704] = "THEMA_UNLOCK_CONDITION_UNMET", -- the unlock condition of this thema is unmet
    [-705] = "NO_CONNECTED_ACCOUNT", -- no connected account to pay
    [-706] = "BANKING_REQUEST_TIMEOUT", -- banking request timeout
    [-707] = "BANKING_ERROR", -- when banking error occurs
    [0] = "NORMAL", -- standard for success
    [701] = "SUCCESS", -- success
}

---reply enum of ACK_GET_LEADERBOARD_INFOS
---@enum Sallo.Web.Protocol.Enum.ACK_GET_LEADERBOARD_INFOS_R_INV 
a.ACK_GET_LEADERBOARD_INFOS_R_INV = {
    [-1] = "NONE", -- this is error
    [-901] = "NO_INFO", -- no info left in server
    [0] = "NORMAL", -- standard for success
    [901] = "SUCCESS", -- success
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
    [17] = "INFINITY", -- level inf
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
    [17] = "NEWBIE", -- level inf
}

---reply enum of ACK_GET_INFO
---@enum Sallo.Web.Protocol.Enum.ACK_GET_INFO_R_INV 
a.ACK_GET_INFO_R_INV = {
    [-1] = "NONE", -- this is error!
    [0] = "NORMAL", -- standard for success or not
    [-301] = "INFO_NOT_EXIST", -- info file is corrupted
    [301] = "SUCCESS", -- success
}

---reply enum of ACK_BUY_RANK
---@enum Sallo.Web.Protocol.Enum.ACK_BUY_RANK_R_INV 
a.ACK_BUY_RANK_R_INV = {
    [-1] = "NONE", -- this is error!
    [-601] = "NO_INFO", -- no owner exist in owner names
    [-602] = "SALLO_PASSWORD_UNMET", -- password of sallo info unmnet
    [-603] = "RANK_ALREADY_EXIST", -- rank already bought
    [-604] = "RANK_UNLOCK_CONDITION_UNMET", -- the unlock condition of this rank is unmet
    [-605] = "NO_CONNECTED_ACCOUNT", -- no connected account to pay
    [-606] = "BANKING_REQUEST_TIMEOUT", -- banking request timeout
    [-607] = "BANKING_ERROR", -- when banking error occurs
    [0] = "NORMAL", -- standard for success
    [601] = "SUCCESS", -- success
}

---reply enum of ACK_GET_INFOS
---@enum Sallo.Web.Protocol.Enum.ACK_GET_INFOS_R_INV 
a.ACK_GET_INFOS_R_INV = {
    [-1] = "NONE", -- this is error!
    [-401] = "NO_INFO_EXIST", -- no info is registered in server
    [0] = "NORMAL", -- standard for success or not
    [401] = "SUCCESS", -- success
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

---reply enum of ACK_CHANGE_THEMA
---@enum Sallo.Web.Protocol.Enum.ACK_CHANGE_THEMA_R_INV 
a.ACK_CHANGE_THEMA_R_INV = {
    [-1] = "NONE", -- this is error!
    [-801] = "NO_INFO", -- to info exist in owner name
    [-802] = "INFO_PASSWD_UNMET", -- info passwd umnet
    [-803] = "THEMA_NEEDED_TO_BUY", -- no item thema in info
    [0] = "NORMAL", -- standard for success
    [801] = "SUCCESS", -- success
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
    [-207] = "BANKING_ERROR", -- account from banking has error
    [0] = "NORMAL", -- standard for success
    [201] = "SUCCESS", -- success
}

---reply enum of ACK_REGISTER_INFO
---@enum Sallo.Web.Protocol.Enum.ACK_REGISTER_INFO_R_INV 
a.ACK_REGISTER_INFO_R_INV = {
    [-1] = "NONE", -- this is error
    [-101] = "INFO_ALREADY_EXISTS", -- info file is already exists
    [-102] = "BANKING_REQUEST_TIMEOUT", -- timeout error of banking
    [-103] = "BANKING_ERROR", -- error while do banking
    [0] = "NORMAL", -- standard for success
    [101] = "SUCCESS", -- success
}

---enum of item type
---@enum Sallo.Web.Protocol.Enum.ITEM_TYPE_INV 
a.ITEM_TYPE_INV = {
    [-1] = "NONE", -- this is error
    [1] = "THEMA", -- thema item to decorate name in leaderboard
}

---type of skill
---@enum Sallo.Web.Protocol.Enum.SKILLTYPE_INV 
a.SKILLTYPE_INV = {
    [-1] = "NONE", -- this is error!
    [1] = "EFFICIENCY", -- efficiency
    [2] = "PROFICIENCY", -- proficiency
    [3] = "CONCENTRATION", -- concentration
}


return a
