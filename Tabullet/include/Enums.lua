local class = require("Class.middleclass")

local Enums = {}


-- enum used in vertical alignmentmode
---@enum Tabullet.Enums.VerticalAlignmentMode
Enums.VerticalAlignmentMode = {
    ["top"] = "top",
    ["bottom"] = "bottom",
    ["center"] = "center"
}

---@enum Tabullet.Enums.HorizontalAlignmentMode
Enums.HorizontalAlignmentMode = {
    ["left"] = "left",
    ["right"] = "right",
    ["center"] = "center"
}

---@enum Tabullet.Enums.Side
Enums.Side = {
    ["front"] = "front",
    ["back"] = "back",
    ["left"] = "left",
    ["right"] = "right",
    ["top"] = "top",
    ["bottom"] = "bottom",
    ["NONE"] = "NONE"
}

---@enum Tabullet.Enums.MouseButton
Enums.MouseButton = {
    ["left"] = 1,
    ["right"] = 2,
    ["center"] = 3
}

---@enum Tabullet.Enums.ScrollDirection
Enums.ScrollDirection = {
    ["up"] = -1,
    ["down"] = 1
}

---@enum Tabullet.Enums.Direction
Enums.Direction = {
    ["vertical"] = "vertical",
    ["horizontal"] = "horizontal"
}

---@enum Tabullet.Enums.Key
Enums.Key = {
    ["a"] = keys.a,
    ["c"] = keys.c,
    ["b"] = keys.b,
    ["e"] = keys.e,
    ["pageUp"] = keys.pageUp,
    ["g"] = keys.g,
    ["f"] = keys.f,
    ["i"] = keys.i,
    ["h"] = keys.h,
    ["k"] = keys.k,
    ["underscore"] = keys.underscore,
    ["space"] = keys.space,
    ["l"] = keys.l,
    ["o"] = keys.o,
    ["cimcumflex"] = keys.cimcumflex,
    ["q"] = keys.q,
    ["f1"] = keys.f1,
    ["s"] = keys.s,
    ["insert"] = keys.insert,
    ["f5"] = keys.f5,
    ["seven"] = keys.seven,
    ["eight"] = keys.eight,
    ["numPadEnter"] = keys.numPadEnter,
    ["y"] = keys.y,
    ["x"] = keys.x,
    ["numPad6"] = keys.numPad6,
    ["z"] = keys.z,
    ["backslash"] = keys.backslash,
    ["rightBracket"] = keys.rightBracket,
    ["f9"] = keys.f9,
    ["yen"] = keys.yen,
    ["left"] = keys.left,
    ["numPadSubtract"] = keys.numPadSubtract,
    ["noconvert"] = keys.noconvert,
    ["f4"] = keys.f4,
    ["return"] = keys["return"],
    ["leftCtrl"] = keys.leftCtrl,
    ["rightCtrl"] = keys.rightCtrl,
    ["numPad2"] = keys.numPad2,
    ["grave"] = keys.grave,
    ["delete"] = keys.delete,
    ["four"] = keys.four,
    ["rightAlt"] = keys.rightAlt,
    ["leftAlt"] = keys.leftAlt,
    ["numPad7"] = keys.numPad7,
    ["getName"] = keys.getName,
    ["numLock"] = keys.numLock,
    ["home"] = keys.home,
    ["numPad0"] = keys.numPad0,
    ["enter"] = keys.enter,
    ["slash"] = keys.slash,
    ["numPadEquals"] = keys.numPadEquals,
    ["six"] = keys.six,
    ["down"] = keys.down,
    ["n"] = keys.n,
    ["f11"] = keys.f11,
    ["t"] = keys.t,
    ["u"] = keys.u,
    ["rightShift"] = keys.rightShift,
    ["zero"] = keys.zero,
    ["p"] = keys.p,
    ["pageDown"] = keys.pageDown,
    ["nine"] = keys.nine,
    ["multiply"] = keys.multiply,
    ["capsLock"] = keys.capsLock,
    ["minus"] = keys.minus,
    ["leftBracket"] = keys.leftBracket,
    ["m"] = keys.m,
    ["scollLock"] = keys.scollLock,
    ["v"] = keys.v,
    ["f14"] = keys.f14,
    ["one"] = keys.one,
    ["circumflex"] = keys.circumflex,
    ["d"] = keys.d,
    ["up"] = keys.up,
    ["equals"] = keys.equals,
    ["numPad8"] = keys.numPad8,
    ["f7"] = keys.f7,
    ["apostrophe"] = keys.apostrophe,
    ["f10"] = keys.f10,
    ["f13"] = keys.f13,
    ["stop"] = keys.stop,
    ["scrollLock"] = keys.scrollLock,
    ["comma"] = keys.comma,
    ["numPad3"] = keys.numPad3,
    ["numPad9"] = keys.numPad9,
    ["numPad4"] = keys.numPad4,
    ["tab"] = keys.tab,
    ["f3"] = keys.f3,
    ["numPadAdd"] = keys.numPadAdd,
    ["kana"] = keys.kana,
    ["numPad1"] = keys.numPad1,
    ["right"] = keys.right,
    ["numPadDecimal"] = keys.numPadDecimal,
    ["f15"] = keys.f15,
    ["leftShift"] = keys.leftShift,
    ["backspace"] = keys.backspace,
    ["convert"] = keys.convert,
    ["end"] = keys["end"],
    ["three"] = keys.three,
    ["kanji"] = keys.kanji,
    ["colon"] = keys.colon,
    ["two"] = keys.two,
    ["semiColon"] = keys.semiColon,
    ["w"] = keys.w,
    ["f2"] = keys.f2,
    ["period"] = keys.period,
    ["j"] = keys.j,
    ["ax"] = keys.ax,
    ["r"] = keys.r,
    ["f6"] = keys.f6,
    ["at"] = keys.at,
    ["numPadDivide"] = keys.numPadDivide,
    ["numPad5"] = keys.numPad5,
    ["f12"] = keys.f12,
    ["pause"] = keys.pause,
    ["f8"] = keys.f8,
    ["five"] = keys.five,
    ["numPadComma"] = keys.numPadComma,
}

