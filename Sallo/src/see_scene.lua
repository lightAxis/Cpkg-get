local THIS = require("Sallo.pkg_init")

local TBL = DEPS.Sallo.Tabullet

local protocol = THIS.Web.Protocol

local mon_term = TBL.Screen:new(term, TBL.Enums.Side.NONE)
-- local mon_term = TBL.Screen:new(peripheral.wrap("left"), TBL.Enums.Side.left)
local temp = {}
temp.Style = require("Golkin.App.Style.Common")
temp.Param = require("Golkin.userdata.param")

-- local LAYOUT = require("Golkin.App.Layout.Cover"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.Login_BioScan"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.Login_List"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.PIN"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.OwnerMenu"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.SendMoney"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.SendMoneyName"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.Histories"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.RegisterAccount"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.RemoveAccount"):new(mon_term, temp)
-- local LAYOUT = require("Golkin.App.Layout.ManualTextInput"):new(mon_term, temp)
local LAYOUT = require("Sallo.App.layout.InfoMenu"):new(mon_term, temp)
LAYOUT.selectedInfo = protocol.Struct.info_t:new()
LAYOUT.selectedInfo.Main.rank = protocol.Enum.RANK_NAME.BRONZE
LAYOUT:select_menu(LAYOUT.eMenu.state)

LAYOUT.attachingScreen:clear()
LAYOUT.rootScreenCanvas:render()
LAYOUT.attachingScreen:reflect2Screen()

os.sleep(100000)
