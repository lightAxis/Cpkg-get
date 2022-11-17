local class = require("Class.middleclass")

local THIS = PKGS.Tabullet

---@class Tabullet.ProjTemplate.SCENENAME1_L : Tabullet.UILayout
local SCENE_L = class("Tabullet.ProjTemplate.SCENENAME1_L")

---constructor
---@param attachedScreen Tabullet.Screen
---@param ProjNamespace ProjTemplate
function SCENE_L:initialize(attachedScreen, ProjNamespace)
    THIS.UILayout.initialize(self, attachedScreen, ProjNamespace)

    ---@type Tabullet.Grid
    local grid = THIS.Grid:new(attachedScreen:getSize())
    grid:setHorizontalSetting({ "3", "10", "3", "*", "3" })
    grid:setVerticalSetting({ "1", "10", "*", "5", "*" })
    grid:updatePosLen()
    self.grid = grid

    ---@type Tabullet.Button
    local ButtonNext = THIS.Button:new(self.rootScreenCanvas,
        self.attachingScreen, "ButtonNext")
    ButtonNext:setText("Next Scene")
    -- link events at UIScene, not here
    -- ButtonNext.ClickEvent = function() end
    ButtonNext:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    ButtonNext:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    ButtonNext.PosRel, ButtonNext.Len = grid:getPosLen(2, 4, 2, 1)
    self.ButtonNext = ButtonNext

    ---@type Tabullet.ListBox
    local listbox = THIS.ListBox:new(self.rootScreenCanvas, self.attachingScreen, "listbox")
    local fuu = function(k, v) return { ["a"] = k, ["b"] = v } end
    local testTable1 = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }
    local testTable2 = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "aa", "bb", "ccasdfasdfsfa" }
    local source = {}
    for index, value in ipairs(testTable1) do
        table.insert(source, fuu(testTable1[index], testTable2[index]))
    end
    listbox:setItemSource(source)
    local itemTemplate = function(obj)
        local text = tostring(obj.a) .. "/" .. obj.b
        return text
    end
    listbox:setItemTemplate(itemTemplate)
    -- link events at UIScene, not here
    -- listbox.SelectedIndexChanged = function(obj) end
    listbox:Refresh()
    listbox.PosRel, listbox.Len = grid:getPosLen(2, 2)
    self.listbox = listbox

    ---@type Tabullet.TextBlock
    local textblock = THIS.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "tb1")
    textblock:setText("this is textblock!")
    textblock:setTextHorizontalAlignment(THIS.Enums.HorizontalAlignmentMode.center)
    textblock:setTextVerticalAlignment(THIS.Enums.VerticalAlignmentMode.center)
    textblock:setIsTextEditable(true)
    textblock.PosRel, textblock.Len = grid:getPosLen(4, 2)
    self.textblock1 = textblock

end

return SCENE_L
