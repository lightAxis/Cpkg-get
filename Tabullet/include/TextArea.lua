local class = require("Class.middleclass")


--- include
local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2

-- properties description
---@class Tabullet.TextArea : Tabullet.UIElement
---@field _HorizontalAlignmentMode Tabullet.Enums.HorizontalAlignmentMode
---@field _VerticalAlignmentMode Tabullet.Enums.VerticalAlignmentMode
---@field _TextSplited table<number, TextArea.TextSplitedNode>
---@field _TextSplitedWrapped table<number, TextArea.WrappedNode>
---@field _TextSplitedWrappedLines table<number, TextArea.WrappedNode>
---@field _TextSplitedViewportLines table<number, string>
---@field _scroll number
---@field _VerticalOffset number
---@field _TextEditIndex number
---@field _TextEditPos MathLib.Vector2
---@field _TextEditCursorPos MathLib.Vector2
---@field IsTextEditable boolean
---@field _isTextEditting boolean
---@field new fun(self:Tabullet.TextArea, parent: Tabullet.UIElement, screen: Tabullet.Screen, name: string, text: string): Tabullet.TextArea

-- public class TextBlock : UIElement
---
---**require** :
--- - Class.middleclass
--- - UI.UIElement
--- - UI.Enums
--- - UI.UITools
--- - MathLib.Vector2
--- - LibGlobal.StaticMethods
---@class Tabullet.TextArea : Tabullet.UIElement
local TextArea = class("TextArea", THIS.UIElement)


-- [constructor]
---comment
---@param parent Tabullet.UIElement
---@param screen Tabullet.Screen
---@param name string
---@param text string or ""
function TextArea:initialize(parent, screen, name, text)
    if (parent == nil) then error("TextArea must have a parent UIElement!") end
    THIS.UIElement.initialize(self, parent, screen, name)

    self._HorizontalAlignmentMode = THIS.Enums.HorizontalAlignmentMode.left
    self._VerticalAlignmentMode = THIS.Enums.VerticalAlignmentMode.top

    self._TextSplited = {}
    self._TextSplitedWrapped = {}
    self._TextSplitedWrappedLines = {}
    self._TextSplitedViewportLines = {}

    self._Text = text or ""

    self:setText(self._Text)
    self:setHorizontalAlignment(self._HorizontalAlignmentMode)
    self:setVerticalAlignment(self._VerticalAlignmentMode)

    self._scroll = 1
    self._VerticalOffset = 1

    self._TextEditIndex = 1
    self._TextEditPos = Vector2:new(1, 1)
    self._TextEditCursorPos = Vector2:new(1, 1)
    self.IsTextEditable = false
    self._isTextEditting = false
end

---------[private classes]-----------

--- private class textSplitedNode
--- **is is private class in TextArea.**
---@class TextArea.TextSplitedNode
local TextSplitedNode = class("textSplitedNode")

---properties description
---@class TextArea.TextSplitedNode
---@field index number
---@field text string
---@field wrappedNodes table<number, TextArea.WrappedNode>
---@field new fun(self: TextArea.TextSplitedNode, index:number, text:string, wrappedNode: TextArea.WrappedNode): TextArea.TextSplitedNode

---constructor
---@param index number
---@param text string
---@param wrappedNodes? table<number, TextArea.WrappedNode> or {}
function TextSplitedNode:initialize(index, text, wrappedNodes)
    self.index = index
    self.text = text
    self.wrappedNodes = wrappedNodes or {}
end

---private class WrappedNode
---**this is private class in TextArea**
---@class TextArea.WrappedNode
local WrappedNode = class("WrappedNode")

-- properties description
---@class TextArea.WrappedNode
---@field index number
---@field text string
---@field align number
---@field parent TextArea.TextSplitedNode
---@field new fun(self:TextArea.WrappedNode,index: number, text:string, align:number|nil, parent: TextArea.TextSplitedNode|nil): TextArea.WrappedNode

---constructor
---@param index number
---@param text string
---@param align number|nil
---@param parent TextArea.TextSplitedNode|nil
function WrappedNode:initialize(index, text, align, parent)
    self.index = index
    self.text = text
    self.align = align
    self.parent = parent
end

-- [functions]

---set text of this textarea
---@param text string
function TextArea:setText(text)
    if (text == nil) then
        error("TextBlock:setText(text) : text must be string")
    end
    self._Text = text
    -- self:_getTextSplited()
    self:_updateTextSplited()
end

