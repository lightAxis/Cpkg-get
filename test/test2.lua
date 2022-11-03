local args = {...}

local test3val = require("test.test3")

print("test2!")
for k,v in pairs(args) do
    print(k,v)
end
print("test2! end")
print("result test3 was : "..test3val)
return args[1]