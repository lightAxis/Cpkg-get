local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Layout.Addons : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.Addons
local SCENE_L = class("Golkin.App.Layout.Addons", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Golkin.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    --- main grid
    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "*", "1", "*", "1", "*" })
    grid:setVerticalSetting({ "1", "1", "*", "3" })
    grid:updatePosLen()
    self.grid = grid

    --- title block
    local title_textblock = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "title_textblock")
    grid:setPosLen(title_textblock, 1, 1, 5, 1)
    title_textblock:setText("Addons")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("Select app")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    self:make_grid_addons(grid)

    self.__addon_count = 0;
end

---comment
---@param grid_p Tabullet.Grid
function SCENE_L:make_grid_addons(grid_p)
    local grid_addon_bts = grid_p:genSubGrid(nil, 1, 3, 5, 1)
    grid_addon_bts:setHorizontalSetting({ "1", "*", "1", "*", "1", "*", "1" })
    grid_addon_bts:setVerticalSetting({ "1", "3", "1", "3", "1", "3", "*" })
    grid_addon_bts:updatePosLen()
    self.grid_addon_bts = grid_addon_bts
end

---comment
---@param button Tabullet.Button
---@param pressFunc fun(self:Golkin.App.Layout.Addons)
function SCENE_L:add_addon_bt(button, pressFunc)
    local x = self.__addon_count % 3
    local y = math.floor(self.__addon_count / 3)
    self.grid_addon_bts:setPosLen(button, x + 1 + 1, y + 1 + 1)
    button.ClickEvent = function(obj, e)
        if (e.Button == TBL.Enums.MouseButton.left) then
            pressFunc(self)
        end
    end
    self.__addon_count = self.__addon_count + 1
end

return SCENE_L
