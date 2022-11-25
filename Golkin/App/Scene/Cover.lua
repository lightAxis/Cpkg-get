local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Scene.Cover : Tabullet.UIScene
---@field Layout Golkin.App.Layout.Cover
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.Cover
local SCENE = class("Golkin.App.Scene.Cover", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.Cover
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_login.ClickEvent = function(obj, e)
        self:goto_Login_BioScan()
    end

end

function SCENE:goto_Login_BioScan()
    self.PROJ.Scene.Login_BioScan:reset()
    self.PROJ.Scene.Login_BioScan:detachHandlers();
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_BioScan)
end

function SCENE:reset()

end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
