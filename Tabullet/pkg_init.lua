---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Tabullet
DEPS["Tabullet"] = {}
DEPS["Tabullet"].MathLib = require("MathLib.pkg_init")
DEPS["Tabullet"].AppLib = require("AppLib.pkg_init")

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.Tabullet
local Tabullet = {}
PKGS["Tabullet"] = Tabullet
--- absolute path of this pkg when runtime
---@type string

Tabullet.ENV = {}
Tabullet.ENV.PATH = fs.getDir(args[2])

Tabullet.UIElement = require("Tabullet.include.UIElement")
Tabullet.UITools = require("Tabullet.include.UITools")
Tabullet.UIEvent = {}
Tabullet.UIEvent.EventArgs = require("Tabullet.include.UIEvents.EventArgs")
Tabullet.UIEvent.ClickEventArgs = require("Tabullet.include.UIEvents.ClickEventArgs")
Tabullet.UIEvent.ScrollEventArgs = require("Tabullet.include.UIEvents.ScrollEventArgs")
Tabullet.UIEvent.KeyInputEventArgs = require("Tabullet.include.UIEvents.KeyInputEventArgs")
Tabullet.UIEvent.CharEventArgs = require("Tabullet.include.UIEvents.CharEventArgs")
Tabullet.UIRunner = require("Tabullet.include.UIRunner")
Tabullet.UIScene = require("Tabullet.include.UIScene")
Tabullet.UILayout = require("Tabullet.include.UILayout")
Tabullet.Enums = require("Tabullet.include.Enums")
Tabullet.Screen = require("Tabullet.include.Screen.Screen_CC")
Tabullet.ScreenBuffer_t = require("Tabullet.include.Screen.ScreenBuffer_t")


Tabullet.TextArea = require("Tabullet.include.TextArea")
Tabullet.Margin = require("Tabullet.include.Margin")
Tabullet.Border = require("Tabullet.include.Border")
Tabullet.TextBlock = require("Tabullet.include.TextBlock")
Tabullet.Button = require("Tabullet.include.Button")
Tabullet.ScreenCanvas = require("Tabullet.include.ScreenCanvas")
Tabullet.ListBox = require("Tabullet.include.ListBox")
Tabullet.ListBoxItem = require("Tabullet.include.ListBoxItem")
Tabullet.ProgressBar = require("Tabullet.include.ProgressBar")

Tabullet.Grid = require("Tabullet.include.Grid")

return Tabullet
