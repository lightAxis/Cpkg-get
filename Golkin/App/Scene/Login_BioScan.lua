local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

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

    self.Layout.bt_register.ClickEvent = function(obj, e)
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
    self.PROJ.Scene.PIN.CurrentPrevScene = self.PROJ.Scene.PIN.ePrevScene.Bio
    self.PROJ.Scene.PIN.OwnerName = self.Layout.tb_playerName:getText()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)
end

function SCENE:goto_PIN_REGISTER()
    self:detachHandlers()
    self.PROJ.Scene.PIN:reset()
    self.PROJ.Scene.PIN.CurrentPrevScene = self.PROJ.Scene.PIN.ePrevScene.BioRegister
    self.PROJ.Scene.PIN.OwnerName = self.Layout.tb_playerName:getText()
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
    self.Layout.bt_register.Visible = false
    self.Layout.tb_playerName:setText("")
    self:attach_handler()
    self:check_playerDetector()
    -- temp for debug
    os.queueEvent("playerClick", "testname1")

end

function SCENE:attach_handler()
    self.PROJ.EventRouter:attachEventCallback("playerClick", function(a, b, c, d)
        -- "playerClick", username
        self.Layout.tb_playerName:setText(b)
        self.Layout.bt_auth.Visible = true
        self.Layout.bt_register.Visible = true
    end)
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
    self.PROJ.EventRouter:removeEventCallback("playerClick")
end

return SCENE
