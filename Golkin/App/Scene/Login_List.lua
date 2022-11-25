local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

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

    self.Layout.bt_refresh_list.ClickEvent = function(obj, e)

    end

end

function SCENE:goto_Cover()
    self.PROJ.Scene.Cover:reset()
    self.PROJ.Scene.Cover:detachHandlers()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Cover)
end

function SCENE:goto_List_Bioscan()
    self.PROJ.Scene.Login_BioScan:reset()
    self.PROJ.Scene.Login_BioScan:detachHandlers()
    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.Login_BioScan)
end

function SCENE:goto_PIN()

end

function SCENE:request_accounts_list()
    -- self.PROJ.Client
end

function SCENE:reset()
    self.Layout.lb_names:setItemSource({})
    self.Layout.lb_names:Refresh()
    self.Layout.tb_name:setText("")
    self.Layout.tb_info:setText("Select your name")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
end

function SCENE:detacheHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
