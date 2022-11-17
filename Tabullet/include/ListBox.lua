local class = require("Class.middleclass")

-- #includes
local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2


--- properties description
---@class Tabullet.ListBox : Tabullet.UIElement
---@field __ItemSource table<number, any>
---@field __Items table<number, Tabullet.ListBoxItem>
---@field __ItemTemplate fun(obj:any): string, Tabullet.Enums.Color, Tabullet.Enums.Color
---@field __Scroll number
---@field ItemRenderYOffset number
---@field __SelectedItem Tabullet.ListBoxItem
---@field __SelectedIndex number
---@field SelectedIndexChanged fun(obj: Tabullet.ListBoxItem)
---@field __viewportItems table<number, Tabullet.ListBoxItem>
---@field __OddIndexBG Tabullet.Enums.Color
---@field __OddIndexFG Tabullet.Enums.Color
---@field __EvenIndexBG Tabullet.Enums.Color
---@field __EvenIndexFG Tabullet.Enums.Color
---@field new fun(self: Tabullet.ListBox, parent: Tabullet.UIElement, screen: Tabullet.Screen, name: string) : Tabullet.ListBox

--- public ListBox : UIElement
---
---**require** :
--- - Class.middleclass
--- - UI.UIElement
--- - UI.ListBoxItem
---@class Tabullet.ListBox : Tabullet.UIElement
local ListBox = class("Tabullet.Listbox", THIS.UIElement)

function ListBox:initialize(parent, screen, name)
    THIS.UIElement.initialize(self, parent, screen, name)

    self.__ItemSource = {}
    self.__Items = {}

    ---@type fun(obj: any): string, Tabullet.Enums.Color, Tabullet.Enums.Color
    self.ItemTemplete = nil

    self.__Scroll = 1
    self.ItemRenderYOffset = 1

    self.__SelectedItem = nil
    self.__SelectedIndex = nil
    ---@type fun(obj: Tabullet.ListBoxItem)
    self.SelectedIndexChanged = nil

    self.__viewportItems = {}

    self.__OddIndexBG = THIS.Enums.Color.lightGray
    self.__OddIndexFG = THIS.Enums.Color.white
    self.__EvenIndexBG = THIS.Enums.Color.gray
    self.__EvenIndexFG = THIS.Enums.Color.white
    self.__SelectedIndexBG = THIS.Enums.Color.lightBlue
    self.__SelectedIndexFG = THIS.Enums.Color.white

end

---@return fun(obj:any): string, Tabullet.Enums.Color, Tabullet.Enums.Color ItemTemplateFunction
function ListBox:getItempTemplate() return self._ItemTemplate end

---@param template fun(obj:any): string, Tabullet.Enums.Color, Tabullet.Enums.Color
function ListBox:setItemTemplate(template) self.ItemTemplete = template end

---@param objs table<number,any>
function ListBox:setItemSource(objs) self.__ItemSource = objs; end

---@return table<number, any> objs
function ListBox:getItemSource() return self.__ItemSource end

---@return table<number, any> Items
function ListBox:getItems() return self.__Items end

---@param scroll number
function ListBox:setScroll(scroll)
    self.__Scroll = scroll
    self.ItemRenderYOffset = scroll
end

---@return number Scroll
function ListBox:getScroll() return self.__Scroll end

---@param obj Tabullet.ListBoxItem
---@param index? number
function ListBox:Insert(obj, index)
    local index_ = index or #(self.__Items) + 1
    table.insert(self.__Items, index_, obj)
end

---@param index number
function ListBox:RemoveAt(index) table.remove(self.__Items, index) end

---refresh with ItemSource
function ListBox:Refresh()
    if (self.__ItemSource ~= nil) then
        self.__Items = {}
        for index, value in ipairs(self.__ItemSource) do
            local newItem = THIS.ListBoxItem:new(self, self._screen, value)
            table.insert(self.__Items, newItem)
        end

        if (self.__SelectedItem ~= nil) then
            local isfind = false
            self.__SelectedIndex = nil
            for index, value in ipairs(self.__ItemSource) do
                if (value == self.__SelectedItem.obj) then
                    self.__SelectedIndex = index
                    isfind = true
                    self:SelectItemAt(index)
                    break
                end
            end

            if (isfind == false) then self.__SelectedItem = nil end
        end
    end
end

