local TBL = DEPS.Sallo.Tabullet
local GOL = DEPS.Sallo.Golkin

local sallo_param = require("Sallo.include.Param.param")

---@class Sallo.App : Golkin.App
local app = GOL.App

function app:build_sallo()
    app:build()

    app.Sallo = {}
    app.Sallo.Layout = {}
    app.Sallo.Layout.InfoMenu = require("Sallo.App.layout.InfoMenu"):new(app.Screens.MainScreen, app)
    app.Sallo.Layout.TransferAccount = require("Sallo.App.layout.TransferAccount"):new(app.Screens.MainScreen, app)
    app.Sallo.Layout.ConnectAccount = require("Sallo.App.layout.ConnectAccount"):new(app.Screens.MainScreen, app)
    app.Sallo.Layout.Store = require("Sallo.App.layout.Store"):new(app.Screens.MainScreen, app)
    app.Sallo.Layout.Skill = require("Sallo.App.layout.Skill"):new(app.Screens.MainScreen, app)
    app.Sallo.Layout.Inspector = require("Sallo.App.layout.Inspector"):new(app.Screens.MainScreen, app)
    app.Sallo.Layout.ChangeThema = require("Sallo.App.layout.ChangeThema"):new(app.Screens.MainScreen, app)
    app.Sallo.Layout.Leaderboard = require("Sallo.App.layout.Leaderboard"):new(app.Screens.MainScreen, app)

    app.Sallo.Scene = {}
    app.Sallo.Scene.InfoMenu = require("Sallo.App.scene.InfoMenu"):new(app, app.Sallo.Layout.InfoMenu)
    app.Sallo.Scene.TransferAccount = require("Sallo.App.scene.TransferAccount"):new(app,
        app.Sallo.Layout.TransferAccount)
    app.Sallo.Scene.ConnectAccount = require("Sallo.App.scene.ConnectAccount"):new(app,
        app.Sallo.Layout.ConnectAccount)
    app.Sallo.Scene.Store = require("Sallo.App.scene.Store"):new(app, app.Sallo.Layout.Store)
    app.Sallo.Scene.Skill = require("Sallo.App.scene.Skill"):new(app, app.Sallo.Layout.Skill)
    app.Sallo.Scene.Inspector = require("Sallo.App.scene.Inspector"):new(app, app.Sallo.Layout.Inspector)
    app.Sallo.Scene.ChangeThema = require("Sallo.App.scene.ChangeThema"):new(app, app.Sallo.Layout.ChangeThema)
    app.Sallo.Scene.Leaderboard = require("Sallo.App.scene.Leaderboard"):new(app, app.Sallo.Layout.Leaderboard)

    app.Sallo.Data = require("Sallo.App.Data")
    app.Sallo.Client = require("Sallo.include.Web.Client"):new()
    app.Sallo.Handle = require("Sallo.include.Web.Handle"):new()
    app.EventRouter:attachRednetCallback(sallo_param.Web.protocol, function(a, b, c, d)
        app.Sallo.Handle:parse(c)
    end)


    local bt_sallo = TBL.Button:new(app.Layout.Addons.rootScreenCanvas, app.Layout.Addons.attachingScreen, "bt_name")
    bt_sallo:setText("Sallo")
    app.Style.BT.Good(bt_sallo)
    app:add_addon(bt_sallo,
        function(obj)
            -- for test
            app.Scene.Addons:detach_handelers()
            local a = { ["Name"] = app.Data.CurrentOwner.Name }
            app.Sallo.Scene.InfoMenu:reset_before(a)
            app.Sallo.Scene.InfoMenu:reset()
            app.UIRunner:attachScene(app.Sallo.Scene.InfoMenu)
        end)

end

return app
