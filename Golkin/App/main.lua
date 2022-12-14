local TBL = DEPS.Golkin.Tabullet
local AppLib = DEPS.Golkin.AppLib


local THIS = PKGS.Golkin
local protocol = PKGS.Golkin.ENV.CONST.protocol

--- make project global namespace
---@class Golkin.App
local GolkinApp = {}

function GolkinApp:build()
    -- open rednet
    rednet.open(CPKG.rednetSide)

    --- initialize EventRouter
    --- this routes to UI Event and rednet event to other functions
    GolkinApp.EventRouter = AppLib.EventRounter:new()

    --- initialize UIRunner
    --- this runs Scene UI intercation system from EventRouter
    GolkinApp.UIRunner = TBL.UIRunner:new()
    --- attach UIRunner to EventRouter
    GolkinApp.UIRunner:attachToEventRouter(GolkinApp.EventRouter)

    --- initialize Screen objects to use,
    --- can terminal or monitor
    --- side must exist. NONE is terminal
    GolkinApp.Screens = {}
    local main_screen = TBL.Screen:new(peripheral.wrap("left"), TBL.Enums.Side.left)
    GolkinApp.Screens.MainScreen = main_screen
    local computer_screen = TBL.Screen:new(term, TBL.Enums.Side.NONE)
    GolkinApp.Screens.ComputerScreen = computer_screen

    ------------ Param -------------

    -- GolkinApp.Param = require("Golkin.userdata.param")
    GolkinApp.Style = require("Golkin.App.Style.Common")
    GolkinApp.Data = require("Golkin.App.Data")

    ------------ web handle --------
    GolkinApp.Handle = require("Golkin.include.Web.Handle"):new()
    GolkinApp.EventRouter:attachRednetCallback(protocol, function(a, b, c, d)
        -- a: rednet_message, b:sender, c:msg, d:protocol
        -- if (b == serverID) then
        GolkinApp.Handle:parse(c)
        -- end
    end)
    GolkinApp.Client = require("Golkin.include.Web.Client"):new()

    ------------ LAYOUT -----------
    local layout_Cover           = require("Golkin.App.Layout.Cover")
    local layout_Login_BioScan   = require("Golkin.App.Layout.Login_BioScan")
    local layout_Login_List      = require("Golkin.App.Layout.Login_List")
    local layout_PIN             = require("Golkin.App.Layout.PIN")
    local layout_OwnerMenu       = require("Golkin.App.Layout.OwnerMenu")
    local layout_SendMoney       = require("Golkin.App.Layout.SendMoney")
    local layout_SendMoneyName   = require("Golkin.App.Layout.SendMoneyName")
    local layout_Histories       = require("Golkin.App.Layout.Histories")
    local layout_RegisterAccount = require("Golkin.App.Layout.RegisterAccount")
    local layout_ManualTextInput = require("Golkin.App.Layout.ManualTextInput")
    local layout_RemoveAccount   = require("Golkin.App.Layout.RemoveAccount")
    local layout_Addons          = require("Golkin.App.Layout.Addons")


    GolkinApp.Layout                 = {}
    GolkinApp.Layout.Cover           = layout_Cover:new(main_screen, GolkinApp)
    GolkinApp.Layout.Login_BioScan   = layout_Login_BioScan:new(main_screen, GolkinApp)
    GolkinApp.Layout.Login_List      = layout_Login_List:new(main_screen, GolkinApp)
    GolkinApp.Layout.PIN             = layout_PIN:new(main_screen, GolkinApp)
    GolkinApp.Layout.PINCheck        = layout_PIN:new(main_screen, GolkinApp)
    GolkinApp.Layout.OwnerMenu       = layout_OwnerMenu:new(main_screen, GolkinApp)
    GolkinApp.Layout.SendMoney       = layout_SendMoney:new(main_screen, GolkinApp)
    GolkinApp.Layout.SendMoneyName   = layout_SendMoneyName:new(main_screen, GolkinApp)
    GolkinApp.Layout.Histories       = layout_Histories:new(main_screen, GolkinApp)
    GolkinApp.Layout.RegisterAccount = layout_RegisterAccount:new(main_screen, GolkinApp)
    GolkinApp.Layout.RemoveAccount   = layout_RemoveAccount:new(main_screen, GolkinApp)
    GolkinApp.Layout.ManualTextInput = layout_ManualTextInput:new(computer_screen, GolkinApp)
    GolkinApp.Layout.Addons          = layout_Addons:new(main_screen, GolkinApp)

    ------------ SCENE --------------
    GolkinApp.Scene                 = {}
    GolkinApp.Scene.Cover           = require("Golkin.App.Scene.Cover"):new(GolkinApp, GolkinApp.Layout.Cover)
    GolkinApp.Scene.Login_BioScan   = require("Golkin.App.Scene.Login_BioScan"):new(GolkinApp,
        GolkinApp.Layout.Login_BioScan)
    GolkinApp.Scene.Login_List      = require("Golkin.App.Scene.Login_List"):new(GolkinApp, GolkinApp.Layout.Login_List)
    GolkinApp.Scene.PIN             = require("Golkin.App.Scene.PIN"):new(GolkinApp, GolkinApp.Layout.PIN)
    GolkinApp.Scene.PINCheck        = require("Golkin.App.Scene.PINCheck"):new(GolkinApp, GolkinApp.Layout.PINCheck)
    GolkinApp.Scene.OwnerMenu       = require("Golkin.App.Scene.OwnerMenu"):new(GolkinApp, GolkinApp.Layout.OwnerMenu)
    GolkinApp.Scene.SendMoney       = require("Golkin.App.Scene.SendMoney"):new(GolkinApp, GolkinApp.Layout.SendMoney)
    GolkinApp.Scene.SendMoneyName   = require("Golkin.App.Scene.SendMoneyName"):new(GolkinApp,
        GolkinApp.Layout.SendMoneyName)
    GolkinApp.Scene.Histories       = require("Golkin.App.Scene.Histories"):new(GolkinApp, GolkinApp.Layout.Histories)
    GolkinApp.Scene.RegisterAccount = require("Golkin.App.Scene.RegisterAccount"):new(GolkinApp,
        GolkinApp.Layout.RegisterAccount)
    GolkinApp.Scene.RemoveAccount   = require("Golkin.App.Scene.RemoveAccount"):new(GolkinApp,
        GolkinApp.Layout.RemoveAccount)
    GolkinApp.Scene.ManualTextInput = require("Golkin.App.Scene.ManualTextInput"):new(GolkinApp,
        GolkinApp.Layout.ManualTextInput)
    GolkinApp.Scene.Addons          = require("Golkin.App.Scene.Addons"):new(GolkinApp, GolkinApp.Layout.Addons)

    ------------ peripherals --------
    GolkinApp.Peripheral = {}
    ---@type Vef.AP.PlayerDetector
    GolkinApp.Peripheral.PlayerDetector = peripheral.find("playerDetector")

    --- register each screen sides initialize Scene
    GolkinApp.UIRunner:attachScene(GolkinApp.Scene.ManualTextInput)
    GolkinApp.UIRunner:attachScene(GolkinApp.Scene.Cover)

    --- set initial scene to start interact
    GolkinApp.UIRunner:setIntialScene(TBL.Enums.Side.left)


    -----------------------------------

end

---start app
function GolkinApp:start()
    --- clear and render initial scenes
    self.UIRunner:ClearScreens()
    self.UIRunner:RenderScreen()
    self.UIRunner:Reflect2Screen()

    --- run main EventLoop to start Proj
    self.EventRouter:main()
end

---add addon button to application
---@param button Tabullet.Button
---@param func fun(self:Golkin.App.Layout.Addons)
function GolkinApp:add_addon(button, func)
    self.Layout.Addons:add_addon_bt(button, func)
end

return GolkinApp
