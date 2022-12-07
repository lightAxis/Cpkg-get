local aa = function()
    return 1, 2, 3, 4
end


local bb = function()
    return aa()
end

local a, b, c, d = bb()
print(a, b, c, d)
