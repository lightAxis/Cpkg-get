require("Sallo.pkg_init")

local THIS = PKGS.Sallo
local themaEnum = THIS.Web.Protocol.Enum.THEMA
local param_thema = THIS.Param.Thema
local TBL = DEPS.Sallo.Tabullet

-- 0 ~ 17
local thema_want = 1

local currentIdx = 1
local colorTable = {}
for k, v in pairs(TBL.Enums.Color) do
    if v ~= TBL.Enums.Color.None then
        table.insert(colorTable, k)
    end
end

local function draw(thema, index)
    local name = param_thema[thema].themaName
    local BG = param_thema[thema].BG
    local FG = param_thema[thema].FG

    term.setBackgroundColor(colors.black)
    term.clear()
    term.setCursorPos(1, 1)

    term.setBackgroundColor(colors[BG])
    term.setTextColor(colors[FG])
    print(name .. "  /FG: " .. FG .. " /   BG: " .. BG)

    for i = 1, 16, 1 do
        term.setBackgroundColor(colors[colorTable[i]])
        term.setTextColor(colors[colorTable[index]])
        print(name .. "  /FG: " .. colorTable[index] .. " /BG: " .. colorTable[i])
    end
end

for k, v in pairs(colorTable) do
    print(k, v)
end

while true do
    local a, b, c, d = os.pullEvent("mouse_click")

    draw(thema_want, currentIdx)
    if currentIdx > 16 then
        currentIdx = 1
    end

    currentIdx = currentIdx + 1
end
