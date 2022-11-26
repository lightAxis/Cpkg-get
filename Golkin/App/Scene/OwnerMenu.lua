local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.OwnerMenu : Tabullet.UIScene
---@field Layout Golkin.App.Layout.OwnerMenu
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.OwnerMenu
local SCENE = class("Golkin.App.Scene.OwnerMenu", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.OwnerMenu
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Cover()
        end
    end

    self.Layout.bt_menu.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            ---@cast obj Tabullet.Button
            self:menu_control(not obj.IsButtonPressed)
        end
    end

    self.Layout.bts_menu.Register.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_RegisterAccount()
        end
    end

    self.Layout.bts_menu.Remove.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            if (self.__selectedAccount ~= nil) then
                self:goto_RemoveAccount()
            end
        end
    end

    self.Layout.bts_menu.Send.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            if (self.__selectedAccount ~= nil) then
                self:goto_SendMoney()
            end
        end
    end

    self.Layout.bt_sendMoney.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            if (self.__selectedAccount ~= nil) then
                self:goto_SendMoney()
            end
        end
    end

    self.Layout.bt_refresh.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:send_owner_account_list_request()
        end
    end

    self.Layout.bt_left_arrow.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_left_arrow()
        end
    end

    self.Layout.bt_right_arrow.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_right_arrow()
        end
    end

    self.Layout.bts_menu.Inquire.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Histories()
        end
    end
    self.Layout.bt_see_histories.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Histories()
        end
    end

    self.__selectedAccountName = ""
    self.__selectedAccountIndex = -1
    self.__selectedAccount = nil
end

function SCENE:goto_Cover()
    self:detachHandlers()
    self.PROJ.Scene.Cover:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Cover)
end

function SCENE:goto_RegisterAccount()
    self:detachHandlers()
    self.PROJ.Scene.RegisterAccount:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.RegisterAccount)
end

function SCENE:goto_RemoveAccount()
    self:detachHandlers()
    self.PROJ.Scene.RemoveAccount.SelectedAccountBalance = self.__selectedAccount.Balance
    self.PROJ.Scene.RemoveAccount.SelectedAccountName = self.__selectedAccountName
    self.PROJ.Scene.RemoveAccount:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.RemoveAccount)
end

function SCENE:goto_SendMoney()
    self:detachHandlers()
    self.PROJ.Scene.SendMoney.currentAccount = self.__selectedAccount
    self.PROJ.Scene.SendMoney:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.SendMoney)
end

function SCENE:goto_Histories()
    self:detachHandlers()
    self.PROJ.Scene.Histories.currentAccount = self.__selectedAccount
    self.PROJ.Scene.Histories:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Histories)
end

function SCENE:cb_bt_left_arrow()
    self.__selectedAccountIndex, self.__selectedAccount, self.__selectedAccountName = self:get_scroll_account(-1)
    self:refresh_mainframe()
end

function SCENE:cb_bt_right_arrow()
    self.__selectedAccountIndex, self.__selectedAccount, self.__selectedAccountName = self:get_scroll_account(1)
    self:refresh_mainframe()
end

---comment
---@param dir number
---@return number newIndex
---@return Golkin.Web.Protocol.Struct.Account_t|nil newAccount
---@return string newAccountName
function SCENE:get_scroll_account(dir)
    local newIndex = self.__selectedAccountIndex + dir
    local newAccount = self.PROJ.Data.AccountInfos[newIndex]
    if newAccount == nil then
        return -1, nil, ""
    else
        return newIndex, newAccount, newAccount.Name
    end
end

function SCENE:menu_control(bool)
    for k, v in pairs(self.Layout.bts_menu) do
        v.Visible = bool
    end
end

