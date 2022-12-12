local TBL = DEPS.Sallo.Tabullet
local GOL = DEPS.Sallo.Golkin

local sallo_param = require("Sallo.include.Param.param")

---@class Sallo.App : Golkin.App
local app = GOL.App

local Sallo = {}
Sallo.Layout = {}
Sallo.Layout.InfoMenu = require("Sallo.App.layout.InfoMenu"):new(app.Screens.MainScreen, app)
Sallo.Layout.TransferAccount = require("Sallo.App.layout.TransferAccount"):new(app.Screens.MainScreen, app)
Sallo.Layout.ConnectAccount = require("Sallo.App.layout.ConnectAccount"):new(app.Screens.MainScreen, app)
Sallo.Layout.Store = require("Sallo.App.layout.Store"):new(app.Screens.MainScreen, app)

Sallo.Scene = {}
Sallo.Scene.InfoMenu = require("Sallo.App.scene.InfoMenu"):new(app, Sallo.Layout.InfoMenu)
Sallo.Scene.TransferAccount = require("Sallo.App.scene.TransferAccount"):new(app, Sallo.Layout.TransferAccount)
Sallo.Scene.ConnectAccount = require("Sallo.App.scene.ConnectAccount"):new(app, Sallo.Layout.ConnectAccount)
Sallo.Scene.Store = require("Sallo.App.scene.Store"):new(app, Sallo.Layout.Store)

Sallo.Data = require("Sallo.App.Data")
Sallo.Client = require("Sallo.include.Web.Client"):new()
Sallo.Handle = require("Sallo.include.Web.Handle"):new()
app.EventRouter:attachRednetCallback(sallo_param.Web.protocol, function(a, b, c, d)
    Sallo.Handle:parse(c)
end)

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
