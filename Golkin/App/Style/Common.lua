local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Style.Common
local a = {}

a.TB = {}

---vertical center, hori center
---@param tb Tabullet.TextBlock
function a.TB.ToCenter(tb)
    tb:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.center)
    tb:setTextVerticalAlignment(TBL.Enums.VerticalAlignmentMode.center)
end

---get list title textblock style
---@param tb Tabullet.TextBlock
function a.TB.ListTitle(tb)
    a.TB.ToCenter(tb)
    tb:setBackgroundColor(TBL.Enums.Color.purple)
    tb:setTextColor(TBL.Enums.Color.white)

end

---get info textblock style
---@param tb Tabullet.TextBlock
function a.TB.Info(tb)
    a.TB.ToCenter(tb)
    tb:setBackgroundColor(TBL.Enums.Color.lime)
    tb:setTextColor(TBL.Enums.Color.black)
end

---get success info style textblock
---@param tb Tabullet.TextBlock
function a.TB.InfoSuccess(tb)
    a.TB.ToCenter(tb)
    tb:setBackgroundColor(TBL.Enums.Color.green)
    tb:setTextColor(TBL.Enums.Color.white)
end

---get waring info style textblock
---@param tb Tabullet.TextBlock
function a.TB.InfoWarning(tb)
    a.TB.ToCenter(tb)
    tb:setBackgroundColor(TBL.Enums.Color.orange)
    tb:setTextColor(TBL.Enums.Color.black)
end

---get fail info style textblock
---@param tb Tabullet.TextBlock
function a.TB.InfoFail(tb)
    a.TB.ToCenter(tb)
    tb:setBackgroundColor(TBL.Enums.Color.red)
    tb:setTextColor(TBL.Enums.Color.black)
end

---style for scene title
---@param bt Tabullet.TextBlock
function a.TB.title(bt)
    a.TB.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.yellow)
    bt:setTextColor(TBL.Enums.Color.black)
end

---type for info name
---@param bt Tabullet.TextBlock
function a.TB.infoName(bt)
    bt:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.left)
    bt:setTextVerticalAlignment(TBL.Enums.VerticalAlignmentMode.center)
    bt:setBackgroundColor(TBL.Enums.Color.green)
    bt:setTextColor(TBL.Enums.Color.white)
end

---type for info name
---@param bt Tabullet.TextBlock
function a.TB.infoContent(bt)
    bt:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.left)
    bt:setTextVerticalAlignment(TBL.Enums.VerticalAlignmentMode.center)
    bt:setBackgroundColor(TBL.Enums.Color.lightBlue)
    bt:setTextColor(TBL.Enums.Color.white)
end

---type for info content when editted
---@param bt Tabullet.TextBlock
function a.TB.infoContentEdit(bt)
    a.TB.infoContent(bt)
    bt:setBackgroundColor(TBL.Enums.Color.blue)
    bt:setTextColor(TBL.Enums.Color.black)
end

a.BT = {}
---vertical center, hori center
---@param bt Tabullet.Button
function a.BT.ToCenter(bt)
    bt:setTextHorizontalAlignment(TBL.Enums.HorizontalAlignmentMode.center)
    bt:setTextVerticalAlignment(TBL.Enums.VerticalAlignmentMode.center)
end

---good button style
---@param bt Tabullet.Button
function a.BT.Good(bt)
    a.BT.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.green)
    bt:setTextColor(TBL.Enums.Color.white)
end

---bad button style
---@param bt Tabullet.Button
function a.BT.Bad(bt)
    a.BT.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.red)
    bt:setTextColor(TBL.Enums.Color.white)
end

---style for page flow button
---@param bt Tabullet.Button
function a.BT.Back(bt)
    a.BT.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.lightGray)
    bt:setTextColor(TBL.Enums.Color.white)
end

---style for function button
---@param bt Tabullet.Button
function a.BT.func(bt)
    a.BT.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.lightBlue)
    bt:setTextColor(TBL.Enums.Color.white)
end

---style for keypad button
---@param bt Tabullet.Button
function a.BT.keypad(bt)
    a.BT.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.white)
    bt:setTextColor(TBL.Enums.Color.black)
end

---style for hyperlink button
---@param bt Tabullet.Button
function a.BT.Hyperlink(bt)
    a.BT.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.None)
    bt:setTextColor(TBL.Enums.Color.blue)
end

---style for important function
---@param bt Tabullet.Button
function a.BT.ImportantFunc(bt)
    a.BT.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.cyan)
    bt:setTextColor(TBL.Enums.Color.white)
end

a.LB = {}

---style for listbox fancy content
---@param lb Tabullet.ListBox
function a.LB.Content(lb)
    lb:setOddIndexBG(TBL.Enums.Color.lightBlue)
    lb:setOddIndexFG(TBL.Enums.Color.black)
    lb:setEvenIndexBG(TBL.Enums.Color.white)
    lb:setEvenIndexFG(TBL.Enums.Color.black)
    lb:setSelectedIndexBG(TBL.Enums.Color.cyan)
    lb:setSelectedIndexFG(TBL.Enums.Color.white)
end

---make mainframe infopanel
---@param infoName string
---@param rootCanvasScreen Tabullet.ScreenCanvas rootCanvasScreen of layout
---@param attachedScreen Tabullet.Screen attachedScreen to layout
---@return Tabullet.TextBlock infoname_tb
---@return Tabullet.TextBlock infocontent_tb
---@return integer infoname_length
function a.make_infoPanel_pair(infoName, rootCanvasScreen, attachedScreen)
    local tb_infoname = TBL.TextBlock:new(rootCanvasScreen, attachedScreen, "bt_infoname_" .. infoName)
    tb_infoname:setText(infoName)
    a.TB.infoName(tb_infoname)
    tb_infoname:setMarginLeft(1)
    tb_infoname:setMarginRight(1)

    local tb_infocontent = TBL.TextBlock:new(rootCanvasScreen, attachedScreen, "bt_infocontent_" .. infoName)
    a.TB.infoContent(tb_infocontent)
    tb_infocontent:setMarginLeft(1)
    tb_infocontent:setMarginRight(1)

    return tb_infoname, tb_infocontent, #infoName + 2
end

a.STR = {}

---convert to balance string
---@param str string
function a.STR.Balance(str)
    local isMinus = false
    if str:sub(1, 1) == "-" then
        isMinus = true
        str = str:sub(2, #str)
    end

    local result = str:sub(-3, -1)
    local i = 2
    while true do
        local str_ = str:sub(-(3 * i), -(3 * i - 2))
        if str_ == "" then
            break
        end
        result = str_ .. "," .. result
        i = i + 1
    end

    if isMinus then
        result = "-" .. result
    end
    return result
end

return a
