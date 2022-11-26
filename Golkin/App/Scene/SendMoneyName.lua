local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.SendMoneyName : Tabullet.UIScene
---@field Layout Golkin.App.Layout.SendMoneyName
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.SendMoneyName
local SCENE = class("Golkin.App.Scene.SendMoneyName", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.SendMoneyName
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_SendMoney()
        end
    end

    self.Layout.tb_sender_msgC:getTextArea().ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            if self.IsRecieveMsgEditting == true then
                self:set_entryMode(self.Layout.tb_reciever_msgC, false)
                self.IsRecieveMsgEditting = false
            end
            self.IsSendMsgEditting = not self.IsSendMsgEditting
            self:set_entryMode(self.Layout.tb_sender_msgC, self.IsSendMsgEditting)
        end
    end
    self.Layout.tb_reciever_msgC:getTextArea().ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            if self.IsSendMsgEditting == true then
                self:set_entryMode(self.Layout.tb_sender_msgC, false)
                self.IsSendMsgEditting = false
            end
            self.IsRecieveMsgEditting = not self.IsRecieveMsgEditting
            self:set_entryMode(self.Layout.tb_reciever_msgC, self.IsRecieveMsgEditting)
        end
    end

    self.Layout.bt_send.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_PIN()
        end
    end

    ---@type Golkin.Web.Protocol.MsgStruct.SEND
    self.SEND_struct = nil

    self.IsSendMsgEditting = false
    self.IsRecieveMsgEditting = false
end

function SCENE:goto_SendMoney()
    self:detachHandlers()
    -- not reset for convinience
    -- self.PROJ.Scene.SendMoney:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.SendMoney)
end

function SCENE:goto_PIN()
    if self.Layout.tb_sender_msgC:getText() == "" then
        self.Layout.tb_info:setText("Sender msg is empty!")
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    elseif self.Layout.tb_reciever_msgC:getText() == "" then
        self.Layout.tb_info:setText("Reciever msg is empty!")
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
    else
        self:detachHandlers()
        self.SEND_struct.FromMsg = self.Layout.tb_sender_msgC:getText()
        self.SEND_struct.ToMsg = self.Layout.tb_reciever_msgC:getText()
        self.PROJ.Scene.PIN.SEND_struct = self.SEND_struct
        self.PROJ.Scene.PIN.CurrentPrevScene = self.PROJ.Scene.PIN.ePrevScene.SendMoney
        self.PROJ.Scene.PIN:reset()
        self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)
    end
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

function SCENE:refreshSENDpanel()
    if self.SEND_struct ~= nil then
        self.Layout.tb_info_balanceC:setText(self.PROJ.Style.STR.Balance(tostring(self.SEND_struct.Balance)))
        self.Layout.tb_sender_accnameC:setText(self.SEND_struct.From)
        self.Layout.tb_sender_msgC:setText(self.SEND_struct.FromMsg)
        self.Layout.tb_reciever_accnameC:setText(self.SEND_struct.To)
        self.Layout.tb_reciever_msgC:setText(self.SEND_struct.ToMsg)
    end
end

function SCENE:reset()
    -- self.Layout.tb_title:setText("Send Money From : " .. self.SEND_struct.From)
    self.Layout.tb_info:setText("Click each msg block to edit content")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
    self.IsSendMsgEditting = false
    self.IsRecieveMsgEditting = false
    self:set_entryMode(self.Layout.tb_sender_msgC, false)
    self:set_entryMode(self.Layout.tb_reciever_msgC, false)
    self:refreshSENDpanel()
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
