local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet

---@class Golkin.App.Layout.PIN : Tabullet.UILayout
---@field PROJ Golkin.App
---@field new fun(self:Tabullet.UIScene, attachedScreen:Tabullet.Screen, projNamespace:Golkin.App):Golkin.App.Layout.PIN
local SCENE_L = class("Golkin.App.Layout.PIN", TBL.UILayout)

---constructor
---@param attachedScreen Tabullet.Screen
---@param projNamespace Golkin.App
function SCENE_L:initialize(attachedScreen, projNamespace)
    TBL.UILayout.initialize(self, attachedScreen, projNamespace)

    --- main grid
    local grid = TBL.Grid:new(self.rootScreenCanvas.Len)
    grid:setHorizontalSetting({ "*", "1", "*", "1", "*" })
    grid:setVerticalSetting({ "1", "1", "*", "3" })
    grid:updatePosLen()
    self.grid = grid

    --- title block
    local title_textblock = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "title_textblock")
    grid:setPosLen(title_textblock, 1, 1, 5, 1)
    title_textblock:setText("PIN")
    self.PROJ.Style.TB.title(title_textblock)
    self.tb_title = title_textblock

    --- info block
    local info_tb = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "info_textblock")
    grid:setPosLen(info_tb, 1, 2, 5, 1)
    info_tb:setText("Enter your PIN")
    self.PROJ.Style.TB.Info(info_tb)
    self.tb_info = info_tb

    --- bt back
    local bt_back = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_back")
    bt_back:setText("Back")
    grid:setPosLen(bt_back, 1, 4)
    self.PROJ.Style.BT.Back(bt_back)
    self.bt_back = bt_back

    --- bt enter pin
    local bt_enter_pin = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen,
        "bt_enter_pin")
    bt_enter_pin:setText("Done")
    grid:setPosLen(bt_enter_pin, 5, 4)
    self.PROJ.Style.BT.func(bt_enter_pin)
    self.bt_enter_pin = bt_enter_pin

    -- grid for password
    local grid_passwd = grid:genSubGrid(nil, 1, 3, 5, 1)
    grid_passwd:setHorizontalSetting({ "*" })
    grid_passwd:setVerticalSetting({ "5", "*" })
    grid_passwd:updatePosLen()
    self.grid_passwd = grid_passwd

    -- grid for password
    local grid_passwd_display = grid_passwd:genSubGrid(nil, 1, 1)
    grid_passwd_display:setHorizontalSetting({ "*", "4*", "*" })
    grid_passwd_display:setVerticalSetting({ "*", "3" })
    grid_passwd_display:updatePosLen()
    self.grid_passwd_display = grid_passwd_display

    -- textblock for passwd display
    local tb_passwd_display = TBL.TextBlock:new(self.rootScreenCanvas, self.attachingScreen, "bt_passwd_display")
    grid_passwd_display:setPosLen(tb_passwd_display, 2, 2)
    self.PROJ.Style.TB.ListTitle(tb_passwd_display)
    self.tb_passwd_display = tb_passwd_display

    -- grid for password numpads
    local grid_passwd_numpads = grid_passwd:genSubGrid(nil, 1, 2)
    grid_passwd_numpads:setHorizontalSetting({ "*", "3", "1", "3", "1", "3", "1", "3", "1", "3", "2", "3", "*" })
    grid_passwd_numpads:setVerticalSetting({ "*", "1", "1", "1", "*" })
    grid_passwd_numpads:updatePosLen()
    self.grid_passwd_numpads = grid_passwd_numpads

    -- button list numpads
    ---@type table<number, Tabullet.Button>
    local bts_numpad = {}
    for i = 1, 10, 1 do

        local displayNum = i
        if (i == 10) then
            displayNum = 0
        end
        local numpad = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_numpad_" .. tostring(displayNum))
        numpad:setText(tostring(displayNum))

        local hori_i
        local vert_i
        if (i <= 5) then
            hori_i = i * 2
            vert_i = 2
        else
            hori_i = i * 2 - 10
            vert_i = 4
        end
        grid_passwd_numpads:setPosLen(numpad, hori_i, vert_i)

        self.PROJ.Style.BT.keypad(numpad)
        table.insert(bts_numpad, numpad)
    end
    self.bts_numpad = bts_numpad

    -- button numpad backspace
    local bt_numpad_backspace = TBL.Button:new(self.rootScreenCanvas, self.attachingScreen, "bt_numpad_backspace")
    grid_passwd_numpads:setPosLen(bt_numpad_backspace, 12, 2)
    bt_numpad_backspace:setText("<")
    self.PROJ.Style.BT.keypad(bt_numpad_backspace)
    self.bt_numpad_backspace = bt_numpad_backspace

end

return SCENE_L
