--- crotocol generation toolboxs
---@class Crotocol.GenTool
local a = {}

---@enum Crotocol.GenTool.Type
a.Type = {
    ["num"] = "num",
    ["str"] = "str",
    ["table"] = "table",
    ["custom"] = "custom",
    ["nil_"] = "nil_"
}

---make type string for field struct
---if want to gen table type, p1 & p2 must not nil
---@param varType Crotocol.GenTool.Type
---@param p1? string table key type or custom type string of class
---@param p2? string table value type
function a.makeTypeStr(varType, p1, p2)
    if varType == a.Type.str then
        return "string"
    elseif varType == a.Type.num then
        return "number"
    elseif varType == a.Type.table then
        if type(p1) ~= "string" or type(p2) ~= "string" then
            error("p1 & p2 must be string!, p1:" .. tostring(p1) .. "/p2:" .. tostring(p2))
        end
        return "table<" .. p1 .. ", " .. p2 .. ">"
    elseif varType == a.Type.custom then
        return p1
    elseif varType == a.Type.nil_ then
        return "nil"
    end
end

---generate type string.
--- - string : (type, string)
--- - number : (type, number)
--- - table : (type, keytype, valuetype)
--- - table(empty) :(type, nil, nil)
--- - custom : (type, customInitString)
--- - nil : (type)
---@param varType Crotocol.GenTool.Type
---@param p1? string|number|nil string, number, or table key type
---@param p2? string|nil table value type
function a.makeInitStr(varType, p1, p2)

    local p1Type = type(p1)
    local p2Type = type(p2)

    if (varType == a.Type.str) then
        if (p1Type) == "string" then
            return "\"" .. p1 .. "\""
        else
            error("p1 must be string! p1:" .. tostring(p1))
        end
    elseif (varType == a.Type.num) then
        if p1Type == "number" then
            return tostring(p1)
        else
            error("p1 must be number! p1:" .. tostring(p1))
        end
    elseif (varType == a.Type.table) then
        if p1Type == "string" and p2Type == "string" then
            return "table<" .. p1 .. ", " .. p2 .. ">"
        elseif p1Type == "nil" and p2Type == "nil" then
            return "{}"
        else
            error("p1 & p2 must be string! p1:" .. tostring(p1) .. "/p2:" .. tostring(p2))
        end
    elseif varType == a.Type.custom then
        if p1Type == "string" then
            return p1
        else
            error("p1  must be string! p1:" .. tostring(p1))
        end
    elseif varType == a.Type.nil_ then
        return "nil"
    end

    error("type is not passed to makeInitStr function!")
end

return a
