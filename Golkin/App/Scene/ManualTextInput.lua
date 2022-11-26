local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Scene.ManualTextInput : Tabullet.UIScene
---@field Layout Golkin.App.Layout.ManualTextInput
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.ManualTextInput
local SCENE = class("Golkin.App.Scene.ManualTextInput", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.ManualTextInput
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.tb_input:setIsTextEditable(true)

    self.Layout.tb_input:getTextArea().ClickEvent = function(obj, e)
        if (self.LinkedTextBlock == nil) then
            e.Handled = true
        end
    end

    self.Layout.tb_input:getTextArea().CharEvent = function(obj, e)
        if (self.LinkedTextBlock ~= nil) then
            local currentText = self.Layout.tb_input:getText()
            if (#currentText >= self.MaxLenLimit) then
                e.Handled = true
            elseif e.Char == " " then
                e.Handled = self.IsBlockSpace
            end
            self.LinkedTextBlock:setText(self.Layout.tb_input:getText())
        else
            e.Handled = true
        end
    end

    self.Layout.tb_input:getTextArea().KeyInputEvent = function(obj, e)
        if self.LinkedTextBlock ~= nil then
            if e.Key == TBL.Enums.Key.backspace or
                e.Key == TBL.Enums.Key.delete then
                self.LinkedTextBlock:setText(self.Layout.tb_input:getText())
            elseif e.Key == TBL.Enums.Key["return"] then
                self.LinkedTextBlock:setText(self.Layout.tb_input:getText())
                e.Handled = true
            end
        else
            e.Handled = true
        end
    end

    ---@type Tabullet.TextBlock
    self.LinkedTextBlock = nil
    self.MaxLenLimit = 16
    self.IsBlockSpace = false
end

function SCENE:reset()
    if (self.LinkedTextBlock ~= nil) then
        self.Layout.tb_info:setText("Connected!, type at here, Return to finish")
        self.PROJ.Style.TB.InfoSuccess(self.Layout.tb_info)
        self.Layout.tb_input:setText(self.LinkedTextBlock:getText())
    else
        self.Layout.tb_info:setText("No textblock is connected")
        self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
        self.Layout.tb_input:setText("")
    end
end

function SCENE:detachHandlers()

end

return SCENE
