local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.SendMoney : Tabullet.UIScene
---@field Layout Golkin.App.Layout.SendMoney
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.SendMoney
local SCENE = class("Golkin.App.Scene.SendMoney", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.SendMoney
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_OwnerMenu()
        end
    end

    self.Layout.lb_available_accounts:setItemTemplate(function(obj)
        ---@cast obj string
        return obj
    end)
    self.Layout.lb_available_accounts.SelectedIndexChanged = function(obj)
        ---@type string
        local name = obj.obj
        self.Layout.tb_info_recieveAccC:setText(name)
    end

    for i = 1, 9, 1 do
        self.Layout.bts_numpad[i].ClickEvent = function(obj, e)
            if e.Button == TBL.Enums.MouseButton.left then
                self:cb_numpad_num(i)
            end
        end
    end
    self.Layout.bts_numpad[10].ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_numpad_num(0)
        end
    end
    self.Layout.bt_numpad_backspace.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_numpad_backspace()
        end
    end
    self.Layout.bt_numpad_reset.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_numpad_reset()
        end
    end

    self.Layout.bt_avaialbe_account_scrolUp.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_scroll_up()
        end
    end
    self.Layout.bt_avaialbe_account_scrolDown.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_scroll_down()
        end
    end

    self.Layout.bt_next.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_SendMoneyName()
        end
    end




    ---@type Golkin.Web.Protocol.Struct.Account_t
    self.currentAccount = nil

    self.sendingBalance = "0"
end

function SCENE:goto_OwnerMenu()
    self:detachHandlers()
    self.PROJ.Scene.OwnerMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
end

function SCENE:goto_SendMoneyName()

    if self.sendingBalance == "0" then
        self.Layout.tb_info:setText("Cannot send with 0 balance!")
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    elseif self.Layout.tb_info_recieveAccC:getText() == "" then
        self.Layout.tb_info:setText("Reciever account name is empty!")
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    elseif self.Layout.tb_info_recieveAccC:getText() == self.currentAccount.Name then
        self.Layout.tb_info:setText("Sender & Reciever account name is same!")
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self.Layout.tb_info:setText("Input balance to send & choose reciever")
        self.PROJ.Style.TB.Info(self.Layout.tb_info)

        self:detachHandlers()
        local send_t = protocol.MsgStruct.SEND:new()
        send_t.Balance = tonumber(self.sendingBalance)
        send_t.From = self.currentAccount.Name
        send_t.OwnerName = self.PROJ.Data.CurrentOwner.Name
        send_t.To = self.Layout.tb_info_recieveAccC:getText()
        send_t.FromMsg = send_t.To
        send_t.ToMsg = send_t.From
        self.PROJ.Scene.SendMoneyName.SEND_struct = send_t
        self.PROJ.Scene.SendMoneyName:reset()
        self.PROJ.UIRunner:attachScene(self.PROJ.Scene.SendMoneyName)
    end

end

function SCENE:request_GET_ACCOUNTS()
    self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_GET_ACCOUNTS, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNTS
        self:cb_ack_get_accounts(msg, msgstruct)
    end)

    self.PROJ.Client:send_GET_ACCOUNTS()
end

---comment
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_ACCOUNTS
function SCENE:cb_ack_get_accounts(msg, msgstruct)
    local replyEnum = protocol.Enum.ACK_GET_ACCOUNTS_R
    if msgstruct.Success == false then
        if msgstruct.State == replyEnum.NO_BANK_FILE then
            self.Layout.tb_info:setText("NO_BANK_FILE")
        else
            self.Layout.tb_info:setText("UNKNOWN_ERROR:" .. msgstruct.State)
        end
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self.Layout.lb_available_accounts:setItemSource(msgstruct.AccountsList)
        self.Layout.lb_available_accounts:Refresh()
    end
    self.PROJ.UIRunner:ReDrawAll()
end

---comment
---@param number number
function SCENE:cb_numpad_num(number)
    local numberStr = tostring(number)
    if self.sendingBalance == "0" then
        self.sendingBalance = numberStr
    else
        self.sendingBalance = self.sendingBalance .. numberStr
    end
    self.Layout.tb_info_sendingC:setText(self.PROJ.Style.STR.Balance(self.sendingBalance))
end

function SCENE:cb_numpad_backspace()
    if #self.sendingBalance == 1 and
        self.sendingBalance ~= "0" then
        self.sendingBalance = "0"
    else
        if (self.sendingBalance ~= "0") then
            self.sendingBalance = self.sendingBalance:sub(1, #self.sendingBalance - 1)
        end
    end
    self.Layout.tb_info_sendingC:setText(self.PROJ.Style.STR.Balance(self.sendingBalance))
end

function SCENE:cb_numpad_reset()
    self.sendingBalance = "0"
    self.Layout.tb_info_sendingC:setText(self.PROJ.Style.STR.Balance(self.sendingBalance))
end

function SCENE:cb_scroll_up()
    self.Layout.lb_available_accounts:setScroll(self.Layout.lb_available_accounts:getScroll() - 1)
end

function SCENE:cb_scroll_down()
    self.Layout.lb_available_accounts:setScroll(self.Layout.lb_available_accounts:getScroll() + 1)
end

function SCENE:reset()
    self.Layout.tb_title:setText("Send Money From : " .. self.currentAccount.Name)
    self.Layout.tb_info:setText("input balance to send & choose reciever")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)

    self.Layout.tb_info_sendingC:setText("0")
    self.Layout.tb_info_balanceC:setText(self.PROJ.Style.STR.Balance(tostring(self.currentAccount.Balance)))
    self.Layout.tb_info_recieveAccC:setText("")
    self.sendingBalance = "0"
    self.Layout.lb_available_accounts:setItemSource({})
    self.Layout.lb_available_accounts:Refresh()

    self:request_GET_ACCOUNTS()
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
