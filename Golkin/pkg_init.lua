---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Golkin
DEPS["Golkin"] = {}
DEPS["Golkin"].Crotocol = require("Crotocol.pkg_init")
DEPS["Golkin"].Tabullet = require("Tabullet.pkg_init")
DEPS["Golkin"].MathLib = require("MathLib.pkg_init")
DEPS["Golkin"].AppLib = require("AppLib.pkg_init")
DEPS["Golkin"].Sallo = require("Sallo.pkg_init")

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.Golkin
local Golkin = {}
PKGS["Golkin"] = Golkin

Golkin.ENV = {}
--- absolute path of this pkg when runtime
---@type string
Golkin.ENV.PATH = fs.getDir(args[2])
Golkin.ENV.CONST = require("Golkin.include.Const")

Golkin.Web = {}
Golkin.Web.Protocol = require("Golkin.include.Web.Protocol.Include")
Golkin.Web.Handle = require("Golkin.include.Web.Handle")
Golkin.Web.Client = require("Golkin.include.Web.Client")
Golkin.Web.Server = require("Golkin.include.Web.Server")

return Golkin
