local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Scene.Histories : Tabullet.UIScene
---@field Layout Golkin.App.Layout.Histories
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.Histories
local SCENE = class("Golkin.App.Scene.Histories", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.Histories
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.lb_info_history:setItemTemplate(function(obj)
        ---@cast obj Golkin.Web.Protocol.Struct.History_t
        return obj.Name .. "/" .. tostring(obj.InOut)
    end)
    self.Layout.lb_info_history.SelectedIndexChanged = function(obj)
        ---@cast obj Tabullet.ListBoxItem
        ---@type Golkin.Web.Protocol.Struct.History_t
        local history = obj.obj
        self:display_History(history)
    end

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_OwnerMenu()
        end
    end

    self.Layout.bt_history_scroll_up.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:history_scroll(-1)
        end
    end
    self.Layout.bt_history_scroll_down.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:history_scroll(1)
        end
    end

    ---@type Golkin.Web.Protocol.Struct.Account_t
    self.currentAccount = nil

end

function SCENE:goto_OwnerMenu()
    self:dettachHandelers()
    self.PROJ.Scene.OwnerMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
end

---comment
---@param History Golkin.Web.Protocol.Struct.History_t
function SCENE:display_History(History)
    self:display_history_turnONOff(true)
    self.Layout.tbs_history_viewtable.BalanceLeft:setText(self.PROJ.Style.STR.Balance(tostring(History.BalanceLeft)))
    self.Layout.tbs_history_viewtable.DateTime:setText(History.Daytime.Realtime)
    self.Layout.tbs_history_viewtable.InOut:setText(self.PROJ.Style.STR.Balance(tostring(History.InOut)))
    self.Layout.tbs_history_viewtable.Name:setText(History.Name)
end

---comment
---@param dir number -1 or 1
function SCENE:history_scroll(dir)
    self.Layout.lb_info_history:setScroll(self.Layout.lb_info_history:getScroll() + dir)
end

function SCENE:display_history_turnONOff(bool)
    for k, v in pairs(self.Layout.tbs_history_viewtable) do
        v.Visible = bool
    end
    for k, v in pairs(self.Layout.tbs_history_viewtableN) do
        v.Visible = bool
    end
end

---comment
function SCENE:reset()
    self.Layout.tb_title:setText("Histories of : " .. self.currentAccount.Name)
    self.Layout.lb_info_history:setItemSource(self.currentAccount.Histories)
    self.Layout.lb_info_history:Refresh()
    self:display_history_turnONOff(false)
end

function SCENE:dettachHandelers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
