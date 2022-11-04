require("EmLua.pkg_init")

local code_generator = PKGS.EmLua.CodeGenerator:new()

local p1     = {}
p1.param     = "param1"
p1.type      = "string"
p1.initValue = "\"init1\""

local p2     = {}
p2.param     = "param2"
p2.type      = "number"
p2.initValue = "2903"

local p3     = {}
p3.param     = "param3"
p3.type      = "table<number, string>"
p3.initValue = "{[1] = \"2\", [2] = \"33\"}"

local classDeff = {}
classDeff.Fields = {}
table.insert(classDeff.Fields, p1)
table.insert(classDeff.Fields, p2)
table.insert(classDeff.Fields, p3)
classDeff.Name = "EmLua.CodeGenTestClass"
classDeff.tableName = "codegentestclass_table"

local globalVar = {}
globalVar["classDef"] = classDeff

code_generator:GenCode(globalVar,
    PKGS.EmLua.__PATH .. "/include/testCodegenTemplate.em",
    PKGS.EmLua.__PATH .. "/include/testCodeResult.lua")