---@param index number
---@return boolean isSelected
function ListBox:SelectItemAt(index)
    if (index > #(self.__Items)) then
        error("index position is over Items in ListBox!")
        return false
    end

    if (self.__SelectedItem ~= nil) then
        self.__SelectedItem:isSelectIhis(false)
    end

    local newSelectedItem = self.__Items[index]
    newSelectedItem:isSelectIhis(true)

    self.__SelectedIndex = index
    self.__SelectedItem = newSelectedItem

    if (self.SelectedIndexChanged ~= nil) then
        self.SelectedIndexChanged(self.__SelectedItem)
    end
    return true
end

---select item if exist
---@param item Tabullet.ListBoxItem
---@return boolean isSelected
function ListBox:SelectItem(item) end

---get current selected Item
---@return Tabullet.ListBoxItem selectedItem or nil
function ListBox:getSelectedItem() return self.__SelectedItem end

---get current selected item index
---@return number selectedIndex or nil
function ListBox:getSelectedIndex() return self.__SelectedIndex end

function ListBox:_makeListBoxItemWithTemplate(obj)
    local listBoxItem = THIS.ListBoxItem:new(self, self._screen, obj)
    return listBoxItem
end

function ListBox:_updateViewportItems()

    -- wrap scroll
    local scrollMin = math.max(self.__Scroll, 1)
    local scrollMax = THIS.UITools.calcRelativeOffset_Raw(scrollMin, self.Len.y)

    scrollMax = math.min(scrollMax, #(self.__Items))
    scrollMin = math.max(scrollMax - self.Len.y + 1, 1)

    -- wrap scroll
    self.__Scroll = scrollMin

    -- update viewport items
    self.__viewportItems = {}
    for i = scrollMin, scrollMax, 1 do
        table.insert(self.__viewportItems, self.__Items[i])
    end

    self.Children = {}
    -- update viewport item appearance
    for index, value in ipairs(self.__viewportItems) do
        local isEven = ((scrollMin + index - 1) % 2) == 0

        if (value.IsSelected) then
            value:setBG(self.__SelectedIndexBG)
            value:setFG(self.__SelectedIndexFG)
        else
            if (isEven) then
                value:setBG(self.__EvenIndexBG)
                value:setFG(self.__EvenIndexFG)
            else
                value:setBG(self.__OddIndexBG)
                value:setFG(self.__OddIndexFG)
            end
        end

        value:updateItemVisual()
        table.insert(self.Children, value)
    end

end

-- [overriding functions]

---overrided function from UIElement:render()
function ListBox:render() -- renderOffset)

    -- update global pos
    self:_updatePos()

    -- update and change viewport items properties
    self:_updateViewportItems()

    -- -- update length from parent
    -- self:_updateLengthFromParent()

    -- self:_backgroundDraw()

    -- render history add
    self:_addThisToRenderHistory()

    -- initialize item render offset to 1
    self.ItemRenderYOffset = 1

    -- render children
    self:renderChildren()

end

---overrided function from UIElement:_ClickEvent
---@param e Tabullet.ClickEventArgs
function ListBox:_ClickEvent(e)
    local relClickPos = THIS.UITools
        .transformGlobalPos2LocalPos(e.Pos, self.Pos)

    local clickedIndex = nil
    if ((1 <= relClickPos.y) and (relClickPos.y <= #(self.__viewportItems))) then
        clickedIndex = THIS.UITools.transformLocalIndex2GlobalIndex(
            relClickPos.y, self.__Scroll)
    end

    if (clickedIndex == nil) then return nil end

    self:SelectItemAt(clickedIndex)

    e.Handled = true
end

---overrided function from UIElement:_ScrollEvent
---@param e Tabullet.ScrollEventArgs
function ListBox:_ScrollEvent(e)
    self.__Scroll = self.__Scroll + e.Direction
    e.Handled = true
end

---overrided function from UIElement:_KeyInputEvent
---@param e Tabullet.KeyInputEventArgs
function ListBox:_KeyInputEvent(e) end

---overrided function from UIElement:_CharEvent
---@param e Tabullet.CharEventArgs
function ListBox:_CharEvent(e) end

---overrided function from UIElement:PostRendering()
function ListBox:PostRendering() end

---overrided function from UIElement:FocusIn()
function ListBox:FocusIn() end

---overrided function from UIElement:FocusOut()
function ListBox:FocusOut() end

return ListBox
