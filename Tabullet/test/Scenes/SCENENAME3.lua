local class = require("Class.middleclass")

local THIS = PKGS.Tabullet

---@class Tabullet.ProjTemplate.SCENENAME3 : Tabullet.UIScene
local SCENE = class("Tabullet.ProjTemplate.SCENENAME3")


---constructor
---@param ProjTemplatespace ProjTemplate
---@param UILayout Tabullet.ProjTemplate.SCENENAME3_L
function SCENE:initialize(ProjTemplatespace, UILayout)
    THIS.UIScene.initialize(self, ProjTemplatespace, UILayout)

    -- ? to use type checking autocomplete from lua server..
    -- TODO if lua server updates for this issue, than can change
    local layout = self.Layout
    ---@cast layout Tabullet.ProjTemplate.SCENENAME3_L
    self.UILayout = layout

    self.UILayout.button2.ClickEvent = function() self:buttonClickEvent_prev() end

    self.UILayout.button3.ClickEvent = function() self:buttonClickEvent_next() end

    self.UILayout.button_up.ClickEvent = function() self:buttonClickEvent_up() end

    self.UILayout.button_down.ClickEvent = function() self:buttonClickEvent_down() end



end

function SCENE:buttonClickEvent_prev()
    if (self.Layout.attachingScreen:getScreenSide() ~= THIS.Enums.Side.NONE) then
        self.PROJ.UIRunner:changeScene(self.PROJ.SCENENAME2_t)
    else
        self.PROJ.UIRunner:changeScene(self.PROJ.SCENENAME2)
    end
end

function SCENE:buttonClickEvent_next()
    if (self.Layout.attachingScreen:getScreenSide() ~= THIS.Enums.Side.NONE) then
        self.PROJ.UIRunner:changeScene(self.PROJ.SCENENAME3_t)
    else
        self.PROJ.UIRunner:changeScene(self.PROJ.SCENENAME3)
    end
end

function SCENE:buttonClickEvent_up()
    self.UILayout.progressbar1:setValue(self.UILayout.progressbar1:getValue() + 0.1)
    self.UILayout.progressbar2:setValue(self.UILayout.progressbar2:getValue() + 0.1)
    self.UILayout.tx1:setText("now loading... (" .. tostring(self.UILayout.progressbar1:getValue() * 100) .. "%)")
end

function SCENE:buttonClickEvent_down()
    self.UILayout.progressbar1:setValue(self.UILayout.progressbar1:getValue() - 0.1)
    self.UILayout.progressbar2:setValue(self.UILayout.progressbar2:getValue() - 0.1)
    self.UILayout.tx1:setText("now loading... (" .. tostring(self.UILayout.progressbar1:getValue() * 100) .. "%)")
end

return SCENE
