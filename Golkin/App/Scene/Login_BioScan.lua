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
end

function SCENE:goto_Cover()
    self.PROJ.Scene.Cover:reset()
    self.PROJ.Scene.Cover:detachHandlers()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Cover)
end

function SCENE:goto_Login_List()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_List)
end

function SCENE:reset()
    self.Layout.bt_auth.Visible = false
    self.Layout.tb_playerName:setText("")
    self.INFOS_.init(self.Layout.tb_info)
    self.Layout.tb_info:setText(self.INFOS.init)
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

SCENE.INFOS = {
    ["init"] = "Click Player Detection to Sign In!",
    ["pressAuth"] = "Click Login button to next"
}

SCENE.INFOS_ = {
    ["init"] = SCENE.PROJ.Style.TB.Info,
    ["pressAuto"] = SCENE.PROJ.Style.TB.Info,
}

return SCENE
