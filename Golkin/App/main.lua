local TBL = DEPS.Golkin.Tabullet
local AppLib = DEPS.Golkin.AppLib


local THIS = PKGS.Golkin
local client = THIS.Web.Client:new()
-- local serverID = client:getServerID()
local protocol = PKGS.Golkin.ENV.CONST.protocol





--- make project global namespace
---@class Golkin.App
local GolkinApp = {}

----- build app
function GolkinApp:build()
    -- open rednet
    rednet.open(CPKG.rednetSide)

    --- initialize EventRouter
    --- this routes to UI Event and rednet event to other functions
    self.EventRouter = AppLib.EventRounter:new()

    --- initialize UIRunner
    --- this runs Scene UI intercation system from EventRouter
    self.UIRunner = TBL.UIRunner:new()
    --- attach UIRunner to EventRouter
    self.UIRunner:attachToEventRouter(self.EventRouter)

    --- initialize Screen objects to use,
    --- can terminal or monitor
    --- side must exist. NONE is terminal
    self.Screens = {}

    local main_screen = TBL.Screen:new(peripheral.wrap("left"), TBL.Enums.Side.left)
    self.Screens.MainScreen = main_screen
    -- local main_screen = TBL.Screen:new(term, TBL.Enums.Side.NONE)
    local computer_screen = TBL.Screen:new(term, TBL.Enums.Side.NONE)
    self.Screens.ComputerScreen = computer_screen
    ------------ Param -------------

    self.Param = require("Golkin.userdata.param")
    self.Style = require("Golkin.App.Style.Common")
    self.Data = require("Golkin.App.Data")

    ------------ web handle --------
    self.Handle = require("Golkin.include.Web.Handle"):new()
    self.EventRouter:attachRednetCallback(protocol, function(a, b, c, d)
        -- a: rednet_message, b:sender, c:msg, d:protocol
        -- if (b == serverID) then
        self.Handle:parse(c)
        -- end
    end)
    self.Client = client

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


    self.Layout                 = {}
    self.Layout.Cover           = layout_Cover:new(main_screen, self)
    self.Layout.Login_BioScan   = layout_Login_BioScan:new(main_screen, self)
    self.Layout.Login_List      = layout_Login_List:new(main_screen, self)
    self.Layout.PIN             = layout_PIN:new(main_screen, self)
    self.Layout.PINCheck        = layout_PIN:new(main_screen, self)
    self.Layout.OwnerMenu       = layout_OwnerMenu:new(main_screen, self)
    self.Layout.SendMoney       = layout_SendMoney:new(main_screen, self)
    self.Layout.SendMoneyName   = layout_SendMoneyName:new(main_screen, self)
    self.Layout.Histories       = layout_Histories:new(main_screen, self)
    self.Layout.RegisterAccount = layout_RegisterAccount:new(main_screen, self)
    self.Layout.RemoveAccount   = layout_RemoveAccount:new(main_screen, self)
    self.Layout.ManualTextInput = layout_ManualTextInput:new(computer_screen, self)
    self.Layout.Addons          = layout_Addons:new(main_screen, self)

    ------------ SCENE --------------
    self.Scene                 = {}
    self.Scene.Cover           = require("Golkin.App.Scene.Cover"):new(self, self.Layout.Cover)
    self.Scene.Login_BioScan   = require("Golkin.App.Scene.Login_BioScan"):new(self,
        self.Layout.Login_BioScan)
    self.Scene.Login_List      = require("Golkin.App.Scene.Login_List"):new(self, self.Layout.Login_List)
    self.Scene.PIN             = require("Golkin.App.Scene.PIN"):new(self, self.Layout.PIN)
    self.Scene.PINCheck        = require("Golkin.App.Scene.PINCheck"):new(self, self.Layout.PINCheck)
    self.Scene.OwnerMenu       = require("Golkin.App.Scene.OwnerMenu"):new(self, self.Layout.OwnerMenu)
    self.Scene.SendMoney       = require("Golkin.App.Scene.SendMoney"):new(self, self.Layout.SendMoney)
    self.Scene.SendMoneyName   = require("Golkin.App.Scene.SendMoneyName"):new(self,
        self.Layout.SendMoneyName)
    self.Scene.Histories       = require("Golkin.App.Scene.Histories"):new(self, self.Layout.Histories)
    self.Scene.RegisterAccount = require("Golkin.App.Scene.RegisterAccount"):new(self,
        self.Layout.RegisterAccount)
    self.Scene.RemoveAccount   = require("Golkin.App.Scene.RemoveAccount"):new(self,
        self.Layout.RemoveAccount)
    self.Scene.ManualTextInput = require("Golkin.App.Scene.ManualTextInput"):new(self,
        self.Layout.ManualTextInput)
    self.Scene.Addons          = require("Golkin.App.Scene.Addons"):new(self, self.Layout.Addons)

    ------------ peripherals --------
    self.Peripheral = {}
    ---@type Vef.AP.PlayerDetector
    self.Peripheral.PlayerDetector = peripheral.find(self.Param.PlayerDetectorName)

    --- register each screen sides initialize Scene
    self.UIRunner:attachScene(self.Scene.ManualTextInput)
    self.UIRunner:attachScene(self.Scene.Cover)

    --- set initial scene to start interact
    self.UIRunner:setIntialScene(TBL.Enums.Side.left)
end

-----------------------------------

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
