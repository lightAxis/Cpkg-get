local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.RegisterAccount : Tabullet.UIScene
---@field Layout Golkin.App.Layout.RegisterAccount
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.RegisterAccount
local SCENE = class("Golkin.App.Scene.RegisterAccount", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.RegisterAccount
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.tb_info_accountNameC.ClickEvent = function(obj, e)
        ---@cast obj Tabullet.TextBlock
        self.IsMenuEditting = not self.IsMenuEditting
        self:set_entryMode(obj, self.IsMenuEditting)
    end

    self.Layout.bt_remove.ClickEvent = function(obj, e)

        if (#(self.Layout.tb_info_accountNameC:getText()) <= 0) then
            self.Layout.tb_info:setText("no account name to register!")
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
            return nil
        end
        self:goto_PIN()
    end

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_OwnerMenu()
        end
    end

    self.IsMenuEditting = false
end

function SCENE:goto_OwnerMenu()
    self:detachHandlers()
    self.PROJ.Scene.OwnerMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
end

function SCENE:goto_PIN()
    self:detachHandlers()
    self.PROJ.Scene.PIN.CurrentPrevScene = self.PROJ.Scene.PIN.ePrevScene.RegisterAccount
    self.PROJ.Scene.PIN:reset()
    self.PROJ.Scene.PIN.AccountName = self.Layout.tb_info_accountNameC:getText()
    self.PROJ.Scene.PIN.OwnerName = self.PROJ.Data.CurrentOwner.Name
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)
end

---comment
---@param tb Tabullet.TextBlock
function SCENE:set_entryMode(tb, bool)
    if bool == true then
        self.PROJ.Style.TB.infoContentEdit(tb)
        tb:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.center)
        self.PROJ.Scene.ManualTextInput.LinkedTextBlock = tb
        self.PROJ.Scene.ManualTextInput.MaxLenLimit = 16
        self.PROJ.Scene.ManualTextInput.IsBlockSpace = true
        self.PROJ.Scene.ManualTextInput:reset()
    else
        self.PROJ.Style.TB.infoContent(tb)
        tb:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.center)
        self.PROJ.Scene.ManualTextInput.LinkedTextBlock = nil
        self.PROJ.Scene.ManualTextInput:reset()
    end
end

-- function SCENE:send_Register_request()
--     self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_REGISTER, function(msg, msgstruct)
--         ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER
--         self:cb_ack_register_account(msg, msgstruct)
--     end)

--     self.PROJ.Client:send_REGISTER(self.Layout.tb_info_accountNameC:getText(),
--         self.PROJ.Data.CurrentOwner.Name, self.PROJ.Data.CurrentOwner.Password)
-- end

---comment
---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER
function SCENE:cb_ack_register_account(msg, msgstruct)
    local replyEnum = protocol.Enum.ACK_REGISTER_R
    if msgstruct.Success ~= true then
        if msgstruct.State == replyEnum.ACCOUNT_OWNER_UNMET then
            self.Layout.tb_info:setText("ACCOUNT_OWNER_UNMET")
        elseif msgstruct.State == replyEnum.ACCOUNT_ALREADY_EXISTS then
            self.Layout.tb_info:setText("ACCOUNT_ALREADY_EXISTS")
        else
            self.Layout.tb_info:setText("UNKNOWN_ERROR:" .. tostring(msgstruct.State))
        end
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self.Layout.tb_info:setText("SUCCESS!")
        self.PROJ.Style.TB.InfoSuccess(self.Layout.tb_info)
    end
    self.PROJ.UIRunner:ReDrawAll()
end

function SCENE:reset()
    self.IsMenuEditting = false
    self:set_entryMode(self.Layout.tb_info_accountNameC, false)
    self.Layout.tb_info:setText("Click textblock to link manual textInput")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
    self.Layout.tb_title:setText("Register New Account as Owner:" .. self.PROJ.Data.CurrentOwner.Name)
    self.Layout.tb_info_accountNameC:setText("")
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
