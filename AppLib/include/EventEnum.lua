---@enum AppLib.EventEnum
local Events = {
    ["char"] = "char",
    ["key"] = "key",
    ["key_up"] = "key_up",
    ["paste"] = "paste",
    ["timer"] = "timer",
    ["alarm"] = "alarm",
    ["task_complete"] = "task_complete",
    ["redstone"] = "redstone",
    ["terminate"] = "terminate",
    ["disk"] = "disk",
    ["disk_eject"] = "disk_eject",
    ["peripheral"] = "peripheral",
    ["peripheral_detach"] = " peripheral_detach	",
    ["rednet_message"] = "rednet_message",
    ["modem_message"] = "modem_message",
    ["http_success"] = "http_success",
    ["http_failure"] = "http_failure",
    ["mouse_click"] = "mouse_click",
    ["mouse_up"] = "mouse_up",
    ["mouse_scroll"] = "mouse_scroll",
    ["mouse_drag"] = "mouse_drag",
    ["monitor_touch"] = "monitor_touch",
    ["monitor_resize"] = "monitor_resize",
    ["term_resize"] = "term_resize",
    ["turtle_inventory"] = "turtle_inventory",

    ["chat"] = "chat", -- chatbox
    ["playerClick"] = "playerClick" -- player detector
}

return Events;
