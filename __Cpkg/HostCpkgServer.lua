local tool = require("__Cpkg.Tool")

tool.colorPrint(colors.cyan, "Start Cpkg server at computer id :" .. tostring(os.getComputerID()))
tool.colorPrint(colors.green, "Finding previous lookup for cpkg-server")