---set vertical alignment mode of textblock
---@param align Tabullet.Enums.VerticalAlignmentMode
function TextArea:setVerticalAlignment(align) self._VerticalAlignmentMode =
    align
end

---set horizontal alignment mode of textblock
---@param align Tabullet.Enums.HorizontalAlignmentMode
function TextArea:setHorizontalAlignment(align)
    self._HorizontalAlignmentMode = align
end

---get full text of this textarea
---@return string
function TextArea:getText() return self._Text end

---set scroll index of this textarea
---@param scroll number
function TextArea:setScroll(scroll) self._scroll = math.max(1, scroll) end

---get scroll index of this textarea
---@return number
function TextArea:getScroll() return self._scroll end

---make textsplited with rawText
function TextArea:_updateTextSplited()
    local text_ = self._Text

    -- split text with '\n'
    local textSplited_ = self._Text:split("\n")

    -- split by text with \n
    local lengthSum = 1
    self._TextSplited = {}

    for index, value in ipairs(textSplited_) do

        local TextSplited_node = TextSplitedNode:new(lengthSum, value, {})
        table.insert(self._TextSplited, TextSplited_node)
        lengthSum = lengthSum + #value + 1
    end

end

---make wrappedTextNodes with splitted text
function TextArea:_updateTextSplitedWrapped()
    self._TextSplitedWrapped = {}

    -- split text by length of element
    for i, v in ipairs(self._TextSplited) do
        local textline = v.text
        local textline_spliited = ""
        local textline_anchor = 1
        v.wrappedNodes = {}

        local superContinue = false
        if (textline == "") then
            local temp = WrappedNode:new(1, "", nil, nil)
            table.insert(v.wrappedNodes, temp)
            table.insert(self._TextSplitedWrapped, temp)
            temp.parent = v
            superContinue = true
        end

        if (superContinue == false) then
            while (#textline >= self.Len.x) do
                textline_spliited = string.sub(textline, 1, self.Len.x)
                local temp = WrappedNode:new(textline_anchor, textline_spliited,
                    nil, nil)
                table.insert(v.wrappedNodes, temp)
                table.insert(self._TextSplitedWrapped, temp)
                temp.parent = v

                textline_anchor = textline_anchor + self.Len.x
                textline = string.sub(textline, self.Len.x + 1, #textline)
            end

            if (textline ~= "") then
                textline_spliited = textline
                local temp = WrappedNode:new(textline_anchor, textline, nil,
                    --  JLib.UITools
                    --      .calcHorizontalAlignPos(1,
                    --                              self.Len
                    --                                  .x,
                    --                              #textline_spliited,
                    --                              self._HorizontalAlignmentMode),
                    nil)

                table.insert(v.wrappedNodes, temp)
                table.insert(self._TextSplitedWrapped, temp)
                temp.parent = v
            end
        end
    end
end

---prevent scroll index bound in element length
---@return number minScroll
---@return number maxScroll
function TextArea:_wrapScroll()
    local minScroll = self._scroll
    minScroll = math.max(minScroll, 1)

    local maxScroll = self._scroll + self.Len.y - 1
    maxScroll = math.min(maxScroll, #(self._TextSplitedWrapped))

    minScroll = math.max(maxScroll - self.Len.y + 1, 1)
    self._scroll = minScroll
    return minScroll, maxScroll
end

--- cut TextSplitedWraped with minScroll and max Scroll
function TextArea:_updateTextSplitedWrapedLine(minScroll, maxScroll)
    self._TextSplitedWrappedLines = {}

    for i = minScroll, maxScroll, 1 do
        table.insert(self._TextSplitedWrappedLines, self._TextSplitedWrapped[i])
    end
end

---make textStpliited lines with TextSplitedWrapedLines to draw immidiatly
function TextArea:_updateTextSplitedViewportLines()
    self._TextSplitedViewportLines = {}

    for index, value in ipairs(self._TextSplitedWrappedLines) do
        local forstring = THIS.UITools.getEmptyString(value.align - 1)
        local backstring = THIS.UITools.getEmptyString(
            self.Len.x - #forstring - #(value.text))
        table.insert(self._TextSplitedViewportLines,
            forstring .. value.text .. backstring)
    end

end

-- update textSplitedWrapedline's horizontal align values
function TextArea:_updateTextSplitedWrapedLineHorizontal()
    for index, value in ipairs(self._TextSplitedWrappedLines) do
        value.align = THIS.UITools.calcHorizontalAlignPos(1, self.Len.x,
            #(value.text),
            self._HorizontalAlignmentMode)
    end
end

-- update vertical rendering anchor based on vertical alignment value
function TextArea:_updateVerticalAlignmentAnchor()
    if (self.Len.y <= #(self._TextSplitedWrapped)) then
        self._VerticalOffset = 1
    else
        self._VerticalOffset = THIS.UITools.calcVerticalAlignPos(1, self.Len.y,
            #(self._TextSplitedWrapped),
            self._VerticalAlignmentMode)
    end
end

---print TextSplittedLines to screen obj
function TextArea:_printTextLines()
    self._screen:setBackgroundColor(self.BG)
    self._screen:setTextColor(self.FG)

    local renderPos = self.Pos:Copy()
    renderPos.y = THIS.UITools.calcRelativeOffset_Raw(renderPos.y,
        self._VerticalOffset)
    for index, value in ipairs(self._TextSplitedViewportLines) do
        self._screen:setCursorPos(renderPos)
        self._screen:write(value)
        renderPos.y = renderPos.y + 1
    end
end

---set text editting pos(relative) and index(in text) with clicked global posigion
---@param clickedGlobalPos MathLib.Vector2
function TextArea:_setTextEdittingPosAndIndex(clickedGlobalPos)
    -- get relative clicked pos in textarea element
    local TextClickedPos = THIS.UITools.transformGlobalPos2LocalPos(
        clickedGlobalPos, self.Pos)

    -- decide where to snap pox.y value by available text vertical offset and vertical length
    local currentYMin, currentYMax = self._VerticalOffset, self._VerticalOffset
    if (#(self._TextSplitedWrapped) >= 1) then
        currentYMin, currentYMax = THIS.UITools.Len2Pos_FromStart(
            self._VerticalOffset,
            #(self._TextSplitedWrappedLines))
    end
    currentYMax = math.min(self.Len.y, currentYMax)

    -- constrain y position to vertical content range
    TextClickedPos.y = THIS.UITools.constrain(TextClickedPos.y, currentYMin,
        currentYMax)

    -- get text viewport index using scroll and pos.y value
    local TextWrappedIndex = THIS.UITools.transformGlobalIndex2LocalIndex(
        TextClickedPos.y, self._VerticalOffset)

    TextWrappedIndex = THIS.UITools.transformLocalIndex2GlobalIndex(
        TextWrappedIndex, self._scroll)

    -- get current text viewport item by index
    local currentTextWrappedItem = self._TextSplitedWrapped[TextWrappedIndex]

    -- decide where to snap pos.x value by available text line length and align pos
    local currentLineXMin, currentLineXMax = currentTextWrappedItem.align,
        currentTextWrappedItem.align
    -- if text legnth is 0, Len2Pos_FromStart function does not fit becuase of \n char is missing
    if (#(currentTextWrappedItem.text) >= 1) then
        currentLineXMin, currentLineXMax =
        THIS.UITools.Len2Pos_FromStart(currentTextWrappedItem.align,
            #(currentTextWrappedItem.text))
    end

    -- constrain x position to line horizontal position range
    TextClickedPos.x = THIS.UITools.constrain(TextClickedPos.x, currentLineXMin,
        currentLineXMax)

    -- get x index in current text wrapped line
    local currentTextViewportLineIndex = THIS.UITools
        .transformGlobalIndex2LocalIndex(
            TextClickedPos.x,
            currentTextWrappedItem.align)

    -- get x index in current text splited line
    local currentTextLineIndex = THIS.UITools.transformLocalIndex2GlobalIndex(
        currentTextViewportLineIndex,
        currentTextWrappedItem.index)

    -- get final x index in whole text including \n char
    local currentTextIndex = THIS.UITools.transformLocalIndex2GlobalIndex(
        currentTextLineIndex,
        currentTextWrappedItem.parent.index)

    self._TextEditIndex = currentTextIndex
end

---action event with texteditting function
---@param isBackspace boolean
---@param isDelete boolean
---@param char? string
---@return nil
function TextArea:_actionAtTextEditIndex(isBackspace, isDelete, char)
    if (isBackspace) then
        if ((self._TextEditIndex <= 1) or (#(self._Text) == 0)) then
            return nil
        else
            self._Text = self._Text:sub(1, self._TextEditIndex - 2) ..
                self._Text:sub(self._TextEditIndex, #(self._Text))
            self._TextEditIndex = self._TextEditIndex - 1
        end
    elseif (isDelete) then
        if (self._TextEditIndex > #(self._Text) or (#(self._Text) <= 0)) then
            return nil
        else
            self._Text = self._Text:sub(1, self._TextEditIndex - 1) ..
                self._Text:sub(self._TextEditIndex + 1,
                    #(self._Text))
            if (self._TextEditIndex > (#(self._Text) + 1)) then
                self._TextEditIndex = #(self._Text) + 1
            end
        end
    else
        self._Text = self._Text:sub(1, self._TextEditIndex - 1) .. (char) ..
            self._Text:sub(self._TextEditIndex, #(self._Text))
        self._TextEditIndex = self._TextEditIndex + 1
    end

    self:_updateTextSplited()
    -- self:_updateTextSplited()
    -- self:_updateTextSplitedViewport()
    -- self:_setTextEditPos(self._TextEditIndex)
end

---set text edit pos bt text edit index value
---@param TextEditIndex number
function TextArea:_setTextEditPos(TextEditIndex)

    ---@type TextArea.TextSplitedNode
    local currentTextSplittedLine = {}
    local currentTextSplittedLineIndex = 1
    local isTextSplittedLastLine = true
    for index, value in ipairs(self._TextSplited) do
        if (value.index > TextEditIndex) then
            currentTextSplittedLine = self._TextSplited[index - 1]
            currentTextSplittedLineIndex = THIS.UITools
                .transformGlobalIndex2LocalIndex(
                    TextEditIndex,
                    currentTextSplittedLine.index)
            isTextSplittedLastLine = false
            break
        end
    end
    if (isTextSplittedLastLine) then
        currentTextSplittedLine = self._TextSplited[#(self._TextSplited)]
        currentTextSplittedLineIndex = THIS.UITools
            .transformGlobalIndex2LocalIndex(
                TextEditIndex,
                currentTextSplittedLine.index)
    end

    ---@type TextArea.WrappedNode
    local currentTextViewportLine = {}
    local currentTextViewportLineIndex = 1
    local isTextViewportLastLine = true

    for index, value in ipairs(currentTextSplittedLine.wrappedNodes) do
        if (value.index > currentTextSplittedLineIndex) then
            currentTextViewportLine =
            currentTextSplittedLine.wrappedNodes[index - 1]
            currentTextViewportLineIndex = THIS.UITools
                .transformGlobalIndex2LocalIndex(
                    currentTextSplittedLineIndex,
                    currentTextViewportLine.index)
            isTextViewportLastLine = false
            break
        end
    end

    if (isTextViewportLastLine) then
        currentTextViewportLine =
        currentTextSplittedLine.wrappedNodes[#(currentTextSplittedLine.wrappedNodes)]
        currentTextViewportLineIndex = THIS.UITools
            .transformGlobalIndex2LocalIndex(
                currentTextSplittedLineIndex,
                currentTextViewportLine.index)
    end

    self._TextEditPos.x = currentTextViewportLineIndex
    for index, value in ipairs(self._TextSplitedWrapped) do
        if (value.parent.index == currentTextViewportLine.parent.index) then
            if (value.index == currentTextViewportLine.index) then
                self._TextEditPos.y = index
                break
            end
        end
    end

end

---change scroll value based on textEditpos in screen
---@param minScroll number
---@param maxScroll number
---@return number newMinScroll
---@return number newMaxScroll
function TextArea:_updateScrollByTextEditPos(minScroll, maxScroll)
    if (minScroll > self._TextEditPos.y) then
        minScroll = minScroll - 1
        maxScroll = maxScroll - 1
        self._scroll = self._scroll - 1
    elseif (maxScroll < self._TextEditPos.y) then
        minScroll = minScroll + 1
        maxScroll = maxScroll + 1
        self._scroll = self._scroll + 1
    end

    return minScroll, maxScroll
end

-- update PosEditCurosPos with renew textSplittedLines and Viewport
function TextArea:_updatePosEditCursorPos()
    local relativePosEditCursorPos = Vector2:new(1, 1)
    relativePosEditCursorPos.y = THIS.UITools.transformGlobalIndex2LocalIndex(
        self._TextEditPos.y, self._scroll)
    relativePosEditCursorPos.y = THIS.UITools.calcRelativeOffset_Raw(
        relativePosEditCursorPos.y,
        self._VerticalOffset)
    local currentwrappedLine = self._TextSplitedWrapped[self._TextEditPos.y]
    if (self._TextEditPos.x == nil) then error("aaaa") end
    if (currentwrappedLine.align == nil) then error("asdf:" ..
            tostring(#(self._TextSplitedWrapped)) .. ":" .. tostring(self._TextEditPos:toString()))
    end
    relativePosEditCursorPos.x = THIS.UITools.transformLocalIndex2GlobalIndex(
        self._TextEditPos.x,
        currentwrappedLine.align)

    self._TextEditCursorPos = relativePosEditCursorPos:Copy()
end

------------------ [overriding functions]---------------

---overrided function from UIElement:render()
function TextArea:render()
    -- textarea cannot have pos rel
    self.PosRel.x = 1
    self.PosRel.y = 1

    -- update global position
    self:_updatePos()

    -- textarea must follow the length of parent
    self:_updateLengthFromParent()

    -- update wrap of splited string with \n
    self:_updateTextSplitedWrapped()

    -- check if scroll index is avilable
    local minScroll, maxScroll = self:_wrapScroll()

    if (self._isTextEditting) then
        -- update internal texteditting pos(x = index in line(str), y = index in wrapped lines)
        self:_setTextEditPos(self._TextEditIndex)
        -- update scroll index to show TextEditPostion cursor in screen
        minScroll, maxScroll = self:_updateScrollByTextEditPos(minScroll,
            maxScroll)
    end

    -- update text splited wraped lines only visible in screen
    self:_updateTextSplitedWrapedLine(minScroll, maxScroll)

    -- update text splited wraped lines horizontal alignment value
    self:_updateTextSplitedWrapedLineHorizontal()

    -- update text visual Vertical anchor based on vertical alignment value
    self:_updateVerticalAlignmentAnchor()

    if (self._isTextEditting) then self:_updatePosEditCursorPos() end

    -- update text splited lines with black " "
    self:_updateTextSplitedViewportLines()

    -- print text splited lines
    self:_printTextLines()

    -- render history add
    self:_addThisToRenderHistory()

    -- render children
    self:renderChildren()
end

---overrided function from UIElement:_ClickEvent
---@param e Tabullet.ClickEventArgs
function TextArea:_ClickEvent(e)

    -- if this text area is texteditable and clicked inside element,
    -- start texteditting mode
    if (self.IsTextEditable == true) then
        if (THIS.UITools.isInsideSquare(self.Pos, self.Len, e.Pos) == true) then
            -- check this event is handled
            e.Handled = true
            if (self._screen.IsMonitor) then
                self._isTextEditting = false
            else
                self:_setTextEdittingPosAndIndex(e.Pos)
                self._isTextEditting = true
            end
        end
    end
end

---overrided function from UIElement:_ScrollEvent
---@param e Tabullet.ScrollEventArgs
function TextArea:_ScrollEvent(e) end

---overrided function from UIElement:_KeyInputEvent
---@param e Tabullet.KeyInputEventArgs
function TextArea:_KeyInputEvent(e)
    local kk = e.Key
    if (self._isTextEditting) then
        if (e.Key == THIS.Enums.Key.enter) then
            self:_actionAtTextEditIndex(false, false, "\n")
        elseif (e.Key == THIS.Enums.Key.backspace) then
            self:_actionAtTextEditIndex(true, false)
        elseif (e.Key == THIS.Enums.Key.delete) then
            self:_actionAtTextEditIndex(false, true)
        end
    end

end

---overrided function from UIElement:_CharEvent
---@param e Tabullet.CharEventArgs
function TextArea:_CharEvent(e)
    -- if this textarea is text editable, input new char in here
    if (self._isTextEditting == true) then
        e.Handled = true
        self:_actionAtTextEditIndex(false, false, e.Char)
    end
end

---overrided function from UIElement:PostRendering()
function TextArea:PostRendering()
    if (self.IsTextEditable and self._isTextEditting) then
        local textEditGlobalPos = THIS.UITools.calcRelativeOffset(self.Pos,
            self._TextEditCursorPos)
        self._screen:setTextColor(self.FG)
        self._screen:setCursorPos(textEditGlobalPos)
        self._screen:setCursorBlink(true)

    else
        self._screen:setCursorBlink(false)
    end
end

---overrided function from UIElement:FocusIn()
function TextArea:FocusIn()
    if (self.IsTextEditable) then self._isTextEditting = true end
end

---overrided function from UIElement:FocusOut()
function TextArea:FocusOut()
    if (self.IsTextEditable) then
        self._isTextEditting = false
        self._screen:setCursorBlink(false)
    end
end

return TextArea
