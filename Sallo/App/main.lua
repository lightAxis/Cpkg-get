local TBL = DEPS.Sallo.Tabullet
local GOL = DEPS.Sallo.Golkin



---@class Sallo.App : Golkin.App
local app = GOL.App

local Sallo = {}
Sallo.Layout = {}
Sallo.Layout.InfoMenu = require("Sallo.App.layout.InfoMenu"):new(app.Screens.MainScreen, app)

Sallo.Scene = {}
Sallo.Scene.InfoMenu = require("Sallo.App.scene.InfoMenu"):new(app, Sallo.Layout.InfoMenu)

Sallo.Data = {}

app.Sallo = Sallo

local bt_sallo = TBL.Button:new(app.Layout.Addons.rootScreenCanvas, app.Layout.Addons.attachingScreen, "bt_name")
bt_sallo:setText("Sallo")
app.Style.BT.Good(bt_sallo)
app:add_addon(bt_sallo,
    function(obj)
        -- for test
        app.Scene.Addons:detach_handelers()
        app.Sallo.Scene.InfoMenu:reset()
        app.UIRunner:attachScene(app.Sallo.Scene.InfoMenu)
    end)



return app
