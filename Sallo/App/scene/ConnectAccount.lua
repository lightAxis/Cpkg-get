local class = require("Class.middleclass")

local GOLKIN = DEPS.Sallo.Golkin
local golkin_protocol = GOLKIN.Web.Protocol

local THIS = PKGS.Sallo
local sallo_protocol = THIS.Web.Protocol

local TBL = DEPS.Sallo.Tabullet

---@class Sallo.App.Scene.ConnectAccount : Tabullet.UIScene
---@field Layout Sallo.App.Layout.ConnectAccount
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Sallo.App, UILayout:Tabullet.UILayout):Sallo.App.Scene.ConnectAccount
local SCENE = class("Sallo.App.Scene.ConnectAccount", TBL.UIScene)

---constructor
---@param ProjNamespace Sallo.App
---@param UILayout Sallo.App.Layout.ConnectAccount
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.lb_accounts:setItemTemplate(function(obj)
        ---@cast obj Golkin.Web.Protocol.Struct.Account_t
        return obj.Name
    end)

    self.Layout.lb_accounts.SelectedIndexChanged = function(obj)
        ---@type Golkin.Web.Protocol.Struct.Account_t
        local account_t = obj.obj
        self.Layout.tb_sel_accC:setText(account_t.Name)
        self.Layout.bt_buy.Visible = true
    end

    self.Layout.bt_arrow_up.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            local scr = self.Layout.lb_accounts:getScroll()
            self.Layout.lb_accounts:setScroll(scr - 1)
        end
    end

    self.Layout.bt_arrow_down.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            local scr = self.Layout.lb_accounts:getScroll()
            self.Layout.lb_accounts:setScroll(scr + 1)
        end
    end

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_InfoMenu()
        end
    end

    self.Layout.bt_refresh_accounts.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:refresh_account_list()
        end
    end

    self.Layout.bt_buy.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:link_account_PIN()
        end
    end

end

function SCENE:reset()
    self.Layout.tb_info:setText("Select account to connect")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
    self.Layout.tb_prev_accC:setText("")
    self.Layout.tb_sel_accC:setText("")
    self.Layout.bt_buy.Visible = false

    local accountName = self.PROJ.Sallo.Data.CurrentInfo.AccountName
    if accountName ~= nil then
        self.Layout.tb_prev_accC:setText(accountName)
    else
        self.Layout.tb_prev_accC:setText("NO ACCOUNT LINKED")
    end

    self:refresh_account_list()

end

function SCENE:refresh_account_list()
    self.PROJ.Handle:attachMsgHandle(golkin_protocol.Header.ACK_GET_OWNER_ACCOUNTS, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS
        if (msgstruct.Success == false) then
            self.Layout.tb_info:setText(golkin_protocol.Enum_INV.ACK_GET_OWNER_ACCOUNTS_R_INV[msgstruct.State])
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
        else
            self.Layout.lb_accounts:setItemSource(msgstruct.Accounts)
            self.Layout.lb_accounts:Refresh()
        end
        self.PROJ.UIRunner:ReDrawAll()
    end)

    self.PROJ.Client:send_GET_OWNER_ACCOUNT(self.PROJ.Data.CurrentOwner.Name)
end

function SCENE:link_account_PIN()
    local accountName = self.Layout.tb_sel_accC:getText()
    local infoOwner = self.PROJ.Sallo.Data.CurrentInfo.Name
    local infoPasswd = self.PROJ.Data.CurrentOwner.Password
    self.PROJ.Scene.PIN:reset()
    self.PROJ.Scene.PIN:infoStr_normal("Input Passwd Of " .. accountName)
    self.PROJ.Scene.PIN.Event_bt_back = function(PIN)
        PIN:detachHandlers()
        self.PROJ.Sallo.Scene.ConnectAccount:reset()
        self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.ConnectAccount)
    end

    self.PROJ.Scene.PIN.Event_bt_enter = function(PIN)
        self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_SET_INFO_CONNECTED_ACCOUNT,
            function(msg, msgstruct)
                ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_SET_INFO_CONNECTED_ACCOUNT
                if (msgstruct.Success == false) then
                    PIN:infoStr_error(sallo_protocol.Enum_INV.ACK_SET_INFO_CONNECTED_ACCOUNT_R_INV[msgstruct.State])
                else
                    PIN:detachHandlers()
                    self.PROJ.Sallo.Scene.InfoMenu:reset_before(self.PROJ.Sallo.Data.CurrentInfo)
                    self.PROJ.Sallo.Scene.InfoMenu:reset()
                    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
                end
                self.PROJ.UIRunner:ReDrawAll()
            end)

        self.PROJ.Sallo.Client:send_SET_INFO_CONNECTED_ACCOUNT(infoOwner, infoPasswd, accountName,
            infoOwner, PIN.password)
    end

    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)

end

function SCENE:goto_InfoMenu()
    self:detachHandlers()
    self.PROJ.Sallo.Scene.InfoMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
