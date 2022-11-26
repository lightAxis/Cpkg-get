local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.PIN : Tabullet.UIScene
---@field Layout Golkin.App.Layout.PIN
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.PIN
local SCENE = class("Golkin.App.Scene.PIN", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.PIN
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    for i = 1, 9, 1 do
        self.Layout.bts_numpad[i].ClickEvent = function(obj, e)
            if e.Button == TBL.Enums.MouseButton.left then
                self:cb_bt_numpad(i)
            end
        end
    end

    self.Layout.bts_numpad[10].ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_numpad(0)
        end
    end

    self.Layout.bt_numpad_backspace.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_backspace()
        end
    end

    self.Layout.bt_numpad_reset.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_numpad_reset()
        end
    end

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_back()
        end
    end

    self.Layout.bt_enter_pin.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_enter_pin()
        end
    end

    self.OwnerName = ""
    self.AccountName = ""
    self.SEND_struct = protocol.MsgStruct.SEND:new()
    self.password = ""
    self.maximumCount = 8

    ---@enum Golkin.App.Scene.Pin.ePrevScene
    self.ePrevScene = {
        ["Bio"] = "Bio",
        ["BioRegister"] = "BioRegister",
        ["List"] = "List",
        ["ListRegister"] = "ListRegister",
        ["RegisterAccount"] = "RegisterAccount",
        ["RemoveAccount"] = "RemoveAccouint",
        ["SendMoney"] = "SendMoney",
    }
    ---@type Golkin.App.Scene.Pin.ePrevScene|nil
    self.CurrentPrevScene = nil
end

function SCENE:goto_Login_BioScan()
    self:detachHandlers()
    self.PROJ.Scene.Login_BioScan:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_BioScan)
end

function SCENE:goto_Login_List()
    self:detachHandlers()
    self.PROJ.Scene.Login_List:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_List)
end

function SCENE:goto_SendMoneyName()
    self:detachHandlers()
    -- skip reset for user convinience
    -- self.PROJ.Scene.SendMoneyName:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.SendMoneyName)
end

function SCENE:cb_bt_numpad(number)
    if #self.password >= self.maximumCount then
        return nil
    else
        self.password = self.password .. tostring(number)
        self:refresh_PINDisplay()
    end
end

function SCENE:cb_bt_backspace()
    if #self.password <= 0 then
        return nil
    else
        self.password = self.password:sub(1, #self.password - 1)
        self:refresh_PINDisplay()
    end
end

function SCENE:cb_bt_numpad_reset()
    self.password = ""
    self:refresh_PINDisplay()
end

function SCENE:cb_bt_back()
    if (self.CurrentPrevScene == self.ePrevScene.Bio) or
        self.CurrentPrevScene == self.ePrevScene.BioRegister then
        self:goto_Login_BioScan()
    elseif self.CurrentPrevScene == self.ePrevScene.List or
        self.CurrentPrevScene == self.ePrevScene.ListRegister then
        self:goto_Login_List()
    elseif self.CurrentPrevScene == self.ePrevScene.RegisterAccount or
        self.CurrentPrevScene == self.ePrevScene.RemoveAccount then
        self:goto_OwnerMenu()
    elseif self.CurrentPrevScene == self.ePrevScene.SendMoney then
        self:goto_SendMoneyName()
    else
        error(" cb_bt_back ?? ePrevScene is broken")
    end
end

function SCENE:cb_bt_enter_pin()
    if self.CurrentPrevScene == self.ePrevScene.Bio or
        self.CurrentPrevScene == self.ePrevScene.List then
        self:request_OWNER_LOGIN()
    elseif self.CurrentPrevScene == self.ePrevScene.RemoveAccount then
        self:request_REMOVE_ACCOUNT()
    elseif self.CurrentPrevScene == self.ePrevScene.BioRegister or
        self.CurrentPrevScene == self.ePrevScene.ListRegister or
        self.CurrentPrevScene == self.ePrevScene.RegisterAccount then
        self:goto_PINCheck()
    elseif self.CurrentPrevScene == self.ePrevScene.SendMoney then
        self:request_SEND()
    else
        error("cb_bt_enter_pin ?? ePrevScene is broken")
    end
end

function SCENE:goto_PINCheck()
    self:detachHandlers()
    self.PROJ.Scene.PINCheck:reset()
    if self.CurrentPrevScene == self.ePrevScene.BioRegister then
        self.PROJ.Scene.PINCheck.CurrentPrevScene = self.PROJ.Scene.PINCheck.ePrevScene.BioRegister
        self.PROJ.Scene.PINCheck.OwnerName = self.OwnerName
    elseif self.CurrentPrevScene == self.ePrevScene.ListRegister then
        self.PROJ.Scene.PINCheck.CurrentPrevScene = self.PROJ.Scene.PINCheck.ePrevScene.ListRegister
        self.PROJ.Scene.PINCheck.OwnerName = self.OwnerName
    elseif self.CurrentPrevScene == self.ePrevScene.RegisterAccount then
        self.PROJ.Scene.PINCheck.CurrentPrevScene = self.PROJ.Scene.PINCheck.ePrevScene.AccountRegister
        self.PROJ.Scene.PINCheck.OwnerName        = self.OwnerName
        self.PROJ.Scene.PINCheck.AccountName      = self.AccountName
    else
        error("goto_PINCheck ?? ePrevScene is broken")
    end
    self.PROJ.Scene.PINCheck.original_password = self.password
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PINCheck)
end