---@enum Tabullet.Enums.KeyReverse
Enums.KeyReverse = {}
for k,v in pairs(Enums.Key) do
    Enums.KeyReverse[v] = k
end

---@enum Tabullet.Enums.Color
Enums.Color = {
    ["white"] = 1,
    ["orange"] = 2,
    ["magenta"] = 4,
    ["lightBlue"] = 8,
    ["yellow"] = 16,
    ["lime"] = 32,
    ["pink"] = 64,
    ["gray"] = 128,
    ["lightGray"] = 256,
    ["cyan"] = 512,
    ["purple"] = 1024,
    ["blue"] = 2048,
    ["brown"] = 4096,
    ["green"] = 8192,
    ["red"] = 16384,
    ["black"] = 32768,
    ["None"] = -1,
}

---@type table<Tabullet.Enums.Color, string>
Enums.Blit =
{
    [Enums.Color.white] = "0",
    [Enums.Color.orange] = "1",
    [Enums.Color.magenta] = "2",
    [Enums.Color.lightBlue] = "3",
    [Enums.Color.yellow] = "4",
    [Enums.Color.lime] = "5",
    [Enums.Color.pink] = "6",
    [Enums.Color.gray] = "7",
    [Enums.Color.lightGray] = "8",
    [Enums.Color.cyan] = "9",
    [Enums.Color.purple] = "a",
    [Enums.Color.blue] = "b",
    [Enums.Color.brown] = "c",
    [Enums.Color.green] = "d",
    [Enums.Color.red] = "e",
    [Enums.Color.black] = "f",
    [Enums.Color.None] = "z",
}

---@type table<string, Tabullet.Enums.Color>
Enums.BlitReverse =
{
    ["0"] = Enums.Color.white,
    ["1"] = Enums.Color.orange,
    ["2"] = Enums.Color.magenta,
    ["3"] = Enums.Color.lightBlue,
    ["4"] = Enums.Color.yellow,
    ["5"] = Enums.Color.lime,
    ["6"] = Enums.Color.pink,
    ["7"] = Enums.Color.gray,
    ["8"] = Enums.Color.lightGray,
    ["9"] = Enums.Color.cyan,
    ["a"] = Enums.Color.purple,
    ["b"] = Enums.Color.blue,
    ["c"] = Enums.Color.brown,
    ["d"] = Enums.Color.green,
    ["e"] = Enums.Color.red,
    ["f"] = Enums.Color.black,
    ["z"] = Enums.Color.None,
}

return Enums