function SCENE:refresh_mainframe()
    --- check is account infos exist
    if #(self.PROJ.Data.AccountInfos) <= 0 then
        self.__selectedAccount = nil
        self.__selectedAccountIndex = -1
        self.__selectedAccountName = ""
    else
        -- check account index is -1
        -- index -1 means auto
        if (self.__selectedAccountIndex == -1) then
            self.__selectedAccount = self.PROJ.Data.AccountInfos[1]
            self.__selectedAccountIndex = 1
            self.__selectedAccountName = self.__selectedAccount.Name
        else
            -- find previous account and change index to it
            local account_found = nil
            local account_index = -1
            for i = 1, #(self.PROJ.Data.AccountInfos), 1 do
                if self.PROJ.Data.AccountInfos[i].Name == self.__selectedAccountName then
                    account_found = self.PROJ.Data.AccountInfos[i]
                    account_index = i
                    break
                end
            end
            -- if account removed, snap to first account
            if account_found == nil then
                self.__selectedAccount = self.PROJ.Data.AccountInfos[1]
                self.__selectedAccountIndex = 1
                self.__selectedAccountName = self.__selectedAccount.Name
            else
                self.__selectedAccount = account_found
                self.__selectedAccountIndex = account_index
                self.__selectedAccountName = account_found.Name
            end
        end
    end

    self:show_Account(self.__selectedAccount, self.__selectedAccountIndex, #(self.PROJ.Data.AccountInfos))
end

---comment
---@param account Golkin.Web.Protocol.Struct.Account_t|nil
---@param currentIndex number
---@param totalLen number
function SCENE:show_Account(account, currentIndex, totalLen)
    if account ~= nil then

        self.Layout.tb_mainframeName:setText(account.Name)
        self.Layout.grid_mainframe_name:setHorizontalSetting({ "*", tostring(#account.Name + 2), "*" })
        self.Layout.grid_mainframe_name:updatePosLen()
        self.Layout.grid_mainframe_name:setPosLen(self.Layout.tb_mainframeName, 2, 1)


        self.Layout.tb_mainframe_balanceC:setText(self.PROJ.Style.STR.Balance(tostring(account.Balance)))
        self.Layout.tb_mainframe_ownerC:setText(account.Owner)
        self.Layout.tb_mainframe_dateC:setText(account.Daytime.Realtime)
        self.Layout.lb_mainframe_historyC:setItemSource(account.Histories)
        self.Layout.lb_mainframe_historyC:Refresh()

        self:turn_onoff_accountInfoPanels(true)
        if currentIndex <= 1 then
            self.Layout.bt_left_arrow.Visible = false
        else
            self.Layout.bt_left_arrow.Visible = true
        end
        if currentIndex >= totalLen then
            self.Layout.bt_right_arrow.Visible = false
        else
            self.Layout.bt_right_arrow.Visible = true
        end
    else
        self:turn_onoff_accountInfoPanels(false)
    end
end

---comment
---@param bool boolean
function SCENE:turn_onoff_accountInfoPanels(bool)
    local uis = self.Layout:getAccountContentGroups()

    for k, v in pairs(uis) do
        v.Visible = bool
    end
end

function SCENE:send_owner_account_list_request()
    self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_GET_OWNER_ACCOUNTS, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS
        self:cb_ack_owner_accounts(msg, msgstruct)
    end)
    self.PROJ.Client:send_GET_OWNER_ACCOUNT(self.PROJ.Data.CurrentOwner.Name)
end

---comment
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNER_ACCOUNTS
function SCENE:cb_ack_owner_accounts(msg, msgstruct)
    local replyEnum = protocol.Enum.ACK_GET_OWNER_ACCOUNTS_R
    if msgstruct.Success == false then
        if msgstruct.State == replyEnum.NO_ACCOUNTS then
            self.Layout.tb_info:setText("NO_ACCOUNTS")
        else
            self.Layout.tb_info:setText("UNKNOWN_ERROR:" .. msgstruct.State)
        end
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
        self.__selectedAccountIndex = -1
        self.PROJ.Data.AccountInfos = {}
        self.PROJ.Data.AccountNames = {}
    else
        self.PROJ.Data.AccountInfos = msgstruct.Accounts
        self.PROJ.Data.AccountNames = {}
        for k, v in pairs(msgstruct.Accounts) do
            table.insert(self.PROJ.Data.AccountNames, v.Name)
        end
    end
    self:refresh_mainframe()
    self.PROJ.UIRunner:ReDrawAll()
end

function SCENE:reset()
    self.Layout.bt_menu.IsButtonPressed = false
    self:menu_control(false)
    self.Layout.tb_title:setText("Owner Menu")
    self.Layout.tb_info:setText("Welcome back, " .. self.PROJ.Data.CurrentOwner.Name)
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
    self.Layout.lb_mainframe_historyC:setItemSource({})
    self.Layout.lb_mainframe_historyC:setItemTemplate(function(obj)
        ---@cast obj Golkin.Web.Protocol.Struct.History_t
        return obj.Name .. "/" .. tostring(obj.InOut)
    end)
    self:send_owner_account_list_request()
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
