local class = require("Class.middleclass")

local TBL = DEPS.Sallo.Tabullet

local THIS = PKGS.Sallo
local sallo_protocol = THIS.Web.Protocol

---@class Sallo.App.Scene.InfoMenu : Tabullet.UIScene
---@field Layout Sallo.App.Layout.InfoMenu
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Sallo.App, UILayout:Tabullet.UILayout):Sallo.App.Scene.InfoMenu
local SCENE = class("Sallo.App.Scene.InfoMenu", TBL.UIScene)

---constructor
---@param ProjNamespace Sallo.App
---@param UILayout Sallo.App.Layout.InfoMenu
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            if self.currLayoutMode == self.Layout.eMode.OWNER then
                self:goto_Addons()
            elseif self.currLayoutMode == self.Layout.eMode.VIEWER then
                self:goto_Inspector()
            end
        end
    end

    self.Layout.bt_menu.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            ---@cast obj Tabullet.Button
            self:menu_control(not obj.IsButtonPressed)
        end
    end

    self.Layout.bt_trasferInfo.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_TransferAccount()
        end
    end

    self.Layout.bts_menu.Inspector.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Inspector()
        end
    end

    self.Layout.bts_menu.LeaderBoard.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Leaderboard()
        end
    end

    self.Layout.bts_menu.Thema.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_ChangeThema()
        end
    end

    self.Layout.bts_menu.Wallet.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_ConnectAccount()
        end
    end

    self.Layout.bt_skill.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Skill()
        end
    end

    self.Layout.bt_store.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Store()
        end
    end

    self.Layout.bt_refresh.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:refresh_info_fromServer(nil)
        end
    end

    self.Layout.bt_left_arrow.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self.Layout:scrollMenu_left(self.currInfo)
        end
    end

    self.Layout.bt_right_arrow.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self.Layout:scrollMenu_right(self.currInfo)
        end
    end

    self.currInfo = nil
    self.currLayoutMode = nil

    self.__refreshTimerID = nil
    self.__autoRefreshDuration = 30 -- sec
end

function SCENE:goto_Addons()
    self:detach_handelers()
    self.PROJ.Scene.Addons:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Addons)
end

function SCENE:goto_TransferAccount()
    self:detach_handelers()
    if self.currLayoutMode == self.Layout.eMode.OWNER then
        self.PROJ.Sallo.Data.CurrentInfo = self.currInfo
    end
    self.PROJ.Sallo.Scene.TransferAccount:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.TransferAccount)
end

function SCENE:goto_ConnectAccount()
    self:detach_handelers()
    if self.currLayoutMode == self.Layout.eMode.OWNER then
        self.PROJ.Sallo.Data.CurrentInfo = self.currInfo
    end
    self.PROJ.Sallo.Scene.ConnectAccount:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.ConnectAccount)
end

function SCENE:goto_Store()
    self:detach_handelers()
    if self.currLayoutMode == self.Layout.eMode.OWNER then
        self.PROJ.Sallo.Data.CurrentInfo = self.currInfo
    end
    self.PROJ.Sallo.Scene.Store:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.Store)
end

function SCENE:goto_Skill()
    self:detach_handelers()
    if self.currLayoutMode == self.Layout.eMode.OWNER then
        self.PROJ.Sallo.Data.CurrentInfo = self.currInfo
    end
    self.PROJ.Sallo.Scene.Skill:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.Skill)
end

function SCENE:goto_Inspector()
    self:detach_handelers()
    self.PROJ.Sallo.Scene.Inspector:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.Inspector)
end

function SCENE:goto_ChangeThema()
    self:detach_handelers()
    if self.currLayoutMode == self.Layout.eMode.OWNER then
        self.PROJ.Sallo.Data.CurrentInfo = self.currInfo
    end
    self.PROJ.Sallo.Scene.ChangeThema:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.ChangeThema)
end

function SCENE:goto_Leaderboard()
    self:detach_handelers()
    if self.currLayoutMode == self.Layout.eMode.OWNER then
        self.PROJ.Sallo.Data.currMenu = self.currLayoutMode
    end
    self.PROJ.Sallo.Scene.Leaderboard:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.Leaderboard)
end

function SCENE:menu_control(bool)
    for k, v in pairs(self.Layout.bts_menu) do
        v.Visible = bool
    end
end

function SCENE:start_refresh_thread()
    self.PROJ.EventRouter:attachEventCallback("timer", function(a, b, c, d)
        if a == "timer" and b == self.__refreshTimerID then
            self:refresh_info_fromServer(nil)
            self.__refreshTimerID = os.startTimer(self.__autoRefreshDuration)
        end
    end)
    self.__refreshTimerID = os.startTimer(self.__autoRefreshDuration)
end

function SCENE:remove_refresh_thread()
    self.PROJ.EventRouter:removeEventCallback("timer")
    os.cancelTimer(self.__refreshTimerID)
end

--- a function must use before do reset
---@param info_t Sallo.Web.Protocol.Struct.info_t
function SCENE:reset_before(info_t)
    self.currInfo = info_t
end

function SCENE:reset()
    self.Layout.tb_info:setText("Welcome Back! " .. self.currInfo.Name)
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
    self.Layout.bt_menu.IsButtonPressed = false
    self:menu_control(false)
    self.Layout:setMode(self.Layout.eMode.OWNER)
    self.currLayoutMode = self.Layout.eMode.OWNER
    self:refresh_info_fromServer(self.Layout.eMenu.stat)
    self:start_refresh_thread()

    -- if self.PROJ.Sallo.Data.CurrentInfo == nil then
    --     error("current sallo info struct is null!")
    -- end

end

function SCENE:reset_after_VIEWERmode()
    self.Layout:setMode(self.Layout.eMode.VIEWER)
    self.currLayoutMode = self.Layout.eMode.VIEWER
    self.Layout:select_menu(self.Layout.eMenu.stat, self.currInfo)
end

---refresh info from server
---@param targetMenu Sallo.App.Scene.InfoMenu.eMenu|nil if nil, use previous menu target
function SCENE:refresh_info_fromServer(targetMenu)
    self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_GET_INFO, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO
        if msgstruct.Success == false then
            self.Layout.tb_info:setText(sallo_protocol.Enum_INV.ACK_GET_INFO_R_INV[msgstruct.State])
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
            self.Layout:select_menu(self.Layout.eMenu.NONE, nil)
        else
            -- self.PROJ.Sallo.Data.CurrentInfo = msgstruct.Info
            self.currInfo = msgstruct.Info
            if (self.currLayoutMode == self.Layout.eMode.OWNER) then
                self.PROJ.Sallo.Data.CurrentInfo = msgstruct.Info
            end

            self.Layout:refresh_info(self.currInfo)
            local target = targetMenu or self.Layout.currMenu
            self.Layout:select_menu(target, self.currInfo)
        end
        self.PROJ.UIRunner:ReDrawAll()
    end)
    self.PROJ.Sallo.Client:send_GET_INFO(self.currInfo.Name)
end

function SCENE:detach_handelers()
    self:remove_refresh_thread()
    self.PROJ.Handle:clearAllMsgHandle()
    self.PROJ.Sallo.Handle:clearAllMsgHandle()
end

return SCENE
