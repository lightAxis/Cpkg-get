local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.Login_BioScan : Tabullet.UIScene
---@field Layout Golkin.App.Layout.Login_BioScan
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.Login_BioScan
local SCENE = class("Golkin.App.Scene.Login_BioScan", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.Login_BioScan
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if (e.Button == TBL.Enums.MouseButton.left) then
            self:goto_Cover()
        end
    end

    self.Layout.bt_gotoList.ClickEvent = function(obj, e)
        if (e.Button == TBL.Enums.MouseButton.left) then
            self:goto_Login_List()
        end
    end

    self.Layout.bt_auth.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_PIN()
        end
    end

    self.Layout.bt_remove.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_PIN_REGISTER()
        end
    end


    self.INFOS = {
        ["init"] = "Click Player Detection to Sign In!",
        ["pressAuth"] = "Click Login button to continue",
        ["no_playerdetector"] = "No PlayerDetector connected!",
    }

    self.INFOS_ = {
        ["init"] = self.PROJ.Style.TB.Info,
        ["pressAuth"] = self.PROJ.Style.TB.Info,
        ["no_playerdetector"] = self.PROJ.Style.TB.InfoFail,
    }
end

function SCENE:goto_Cover()
    self:detachHandlers()
    self.PROJ.Scene.Cover:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Cover)
end

function SCENE:goto_Login_List()
    self:detachHandlers()
    self.PROJ.Scene.Login_List:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_List)
end

function SCENE:goto_PIN()
    self:detachHandlers()

    self.PROJ.Scene.PIN:reset()
    local ownerName = self.Layout.tb_playerName:getText()

    self.PROJ.Scene.PIN.Event_bt_back = function(PIN)
        ---@cast PIN Golkin.App.Scene.PIN
        PIN:detachHandlers()
        PIN.PROJ.Scene.Login_BioScan:reset()
        PIN.PROJ.UIRunner:attachScene(PIN.PROJ.Scene.Login_BioScan)
    end

    self.PROJ.Scene.PIN.Event_bt_enter = function(PIN)
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

    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)
end

function SCENE:goto_PIN_REGISTER()
    self:detachHandlers()
    -- self.PROJ.Scene.PIN.CurrentPrevScene = self.PROJ.Scene.PIN.ePrevScene.BioRegister
    self.PROJ.Scene.PIN:reset()
    -- self.PROJ.Scene.PIN.OwnerName = self.Layout.tb_playerName:getText()
    local ownerName = self.Layout.tb_playerName:getText()

    self.PROJ.Scene.PIN:infoStr_normal("Enter new Owner PIN")
    self.PROJ.Scene.PIN.Event_bt_back = function(PIN)
        ---@cast PIN Golkin.App.Scene.PIN
        PIN:detachHandlers()
        self.PROJ.Scene.Login_BioScan:reset()
        self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_BioScan)
    end

    self.PROJ.Scene.PIN.Event_bt_enter = function(PIN)
        ---@cast PIN Golkin.App.Scene.PIN
        PIN:detachHandlers()
        self.PROJ.Scene.PINCheck:reset()
        self.PROJ.Scene.PINCheck.original_password = PIN.password
        self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PINCheck)
    end

    self.PROJ.Scene.PINCheck.Event_bt_back = function(PINC)
        ---@cast PINC Golkin.App.Scene.PINCheck
        PINC:detachHandlers()
        self.PROJ.Scene.Login_BioScan:reset()
        self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_BioScan)
    end

    self.PROJ.Scene.PINCheck.Event_bt_enter = function(PINC)
        ---@cast PINC Golkin.App.Scene.PINCheck

        self.PROJ.Handle:attachMsgHandle(protocol.Header.ACK_REGISTER_OWNER, function(msg, msgstruct)
            ---@cast msgstruct Golkin.Web.Protocol.MsgStruct.ACK_REGISTER_OWNER
            if msgstruct.Success == false then
                PINC:infoStr_error(protocol.Enum_INV.ACK_REGISTER_OWNER_R_INV[msgstruct.State])
            else
                PINC.Event_bt_back(PINC)
            end
            self.PROJ.UIRunner:ReDrawAll()
        end)

        self.PROJ.Client:send_REGISTER_OWNER(ownerName, PINC.password)
    end

    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)
end

function SCENE:check_playerDetector()
    if self.PROJ.Peripheral.PlayerDetector == nil then
        self.Layout.tb_info:setText(self.INFOS.no_playerdetector)
        self.INFOS_.no_playerdetector(self.Layout.tb_info)
    else
        self.Layout.tb_info:setText(self.INFOS.init)
        self.INFOS_.init(self.Layout.tb_info)
    end
end

function SCENE:reset()
    self.Layout.bt_auth.Visible = false
    self.Layout.bt_remove.Visible = false
    self.Layout.tb_playerName:setText("")
    self:attach_handler()
    self:check_playerDetector()
    -- temp for debug
    -- os.queueEvent("playerClick", "testname12")

end

function SCENE:attach_handler()
    self.PROJ.EventRouter:attachEventCallback("playerClick", function(a, b, c, d)
        -- "playerClick", username
        self.Layout.tb_playerName:setText(b)
        self.Layout.bt_auth.Visible = true
        self.Layout.bt_remove.Visible = true

        self.PROJ.UIRunner:ReDrawAll()
    end)
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
    self.PROJ.EventRouter:removeEventCallback("playerClick")
end

return SCENE
