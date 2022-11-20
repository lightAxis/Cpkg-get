---pkg dependancy
local args = { ... }

---@class DEPS
DEPS = DEPS or {}
---@class DEPS.Golkin
DEPS["Golkin"] = {}
DEPS["Golkin"].Crotocol = require("Crotocol.pkg_init")
DEPS["Golkin"].Tabullet = require("Tabullet.pkg_init")

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
Golkin.Web.Handle = require("Golkin.include.Web.Handle")
Golkin.Web.Protocol = require("Golkin.include.Web.Protocol.Include")


return Golkin
