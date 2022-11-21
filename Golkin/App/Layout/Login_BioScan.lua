local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local AppLib = DEPS.Golkin.AppLib

---@class Golkin.App.Layout.Login_BioScan : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.Login_BioScan
local SCENE_L = class("Golkin.App.Layout.Login_BioScan", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Golkin.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "*", "1", "*" })
    grid:setVerticalSetting({ "1", "1", "*", "3", "*", "3" })
    grid:updatePosLen()

    --- title block
    local title_textblock = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "title_textblock")
    title_textblock.PosRel, title_textblock.Len = grid:getPosLenWithMargin(1, 1, 3, 1)
    title_textblock:setText("Sign In - BioScan")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    info_tb.PosRel, info_tb.Len = grid:getPosLen(1, 2, 3, 1)
    info_tb:setText("Click Player Detection to Sign In!")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- player name block
    local playerName_textblock = TBL.TextBlock:new(self.rootScreenCanvas,
        self.attachingScreen,
        "player_textblock")
    playerName_textblock.PosRel, playerName_textblock.Len =
    grid:getPosLenWithMargin(1, 4, 3, 1, 5, 5, 0, 0)
    self.PROJ.Style.TB.ListTitle(playerName_textblock)
    self.tb_playerName = playerName_textblock

    --- autenticate button
    local auth_bt = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "auth_bt")
    auth_bt.PosRel, auth_bt.Len = grid:getPosLenWithMargin(3, 6, 1, 1)
    auth_bt:setText("Login!")
    self.PROJ.Style.BT.func(auth_bt)
    self.bt_auth = auth_bt

    --- back button
    local back_bt = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "back_bt")
    back_bt.PosRel, back_bt.Len = grid:getPosLenWithMargin(1, 6, 1, 1)
    back_bt:setText("back")
    self.PROJ.Style.BT.Back(back_bt)
    self.bt_back = back_bt

end

return SCENE_L
