local class = require("Class.middleclass")

local TBL = DEPS.Golkin.Tabullet
local THIS = PKGS.Golkin
local protocol = THIS.Web.Protocol

---@class Golkin.App.Scene.PIN : Tabullet.UIScene
---@field Layout Golkin.App.Layout.PIN
---@field PROJ Golkin.App
---@field Event_bt_back fun(PIN:Golkin.App.Scene.PIN)
---@field Event_bt_enter fun(PIN:Golkin.App.Scene.PIN)
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Golkin.App, UILayout:Tabullet.UILayout):Golkin.App.Scene.PIN
local SCENE = class("Golkin.App.Scene.PIN", TBL.UIScene)

---constructor
---@param ProjNamespace Golkin.App
---@param UILayout Golkin.App.Layout.PIN
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    for i = 1, 9, 1 do
        self.Layout.bts_numpad[i].ClickEvent = function(obj, e)
            if e.Button == TBL.Enums.MouseButton.left then
                self:cb_bt_numpad(i)
            end
        end
    end

    self.Layout.bts_numpad[10].ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_numpad(0)
        end
    end

    self.Layout.bt_numpad_backspace.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_backspace()
        end
    end

    self.Layout.bt_numpad_reset.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:cb_bt_numpad_reset()
        end
    end

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self.Event_bt_back(self)
        end
    end

    self.Layout.bt_enter_pin.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            -- self:cb_bt_enter_pin()
            self.Event_bt_enter(self)
        end
    end

    self.password = ""
    self.maximumCount = 8

    ---@type fun(PIN:Golkin.App.Scene.PIN)
    self.Event_bt_back = function(PIN) end
    ---@type fun(PIN:Golkin.App.Scene.PIN)
    self.Event_bt_enter = function(PIN) end
end

---set info string normal
---@param string string
function SCENE:infoStr_normal(string)
    self.Layout.tb_info:setText(string)
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
end

---set info string failure
---@param string string
function SCENE:infoStr_error(string)
    self.Layout.tb_info:setText(string)
    self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
end

---set info string success
---@param string string
function SCENE:infoStr_success(string)
    self.Layout.tb_info:setText(string)
    self.PROJ.Style.TB.InfoSuccess(self.Layout.tb_info)
end

function SCENE:cb_bt_numpad(number)
    if #self.password >= self.maximumCount then
        return nil
    else
        self.password = self.password .. tostring(number)
        self:refresh_PINDisplay()
    end
end

function SCENE:cb_bt_backspace()
    if #self.password <= 0 then
        return nil
    else
        self.password = self.password:sub(1, #self.password - 1)
        self:refresh_PINDisplay()
    end
end

function SCENE:cb_bt_numpad_reset()
    self.password = ""
    self:refresh_PINDisplay()
end

function SCENE:refresh_PINDisplay()
    local t = ""
    for i = 1, #self.password, 1 do
        t = t .. "* "
    end
    if #self.password >= 1 then
        t = t:sub(1, #t - 1)
    end
    self.Layout.tb_passwd_display:setText(t)

    if #self.password >= 0 and #self.password <= 3 then
        self.Layout.bt_enter_pin.Visible = false
    elseif #self.password >= 4 then
        self.Layout.bt_enter_pin.Visible = true
    end
end

function SCENE:reset()
    self.password = ""
    self:refresh_PINDisplay()

    -- elseif self.CurrentPrevScene == self.ePrevScene.SendMoney then
    --     self.Layout.tb_info:setText("Enter your Account PIN")
    --     self.PROJ.Style.TB.Info(self.Layout.tb_info)
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
