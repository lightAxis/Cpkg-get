require("Crotocol.pkg_init")

local thisPkg = PKGS.Crotocol

local builder = thisPkg.Builder:new("Crotocol.testProtoLoad", "Crotocol.test.testCrotoLoad")

builder:loadFrom(thisPkg.__PATH .. "/test/savefile.sz")
builder.Name = "Crotocol.testProtoLoad"
builder.RequirePrefix = "Crotocol.test.testCrotoLoad"

builder:generate(thisPkg.__PATH .. "/test/testProtoLoad")
builder:generateHandler(thisPkg.__PATH .. "/test/testProtoLoad", "require(\"class.middleclass\")")
