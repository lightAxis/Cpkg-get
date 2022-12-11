local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.Login_List : Tabullet.UIScene
---@field Layout Golkin.App.Layout.Login_List
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.Login_List
local SCENE = class("Golkin.App.Scene.Login_List", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.Login_List
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_Cover()
        end
    end
    self.Layout.bt_left_arrow.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_List_Bioscan()
        end
    end
    self.Layout.bt_see_histories.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:callback_bt_refresh_list()
        end
    end

    self.Layout.lb_names.ItemTemplete = function(obj)
        return obj
    end

    self.Layout.lb_names.SelectedIndexChanged = function(obj)
        local name = obj.obj
        self.Layout.tb_name:setText(name)
        self.Layout.bt_signIn.Visible = true
    end

    self.Layout.bt_scroll_down.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self.Layout.lb_names:setScroll(self.Layout.lb_names:getScroll() + 1)
        end
    end

    self.Layout.bt_scroll_up.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self.Layout.lb_names:setScroll(self.Layout.lb_names:getScroll() - 1)
        end
    end

    self.Layout.bt_signIn.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_PIN()
        end
    end

    self.currentOwnerList = {}

end

function SCENE:goto_Cover()
    self:detacheHandlers()
    self.PROJ.Scene.Cover:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Cover)
end

function SCENE:goto_List_Bioscan()
    self:detacheHandlers()
    self.PROJ.Scene.Login_BioScan:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_BioScan)
end

function SCENE:goto_PIN()
    self:detacheHandlers()
    -- self.PROJ.Scene.PIN.CurrentPrevScene = self.PROJ.Scene.PIN.ePrevScene.List

    local ownerName = self.Layout.tb_name:getText()

    local PINScene = self.PROJ.Scene.PIN

    PINScene:reset()
    -- self.PROJ.Scene.PIN.OwnerName = self.Layout.tb_name:getText()
    -- local a = self.PROJ.Scene.PIN
    -- a
    PINScene:infoStr_normal("Enter your Owner PIN")

    PINScene.Event_bt_back = function(PIN)
        ---@cast PIN Golkin.App.Scene.PIN
        PIN:detachHandlers()
        PIN.PROJ.Scene.Login_List:reset()
        PIN.PROJ.UIRunner:attachScene(PIN.PROJ.Scene.Login_List)
    end

    PINScene.Event_bt_enter = function(PIN)
        ---@cast PIN Golkin.App.Scene.PIN
        PIN.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_OWNER_LOGIN, function(msg, msgstruct)
            ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_OWNER_LOGIN
            if msgstruct.Success == false then
                PIN:infoStr_error(protocol.Enum_INV.ACK_OWNER_LOGIN_R_INV[msgstruct.State])
            else
                self.PROJ.Data.CurrentOwner = protocol.Struct.Owner_t:new()
                self.PROJ.Data.CurrentOwner.Name = ownerName
                self.PROJ.Data.CurrentOwner.Password = PIN.password

                PIN:detachHandlers()
                self.PROJ.Scene.OwnerMenu:reset()
                self.PROJ.UIRunner:attachScene(self.PROJ.Scene.OwnerMenu)
            end
            PIN.PROJ.UIRunner:ReDrawAll()
        end)
        self.PROJ.Client:send_OWNER_LOGIN(ownerName, PIN.password)
    end

    self.PROJ.UIRunner:attachScene(PINScene)
end

---change infotext style
---@param text string
---@param style fun(tb:Tabullet.TextBlock)
function SCENE:changeInfo(text, style)
    self.Layout.tb_info:setText(text)
    style(self.Layout.tb_info)
end

function SCENE:callback_bt_refresh_list()
    ---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNERS
    self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_GET_OWNERS, function(msg, msgstruct)
        self:ack_get_owners_callback(msg, msgstruct)
    end)
    self.PROJ.Client:send_GET_OWNERS()
end

---@param msg Golkin.Web.Protocol.Msg
---@param msgstruct Golkin.Web.Protocol.MsgStruct.ACK_GET_OWNERS
function SCENE:ack_get_owners_callback(msg, msgstruct)
    local replyEnum = protocol.Enum.ACK_GET_OWNERS_R
    if msgstruct.Success == false then
        if msgstruct.State == replyEnum.NO_OWNERS then
            self:changeInfo("NO_OWNER_EXISTS", self.PROJ.Style.TB.InfoFail)
        end
    else
        -- self:changeInfo("SUCCESS", self.PROJ.Style.TB.InfoSuccess)
        self.currentOwnerList = msgstruct.OwnerNames
        self.Layout.lb_names:setItemSource(self.currentOwnerList)
        self.Layout.lb_names:Refresh()
    end
    self.PROJ.UIRunner:ReDrawAll()
end

function SCENE:request_accounts_list()
    -- self.PROJ.Client
end

function SCENE:reset()
    self.Layout.lb_names:setItemSource({})
    self.Layout.lb_names:Refresh()
    self.Layout.tb_name:setText("")
    self.Layout.tb_info:setText("Select your name")
    self.Layout.bt_signIn.Visible = false
    self:callback_bt_refresh_list()
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
end

function SCENE:detacheHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
