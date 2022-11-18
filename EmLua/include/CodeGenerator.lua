---@class EmLua.CodeGenerator
local CodeGenerator = require("Class.middleclass")("EmLua.CodeGenerator")

local tool = require("__Cpkg.Tool")

---constructor
function CodeGenerator:initialize()

    self.getScriptPath = PKGS.EmLua.ENV.PATH .. "/temp/CodeGenerator_genScript.lua"

    self.__rawScriptLevel = 0
    self.__variableLevel = 0

    ---@type table<number, EmLua.Stringseg_t>
    self.__strSegs = {}
    ---@type table<number, EmLua.ScriptSeg_t>
    self.__scriptSegs = {}
end

---@class EmLua.CodeGenerator
---@field new fun(self:EmLua.CodeGenerator):EmLua.CodeGenerator


--- do codegen
---@param global table custom dictionary for codegen
---@param tempPath string template path
---@param outputPath string output path
function CodeGenerator:GenCode(global, tempPath, outputPath)
    ---@type table<number, string>
    local readString = {}

    --- read template string
    local f = fs.open(tempPath, "r")
    for v in f.readLine do
        table.insert(readString, v)
    end
    f.close()

    -- refine to script generation lua
    self.__scriptSegs = {}
    self.__variableLevel = 0
    self.__rawScriptLevel = 0
    for k, v in pairs(readString) do
        self.__strSegs = {}
        self:__parseDelimeters(v)
        local t = PKGS.EmLua.ScriptSeg_t:new()
        t.str, t.isRawScript = self:__transformDelimeter()
        table.insert(self.__scriptSegs, t)
    end

    --- prepare genScript
    local f = fs.open(self.getScriptPath, "w")
    -- prepare for input of global variable to genScript
    f.writeLine("local args = {...}")
    f.writeLine("local __GenVariables = args[1]")
    f.writeLine("local f = args[2]")
    f.writeLine("")
    -- prepare match variable name inside genScript
    for k, v in pairs(global) do
        f.writeLine("local " .. k .. " = " .. "__GenVariables[\"" .. k .. "\"]")
    end
    f.writeLine("")
    -- write script to genScript
    for k, v in pairs(self.__scriptSegs) do
        if (v.isRawScript) then f.writeLine(v.str)
        else f.writeLine("f.writeLine(" .. v.str .. ")") end
    end
    f.close()

    ---run genScript
    tool.colorPrint(colors.cyan, "gen file... ", colors.blue, outputPath)

    os.sleep(0.5)

    local f = fs.open(outputPath, "w")
    local script, scriptError = loadfile(self.getScriptPath, "t")
    if (scriptError ~= nil) then
        tool.colorPrint(colors.red, scriptError)
        tool.colorPrint(colors.red, "failed")
    else
        script(global, f)
        tool.colorPrint(colors.green, "succes")
    end
    f.close()

end

---comment
---@param line string
function CodeGenerator:__parseDelimeters(line)
    line = line:gsub("\"", "\\\"")
    local continue = false

    while true do
        if #line <= 0 then return nil end

        continue = false

        -- if start raw script level?
        if (self.__rawScriptLevel == 1) then
            local index, index2 = line:find("&%[")
            if (index ~= nil and not continue) then
                -- find &[ start
                -- addToSeg(line:sub(1, index - 1))
                self.__rawScriptLevel = self.__rawScriptLevel + 1
                line = line:sub(index2 + 1, #line)
                continue = true
            end

            local index, index2 = line:find("%]&")
            if (index ~= nil and not continue) then
                self:__addToSegs(line:sub(1, index - 1))
                self.__rawScriptLevel = self.__rawScriptLevel - 1
                line = line:sub(index2 + 1, #line)
                continue = true
            end
        end

        -- is variable convert level without raw script level?
        local index_, index2_ = line:find("%}&")
        index_ = index_ or 65535
        local index, index2 = line:find("&%{")
        index = index or 65535

        if (index < index_) then
            if (index ~= 65535 and not continue) then
                -- find &{ start
                self:__addToSegs(line:sub(1, index - 1))
                self.__variableLevel = self.__variableLevel + 1
                line = line:sub(index2 + 1, #line)
                continue = true
            end
        else
            if (index_ ~= 65535 and not continue) then
                self:__addToSegs(line:sub(1, index_ - 1):gsub("\\\"", "\""))
                self.__variableLevel = self.__variableLevel - 1
                line = line:sub(index2_ + 1, #line)
                continue = true
            end
        end

        local index, index2 = line:find("&%[")
        if (index ~= nil and not continue) then
            -- find &[ start
            -- addToSeg(line:sub(1, index - 1))
            self.__rawScriptLevel = self.__rawScriptLevel + 1
            line = line:sub(index2 + 1, #line)
            continue = true
        end

        local index, index2 = line:find("%]&")
        if (index ~= nil and not continue) then
            self:__addToSegs(line:sub(1, index - 1))
            self.__rawScriptLevel = self.__rawScriptLevel - 1
            line = line:sub(index2 + 1, #line)
            continue = true
        end

        if (not continue) then
            self:__addToSegs(line)
            line = ""
            continue = true
        end
    end
end

function CodeGenerator:__addToSegs(str)
    ---@type temp_t
    local seg = {}
    seg.str = str
    if (self.__rawScriptLevel >= 2 or self.__rawScriptLevel < 0) then error("wrong parse at : " .. str) end
    if (self.__variableLevel >= 2 or self.__variableLevel < 0) then error("wrong parse at : " .. str) end
    seg.scptLevel = self.__rawScriptLevel
    seg.varLevel = self.__variableLevel
    table.insert(self.__strSegs, seg)
end

---transform splited text to merged string
---@return string str
---@return boolean isRawScript
function CodeGenerator:__transformDelimeter()
    local resultStr = "\"\""
    for k, v in pairs(self.__strSegs) do
        if (v.scptLevel == 1) then
            -- resultStr = resultStr .. "..\"" .. v.str .. "\""
            return v.str:gsub("\\\"", "\""), true
        elseif (v.varLevel == 1) then
            resultStr = resultStr .. ".." .. v.str
        else
            resultStr = resultStr .. "..\"" .. v.str .. "\""
        end
    end

    return resultStr, false
end

return CodeGenerator
