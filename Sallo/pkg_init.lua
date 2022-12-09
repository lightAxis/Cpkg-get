---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Sallo
DEPS["Sallo"] = {}
DEPS["Sallo"].Crotocol = require("Crotocol.pkg_init")
DEPS["Sallo"].EmLua = require("EmLua.pkg_init")
DEPS["Sallo"].Golkin = require("Golkin.pkg_init")
DEPS["Sallo"].Tabullet = require("Tabullet.pkg_init")

---pkg module include

---@class PKGS
PKGS = PKGS or {}
---@class PKG.Sallo
local Sallo = {}
PKGS["Sallo"] = Sallo

Sallo.ENV = {}
--- absolute path of this pkg when runtime
---@type string
Sallo.ENV.PATH = fs.getDir(args[2])

Sallo.PlayerLeveler = require("Sallo.include.PlayerLeveler")

Sallo.Param = require("Sallo.include.Param.param")

Sallo.Web = {}
Sallo.Web.Protocol = require("Sallo.include.Web.Protocol.Include")
Sallo.Web.Handle = require("Sallo.include.Web.Handle")
Sallo.Web.Server = require("Sallo.include.Web.Server")
Sallo.Web.Client = require("Sallo.include.Web.Client")

return Sallo
