local class = require("Class.middleclass")


--- include
local THIS = PKGS.Tabullet
local Vector2 = DEPS.Tabullet.MathLib.Vector2
local AppLib = DEPS.Tabullet.AppLib

---properties description
---@class Tabullet.UIRunner
---@field FocusedElement Tabullet.UIElement
---@field Scenes table<Tabullet.Enums.Side, Tabullet.UIScene>
---@field new fun(self:Tabullet.UIRunner, initialFocusedElement?:Tabullet.UIElement):Tabullet.UIRunner


---public class UIRunner
---@class Tabullet.UIRunner
local UIRunner = class("Tabullet.UIRunner")


---constructor
---@param initialFocusedElement? Tabullet.UIElement
function UIRunner:initialize(initialFocusedElement)
    self.FocusedElement = initialFocusedElement
    ---@type table<Tabullet.Enums.Side, Tabullet.UIScene>
    self.Scenes = {}
end

---attache scene to side
---@param scene Tabullet.UIScene
function UIRunner:attachScene(scene)
    self.Scenes[scene.Layout.attachingScreen:getScreenSide()] = scene
    if (self.FocusedElement == nil) then
        self.FocusedElement = scene.Layout.rootScreenCanvas
    end
end

---remove scene from side
---@param scene Tabullet.UIScene
function UIRunner:detachScene(scene)
    self.Scenes[scene.Layout.attachingScreen:getScreenSide()] = nil
end

---change scene of side
---@param scene Tabullet.UIScene
function UIRunner:changeScene(scene)
    self.Scenes[scene.Layout.attachingScreen:getScreenSide()] = scene
    self:ClearScreens()
    self:RenderScreen()
end

---set initial scene from side
---@param side Tabullet.Enums.Side
function UIRunner:setIntialScene(side)
    self.FocusedElement = self.Scenes[side].Layout.rootScreenCanvas
end

function UIRunner:ClearScreens()
    for key, value in pairs(self.Scenes) do
        value.Layout.attachingScreen:clearScreen()
    end
end

function UIRunner:ClearRenderHistories()
    for key, value in pairs(self.Scenes) do
        value.Layout.attachingScreen:clearRenderHistory()
    end
end

function UIRunner:RenderScreen()
    for key, value in pairs(self.Scenes) do value.Layout.rootScreenCanvas:render() end
end

function UIRunner:Reflect2Screen()
    for key, value in pairs(self.Scenes) do value.Layout.rootScreenCanvas:Reflect2Screen() end
end

function UIRunner:PostRendering() self.FocusedElement:PostRendering() end

---attach UIRunner to this Router
---@param router AppLib.EventRounter
function UIRunner:attachToEventRouter(router)

    router:attachEventCallback(AppLib.EventEnum.mouse_click, function(a, b,
                                                                      c, d)
        self:MouseClickEventCallback(a, b, c, d)
    end)

    router:attachEventCallback(AppLib.EventEnum.mouse_scroll, function(a,
                                                                       b,
                                                                       c, d)
        self:ScrollEventCallback(a, b, c, d)
    end)

    router:attachEventCallback(AppLib.EventEnum.key, function(a, b, c, d)
        self:KeyInputEventCallback(a, b, c, d)
    end)

    router:attachEventCallback(AppLib.EventEnum.char, function(a, b, c, d)
        self:CharEventCallback(a, b, c, d)
    end)

    router:attachEventCallback(AppLib.EventEnum.monitor_touch, function(a,
                                                                        b,
                                                                        c,
                                                                        d)
        self:MonitorTouchEventCallback(a, b, c, d)
    end)

end

function UIRunner:ReDrawAll()
    self:ClearScreens()
    self:ClearRenderHistories()
    self:RenderScreen()
    self:Reflect2Screen()
    self:PostRendering()
end

---Char event callback function for EventRouter
---@param event AppLib.EventEnum
---@param char string
---@param _ nil
---@param __ nil
function UIRunner:CharEventCallback(event, char, _, __)
    self.FocusedElement:triggerCharEvent(char)

    self:ReDrawAll()
end

---mouse click event function for EventRouter
---@param event AppLib.EventEnum
---@param button Tabullet.Enums.MouseButton
---@param x number
---@param y number
function UIRunner:MouseClickEventCallback(event, button, x, y)
    if (button == 1) then
        local pos = Vector2:new(x, y)
        local focusedScreen = self.Scenes[THIS.Enums.Side.NONE].Layout.attachingScreen
        -- print(focusedScreen, "aaaa")
        -- print(focusedScreen._side, "aaaa")
        local clickedElement = focusedScreen:getUIAtPos(pos)
        -- print(clickedElement, "aaaa3")
        if (clickedElement ~= self.FocusedElement) then
            self.FocusedElement:FocusOut()
            clickedElement:FocusIn()
        end
        clickedElement:triggerClickEvent(button, pos)
        self.FocusedElement = clickedElement
    end

    self:ReDrawAll()
end

---key input event function for EventRouter
---@param event AppLib.EventEnum
---@param key Tabullet.Enums.Key
---@param isShiftPressed boolean
---@param _ nil
function UIRunner:KeyInputEventCallback(event, key, isShiftPressed, _)
    self.FocusedElement:triggerKeyInputEvent(key)

    self:ReDrawAll()
end

---scroll event function for EventRouter
---@param event AppLib.EventEnum
---@param direction Tabullet.Enums.ScrollDirection
---@param x number
---@param y number
function UIRunner:ScrollEventCallback(event, direction, x, y)
    local focusedScreen = self.Scenes[THIS.Enums.Side.NONE].Layout.attachingScreen
    local pos = Vector2:new(x, y)
    -- print(x, y, "aaaa123")
    local scrolledElement = focusedScreen:getUIAtPos(pos)
    scrolledElement:triggerScrollEvent(direction, pos)

    self:ReDrawAll()
end

---monitor touch event function for EventRouter
---@param event AppLib.EventEnum
---@param side Tabullet.Enums.Side
---@param x number
---@param y number
function UIRunner:MonitorTouchEventCallback(event, side, x, y)
    local focusedScreen = self.Scenes[side].Layout.attachingScreen
    local pos = Vector2:new(x, y)
    local touchedElement = focusedScreen:getUIAtPos(pos)
    if (touchedElement ~= self.FocusedElement) then
        touchedElement:FocusIn()
        self.FocusedElement:FocusOut()
    end
    touchedElement:triggerClickEvent(THIS.Enums.MouseButton.left, pos)

    self:ReDrawAll()
end

return UIRunner
