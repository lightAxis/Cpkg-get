---@class Crotocol.Builder
---@field Name string name of protocol
---@field RequirePrefix string require prefix used for generate init.lua file
---@field Enums table<string, Crotocol.enum_t>
---@field Structs table<string, Crotocol.struct_t>
---@field Headers table<string, Crotocol.struct_t>
---@field new fun(self:Crotocol.Builder, name?:string, requirePrefix?:string):Crotocol.Builder
local builder = require("class.middleclass")("Crotocol.Builder")

---constructor
---@param name? string
---@param requirePrefix? string
function builder:initialize(name, requirePrefix, classIncludeStr)
    self.Name = name or "crotocol_default"
    self.RequirePrefix = requirePrefix or "Crotocol.test.testCroto"
    ---@type table<string, Crotocol.enum_t>
    self.Enums = {}
    ---@type table<string, Crotocol.struct_t>
    self.Structs = {}
    ---@type table<string, Crotocol.struct_t>
    self.Headers = {}
end

---get class name of registered enum
---@param name string
function builder:getEnumClassName(name)
    if (self.Enums[name] == nil) then
        error("there is no enum registered : " .. name)
    end
    return self:__makeEnumClassName(name)
end

function builder:__makeEnumClassName(name)
    return self.Name .. ".Enum." .. name
end

---get class name of registered struct
---@param name string
function builder:getStructClassName(name)
    if (self.Structs[name] == nil) then
        error("there is no struct registered : " .. name)
    end
    return self:__makeStructClassName(name)
end

function builder:__makeStructClassName(name)
    return self.Name .. ".Struct." .. name
end

---get class name of registered header
---@param name string
function builder:getHeaderClassName(name)
    if (self.Headers[name] == nil) then
        error("there is no header registered : " .. name)
    end
    return self:__makeHeaderClassName(name)
end

function builder:__makeHeaderClassName(name)
    return self.Name .. ".MsgStruct." .. name
end

---set procotol name of builder
---@param name string
function builder:setProtocolName(name)
    self.Name = name
end

---register enum to builder
---@param enum_t Crotocol.enum_t
---@return Crotocol.Builder
function builder:addEnum(enum_t)
    if (self.Enums[enum_t.Name] ~= nil) then
        error("enum [" .. enum_t.Name .. "] is already exist in builder!")
    end
    self.Enums[enum_t.Name] = enum_t
    return self
end

---register struct to builder
---@param struct_t Crotocol.struct_t
---@return Crotocol.Builder
function builder:addStruct(struct_t)
    if (self.Structs[struct_t.Name] ~= nil) then
        error("struct [" .. struct_t.Name .. "] is already exist in builder!")
    end
    self.Structs[struct_t.Name] = struct_t
    return self
end

---register header struct to builder
---@param header_t Crotocol.struct_t
---@return Crotocol.Builder
function builder:addHeader(header_t)
    if (self.Headers[header_t.Name] ~= nil) then
        error("Header [" .. header_t.Name .. "] is already exist in builder!")
    end
    self.Headers[header_t.Name] = header_t
    return self
end

---generate enum, struct, headers to path
---@param targetPath string
---@return Crotocol.Builder
function builder:generate(targetPath)

    local generator = DEPS.Crotocol.EmLua.CodeGenerator:new()
    local tempPath = PKGS.Crotocol.__PATH .. "/templates"
    local global = {}
    global["Builder"] = self

    if not fs.exists(targetPath) then fs.makeDir(targetPath) end

    -- generate header definition
    generator:GenCode(global, tempPath .. "/HeaderDef.em", targetPath .. "/HeaderDef.lua")
    -- generate Enums file
    generator:GenCode(global, tempPath .. "/Enums.em", targetPath .. "/Enums.lua")
    -- generate Msg definition
    generator:GenCode(global, tempPath .. "/MsgDef.em", targetPath .. "/MsgDef.lua")

    --- generate Msg structs
    local headersPath = targetPath .. "/MsgStruct"
    if not fs.exists(headersPath) then fs.makeDir(headersPath) end
    for k, v in pairs(self.Headers) do
        global["MsgStruct"] = v
        generator:GenCode(global, tempPath .. "/MsgStruct.em", headersPath .. "/" .. v.Name .. ".lua")
    end

    --- generate Structs
    local structsPath = targetPath .. "/Struct"
    if not fs.exists(structsPath) then fs.makeDir(structsPath) end
    for k, v in pairs(self.Structs) do
        global["Struct"] = v
        generator:GenCode(global, tempPath .. "/Struct.em", structsPath .. "/" .. v.Name .. ".lua")
    end

    --- generate Include.lua
    generator:GenCode(global, tempPath .. "/Include.em", targetPath .. "/Include.lua")



    return self
end

---generate handler of headers to path
---@param targetPath string
---@param classIncludeStr string string for class include middleclass
---@return Crotocol.Builder
function builder:generateHandler(targetPath, classIncludeStr)
    local generator = DEPS.Crotocol.EmLua.CodeGenerator:new()
    local tempPath = PKGS.Crotocol.__PATH .. "/templates"
    local global = {}
    global["Builder"] = self
    global["classIncludeStr"] = classIncludeStr

    if not fs.exists(targetPath) then fs.makeDir(targetPath) end
    generator:GenCode(global, tempPath .. "/Handle.em", targetPath .. "/Handle.lua")


    return self
end

---save builder content to path
---@param path string
---@return Crotocol.Builder
function builder:saveTo(path)
    local f = fs.open(path, "w")
    if (f == nil) then error("there is no path to write! : " .. path) end

    ---@type Crotocol.Builder
    local temp = {}
    temp.Name = self.Name
    temp.Enums = self.Enums
    temp.Structs = self.Structs
    temp.Headers = self.Headers
    f.write(textutils.serialize(temp))
    f.close()
    return self
end

---load builder setting from path
---@param path string
---@return Crotocol.Builder
function builder:loadFrom(path)
    local f = fs.open(path, "r")
    if (f == nil) then error("there is no path to read! : " .. path) end

    ---@type Crotocol.Builder
    local temp = textutils.unserialize(f.readAll())
    self.Name = temp.Name
    self.Enums = temp.Enums
    self.Structs = temp.Structs
    self.Headers = temp.Headers
    f.close()
    return self
end

return builder
