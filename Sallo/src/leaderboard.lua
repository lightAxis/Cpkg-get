require("Sallo.pkg_init")
local AppLib = require("AppLib.pkg_init")
local TBL = require("Tabullet.pkg_init")
local sallo_param = PKGS.Sallo.Param

local app = {}
app.EventRouter = AppLib.EventRounter:new()
app.UIRunner = TBL.UIRunner:new()
app.UIRunner:attachToEventRouter(app.EventRouter)

app.Style = require("Golkin.App.Style.Common")

app.Sallo = {}
app.Sallo.Client = require("Sallo.include.Web.Client"):new()
app.Sallo.Handle = require("Sallo.include.Web.Handle"):new()
app.EventRouter:attachRednetCallback(sallo_param.Web.protocol, function(a, b, c, d)
    app.Sallo.Handle:parse(c)
end)

local mon    = TBL.Screen:new(peripheral.wrap("left"), TBL.Enums.Side.left)
local layout = require("Sallo.App.layout.LeaderboardBig"):new(mon, app)
local scene  = require("Sallo.App.scene.Leaderboard"):new(app, layout)

app.UIRunner:attachScene(scene)
app.UIRunner:setIntialScene("left")
scene:reset()
app.UIRunner:ReDrawAll()

app.EventRouter:main()
