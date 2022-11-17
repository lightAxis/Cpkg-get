require("Tabullet.pkg_init")

local THIS = PKGS.Tabullet
local AppLib = DEPS.Tabullet.AppLib

--- make project global namespace
---@class ProjTemplate
local ProjTemplate = {}

--- initialize EventRouter
--- this routes to UI Event and rednet event to other functions
ProjTemplate.EventRouter = AppLib.EventRounter:new()

--- initialize UIRunner
--- this runs Scene UI intercation system from EventRouter
ProjTemplate.UIRunner = THIS.UIRunner:new()
--- attach UIRunner to EventRouter
ProjTemplate.UIRunner:attachToEventRouter(ProjTemplate.EventRouter)

--- initialize Screen objects to use,
--- can terminal or monitor
--- side must exist. NONE is terminal
local screen_term = THIS.Screen:new(term, THIS.Enums.Side.NONE)
local screen_left = THIS.Screen:new(peripheral.wrap("left"),
    THIS.Enums.Side.left)

------------ SCENENS -----------

--- register Project SceneFile to other
local SCENENAME1 = require("Tabullet.test.Scenes.SCENENAME1")
local SCENENAME2 = require("Tabullet.test.Scenes.SCENENAME2")
local SCENENAME3 = require("Tabullet.test.Scenes.SCENENAME3")
local SCENENAME1_L = require("Tabullet.test.Scenes.SCENENAME1_L")
local SCENENAME2_L = require("Tabullet.test.Scenes.SCENENAME2_L")
local SCENENAME3_L = require("Tabullet.test.Scenes.SCENENAME3_L")

--- register Project Scene Instance to Project global namespace
ProjTemplate.SCENENAME1 = SCENENAME1:new(ProjTemplate, SCENENAME1_L:new(screen_term, ProjTemplate))
ProjTemplate.SCENENAME2 = SCENENAME2:new(ProjTemplate, SCENENAME2_L:new(screen_term, ProjTemplate))
ProjTemplate.SCENENAME3 = SCENENAME3:new(ProjTemplate, SCENENAME3_L:new(screen_term, ProjTemplate))

ProjTemplate.SCENENAME1_t = SCENENAME1:new(ProjTemplate, SCENENAME1_L:new(screen_left, ProjTemplate))
ProjTemplate.SCENENAME2_t = SCENENAME2:new(ProjTemplate, SCENENAME2_L:new(screen_left, ProjTemplate))
ProjTemplate.SCENENAME3_t = SCENENAME3:new(ProjTemplate, SCENENAME3_L:new(screen_left, ProjTemplate))

--- register each screen sides initialize Scene
ProjTemplate.UIRunner:attachScene(ProjTemplate.SCENENAME1)
ProjTemplate.UIRunner:attachScene(ProjTemplate.SCENENAME1_t)

--- set initial scene to start interact if you want
--- otherwise, initally attached scene's rootScreenCanvas will be the first FocusedElement
-- ProjTemplate.UIRunner:setIntialScene(JLib.Enums.Side.NONE)

-----------------------------------

--- clear and readner initial scenes
ProjTemplate.UIRunner:ClearScreens()
ProjTemplate.UIRunner:RenderScreen()
ProjTemplate.UIRunner:Reflect2Screen()

--- run main EventLoop to start Proj
ProjTemplate.EventRouter:main()
