local TBL = DEPS.Golkin.Tabullet
local AppLib = DEPS.Golkin.AppLib


--- make project global namespace
---@class Golkin.App
GolkinApp = {}

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
local screen_mon = TBL.Screen:new(peripheral.wrap("left"),
    TBL.Enums.Side.left)

------------ Param -------------

GolkinApp.Param = require("Golkin.App.param")
GolkinApp.Style = require("Golkin.App.Style.Common")

------------ LAYOUT -----------
local layout_Cover         = require("Golkin.App.Layout.Cover")
local layout_Login_BioScan = require("Golkin.App.Layout.Login_BioScan")
local layout_Login_List    = require("Golkin.App.Layout.Login_List")

GolkinApp.Layout               = {}
GolkinApp.Layout.Cover         = layout_Cover:new(screen_mon, GolkinApp)
GolkinApp.Layout.Login_BioScan = layout_Login_BioScan:new(screen_mon, GolkinApp)
GolkinApp.Layout.Login_List    = layout_Login_List:new(screen_mon, GolkinApp)

------------ SCENE --------------
GolkinApp.Scene               = {}
GolkinApp.Scene.Cover         = require("Golkin.App.Scene.Cover"):new(GolkinApp, GolkinApp.Layout.Cover)
GolkinApp.Scene.Login_BioScan = require("Golkin.App.Scene.Login_BioScan"):new(GolkinApp, GolkinApp.Layout.Login_BioScan)
GolkinApp.Scene.Login_List    = require("Golkin.App.Scene.Login_List"):new(GolkinApp, GolkinApp.Layout.Login_List)

------------ peripherals --------
GolkinApp.Peripheral = {}
---@type Vef.AP.PlayerDetector
GolkinApp.Peripheral.PlayerDetector = peripheral.find(GolkinApp.Param.PlayerDetectorName)


--- register each screen sides initialize Scene
GolkinApp.UIRunner:attachScene(GolkinApp.Scene.Cover)

--- set initial scene to start interact
GolkinApp.UIRunner:setIntialScene(TBL.Enums.Side.left)

-----------------------------------

--- clear and render initial scenes
GolkinApp.UIRunner:ClearScreens()
GolkinApp.UIRunner:RenderScreen()

--- run main EventLoop to start Proj
GolkinApp.EventRouter:main()
