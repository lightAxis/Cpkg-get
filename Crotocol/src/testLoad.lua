require("Crotocol.pkg_init")

local thisPkg = PKGS.Crotocol

local builder = thisPkg.Builder:new("Crotocol.testProtoLoad", "Crotocol.test.testCrotoLoad")

builder:loadFrom(thisPkg.ENV.PATH .. "/test/savefile.sz")
builder.Name = "Crotocol.testProtoLoad"
builder.RequirePrefix = "Crotocol.test.testCrotoLoad"

builder:generate(thisPkg.ENV.PATH .. "/test/testProtoLoad")
builder:generateHandler(thisPkg.ENV.PATH .. "/test/testProtoLoad", "require(\"Class.middleclass\")")
