local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Layout.Cover : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.Cover
local SCENE_L = class("Golkin.App.Layout.Cover", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Golkin.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "*", "22", "*" })
    grid:setVerticalSetting({ "2*", "3", "*", "3", "2*" })
    grid:updatePosLen()

    self.tb_title = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen,
        "tb_title")
    self.tb_title:setText("Welcome to Golkin!")
    grid:setPosLen(self.tb_title, 2, 2, 1, 1)
    self.PROJ.Style.TB.title(self.tb_title)

    self.bt_login = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_login")
    self.bt_login:setText("Login")
    grid:setPosLenMargin(self.bt_login, 2, 4, 1, 1, 4, 4, 0, 0)
    self.PROJ.Style.BT.Good(self.bt_login)
end

return SCENE_L
