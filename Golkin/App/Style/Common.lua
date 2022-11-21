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
    tb:setTextColor(TBL.Enums.Color.black)
    tb:setBackgroundColor(TBL.Enums.Color.purple)
end

---get info textblock style
---@param tb Tabullet.TextBlock
function a.TB.Info(tb)
    a.TB.ToCenter(tb)
    tb:setTextColor(TBL.Enums.Color.black)
    tb:setBackgroundColor(TBL.Enums.Color.cyan)
end

---style for scene title
---@param bt Tabullet.TextBlock
function a.TB.title(bt)
    a.TB.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.yellow)
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
    bt:setTextColor(TBL.Enums.Color.red)
end

---style for page flow button
---@param bt Tabullet.Button
function a.BT.Back(bt)
    a.BT.ToCenter(bt)
    bt:setBackgroundColor(TBL.Enums.Color.lightGray)
    bt:setTextColor(TBL.Enums.Color.black)
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

return a