function SCENE:goto_OwnerMenu()
    self:detachHandlers()
    self.PROJ.Scene.OwnerMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
end

function SCENE:request_OWNER_LOGIN()
    self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_OWNER_LOGIN, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN
        self:cb_ack_owner_login(msg, msgstruct)
    end)
    self.PROJ.Client:send_OWNER_LOGIN(self.OwnerName, self.password)
end

---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN
function SCENE:cb_ack_owner_login(msg, msgstruct)
    local replyEnum = protocol.Enum.ACK_OWNER_LOGIN_R
    if (msgstruct.Success == false) then
        if msgstruct.State == replyEnum.NO_OWNER_EXIST then
            self.Layout.tb_info:setText("NO_OWNER_EXIST")
        elseif msgstruct.State == replyEnum.PASSWORD_UNMET then
            self.Layout.tb_info:setText("PASSWORD_UNMET")
        else
            error("no error code met" .. tostring(msgstruct.State))
        end
        self:cb_bt_numpad_reset()
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self.PROJ.Data.CurrentOwner = protocol.Struct.Owner_t:new()
        self.PROJ.Data.CurrentOwner.Name = self.OwnerName
        self.PROJ.Data.CurrentOwner.Password = self.password
        self:goto_OwnerMenu()
        self.PROJ.UIRunner:ReDrawAll()
    end
    self.PROJ.UIRunner:ReDrawAll()
end

function SCENE:request_REMOVE_ACCOUNT()
    self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_REMOVE_ACCOUNT, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REMOVE_ACCOUNT
        self:cb_ack_remove_account(msg, msgstruct)
    end)

    self.PROJ.Client:send_REMOVE_ACCOUNT(self.AccountName,
        self.password,
        self.PROJ.Data.CurrentOwner.Name)
end

---comment
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REMOVE_ACCOUNT
function SCENE:cb_ack_remove_account(msg, msgstruct)
    local replyEnum = protocol.Enum.ACK_REMOVE_ACCOUNT_R
    if msgstruct.Success == false then
        if msgstruct.State == replyEnum.NO_ACCOUNTS then
            self.Layout.tb_info:setText("NO_ACCOUNTS")
        elseif msgstruct.State == replyEnum.OWNER_NOT_EXIST then
            self.Layout.tb_info:setText("OWNER_NOT_EXIST")
        elseif msgstruct.State == replyEnum.OWNER_UNMET then
            self.Layout.tb_info:setText("OWNER_UNMET")
        elseif msgstruct.State == replyEnum.PASSWORD_UNMET then
            self.Layout.tb_info:setText("PASSWORD_UNMET")
        else
            self:cb_bt_numpad_reset()
            error("no error code met" .. tostring(msgstruct.State))
        end
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self:goto_OwnerMenu()
    end
    self.PROJ.UIRunner:ReDrawAll()
