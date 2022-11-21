local THIS = require("Golkin.pkg_init")

local TBL = DEPS.Golkin.Tabullet

local mon_term = TBL.Screen:new(term, TBL.Enums.Side.NONE)
local temp = {}
temp.Style = require("Golkin.App.Style.Common")
temp.Param = require("Golkin.App.param")

-- local LAYOUT = require("Golkin.App.Layout.Cover"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.Login_BioScan"):new(mon_term, temp)
local LAYOUT = require("Golkin.App.Layout.Login_List"):new(mon_term, temp)

LAYOUT.attachingScreen:clear()
LAYOUT.rootScreenCanvas:render()
LAYOUT.attachingScreen:reflect2Screen()

os.sleep(100000)
