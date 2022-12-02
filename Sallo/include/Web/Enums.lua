---@class Sallo.Web.Protocol.Enum
local a = {}

---reply enum of ACK_GET_INFO
---@enum Sallo.Web.Protocol.Enum.ACK_GET_INFO_R 
a.ACK_GET_INFO_R = {
    ["NONE"] = -1, -- this is error!
    ["NORMAL"] = 0, -- standard for success or not
    ["INFO_FILE_CORRUPTED"] = -101, -- info file is corrupted
    ["SUCCESS"] = 101, -- success
}

---enum name
---@enum Sallo.Web.Protocol.Enum.RANK_NAME 
a.RANK_NAME = {
    ["NONE"] = -1, -- this is error
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

---thema of sallo
---@enum Sallo.Web.Protocol.Enum.THEMA 
a.THEMA = {
    ["NONE"] = -1, -- this is error
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

---reply enum of ACK_RESERVE_SKILLPT_RESET
---@enum Sallo.Web.Protocol.Enum.ACK_RESERVE_SKILLPT_RESET_R 
a.ACK_RESERVE_SKILLPT_RESET_R = {
    ["NONE"] = -1, -- this is error
    ["NO_OWNER_EXIST"] = -201, -- no owner exist in ownerName
    ["SKILLPT_STATE_CONDITION_UNMET"] = -202, -- skill point state does not make sense
    ["NORMAL"] = 0, -- standard for success
    ["SUCCESS"] = 201, -- success
}


return a