end

function SCENE:request_SEND()
    self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_SEND, function(msg, msgstruct)
        ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_SEND
        self:cb_ack_send(msg, msgstruct)
    end)

    local send_t = self.PROJ.Client:getSend_t()
    send_t.balance = self.SEND_struct.Balance
    send_t.from = self.SEND_struct.From
    send_t.fromMsg = self.SEND_struct.FromMsg
    send_t.owner = self.SEND_struct.OwnerName
    send_t.password = self.password
    send_t.to = self.SEND_struct.To
    send_t.toMsg = self.SEND_struct.ToMsg
    self.PROJ.Client:send_SEND(send_t)
end

---comment
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_SEND
function SCENE:cb_ack_send(msg, msgstruct)
    local replyEnum = protocol.Enum.ACK_SEND_R
    if msgstruct.Success == false then
        if msgstruct.State == replyEnum.BALANCE_CANNOT_BE_NEGATIVE then
            self.Layout.tb_info:setText("BALANCE_CANNOT_BE_NEGATIVE")
        elseif msgstruct.State == replyEnum.NOT_ENOUGHT_BALLANCE_TO_SEND then
            self.Layout.tb_info:setText("NOT_ENOUGHT_BALLANCE_TO_SEND")
        elseif msgstruct.State == replyEnum.NO_ACCOUNT_TO_RECIEVE then
            self.Layout.tb_info:setText("NO_ACCOUNT_TO_RECIEVE")
        elseif msgstruct.State == replyEnum.NO_ACCOUNT_TO_SEND then
            self.Layout.tb_info:setText("NO_ACCOUNT_TO_SEND")
        elseif msgstruct.State == replyEnum.OWNER_UNMET then
            self.Layout.tb_info:setText("OWNER_UNMET")
        elseif msgstruct.State == replyEnum.PASSWORD_UNMET then
            self.Layout.tb_info:setText("PASSWORD_UNMET")
        else
            self:cb_bt_numpad_reset()
            error("no error code met" .. tostring(msgstruct.State))
        end
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self:goto_OwnerMenu()
    end
    self.PROJ.UIRunner:ReDrawAll()
end

function SCENE:refresh_PINDisplay()
    local t = ""
    for i = 1, #self.password, 1 do
        t = t .. "* "
    end
    if #self.password >= 1 then
        t = t:sub(1, #t - 1)
    end
    self.Layout.tb_passwd_display:setText(t)

    if #self.password >= 0 and #self.password <= 3 then
        self.Layout.bt_enter_pin.Visible = false
    elseif #self.password >= 4 then
        self.Layout.bt_enter_pin.Visible = true
    end
end

function SCENE:reset()
    self.password = ""
    self:refresh_PINDisplay()
    if self.CurrentPrevScene == self.ePrevScene.Bio or
        self.CurrentPrevScene == self.ePrevScene.List then
        self.Layout.tb_info:setText("Enter your Owner PIN")
        self.PROJ.Style.TB.Info(self.Layout.tb_info)
    elseif self.CurrentPrevScene == self.ePrevScene.BioRegister or
        self.CurrentPrevScene == self.ePrevScene.ListRegister then
        self.Layout.tb_info:setText("Enter new Owner PIN")
        self.PROJ.Style.TB.Info(self.Layout.tb_info)
    elseif self.CurrentPrevScene == self.ePrevScene.RegisterAccount then
        self.Layout.tb_info:setText("Enter new Account Sending PIN")
        self.PROJ.Style.TB.Info(self.Layout.tb_info)
    elseif self.CurrentPrevScene == self.ePrevScene.RemoveAccount then
        self.Layout.tb_info:setText("Enter your owner PIN")
        self.PROJ.Style.TB.Info(self.Layout.tb_info)
    elseif self.CurrentPrevScene == self.ePrevScene.SendMoney then
        self.Layout.tb_info:setText("Enter your Account PIN")
        self.PROJ.Style.TB.Info(self.Layout.tb_info)
    else
        error("reset() ?? ePrevScene is broken")
    end
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
