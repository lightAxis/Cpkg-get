local class = require("Class.middleclass")

local GOLKIN = DEPS.Sallo.Golkin
local golkin_protocol = GOLKIN.Web.Protocol

local THIS = PKGS.Sallo
local sallo_protocol = THIS.Web.Protocol

local TBL = DEPS.Sallo.Tabullet

---@class Sallo.App.Scene.Inspector : Tabullet.UIScene
---@field Layout Sallo.App.Layout.Inspector
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Sallo.App, UILayout:Tabullet.UILayout):Sallo.App.Scene.Inspector
local SCENE = class("Sallo.App.Scene.Inspector", TBL.UIScene)

---constructor
---@param ProjNamespace Sallo.App
---@param UILayout Sallo.App.Layout.Inspector
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_InfoMenu()
        end
    end

    self.Layout.bt_inspect.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            if self.selectedInfo ~= nil then
                self:goto_InfoMenu_VIEWER()
            end
        end
    end

    self.Layout.lb_infoList:setItemTemplate(function(obj)
        ---@cast obj string
        return obj, nil, nil
    end)

    self.Layout.lb_infoList.SelectedIndexChanged = function(obj)
        ---@type string
        local infoName = obj.obj
        self:get_info_fromServer(infoName)
    end

    self.Layout.bt_arrow_up.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self.Layout.lb_infoList:setScroll(self.Layout.lb_infoList:getScroll() - 1)
        end
    end

    self.Layout.bt_arrow_down.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self.Layout.lb_infoList:setScroll(self.Layout.lb_infoList:getScroll() + 1)
        end
    end

    ---@type Sallo.Web.Protocol.Struct.info_t
    self.selectedInfo = nil
end

function SCENE:goto_InfoMenu()
    self:detachHandlers()
    self.PROJ.Sallo.Scene.InfoMenu:reset_before(self.PROJ.Sallo.Data.CurrentInfo)
    self.PROJ.Sallo.Scene.InfoMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
end

function SCENE:goto_InfoMenu_VIEWER()
    self:detachHandlers()
    self.PROJ.Sallo.Scene.InfoMenu:reset_before(self.selectedInfo)
    self.PROJ.Sallo.Scene.InfoMenu:reset()
    self.PROJ.Sallo.Scene.InfoMenu:reset_after_VIEWERmode()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
end

---comment
---@param info_t Sallo.Web.Protocol.Struct.info_t
function SCENE:goto_InfoMenu_Viewer(info_t)
    self:detachHandlers()
    self.PROJ.Sallo.Scene.InfoMenu:reset_before(info_t)
    self.PROJ.Sallo.Scene.InfoMenu:reset()
    self.PROJ.Sallo.Scene.InfoMenu:reset_after_VIEWERmode()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
end

---@param list table<number, string>
function SCENE:refresh_list(list)
    self.Layout.lb_infoList:setItemSource(list)
    self.Layout.lb_infoList:Refresh()
end

function SCENE:refresh_list_fromServer()
    self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_GET_INFOS, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_GET_INFOS
        if msgstruct.Success == false then
            self.Layout.tb_info:setText(sallo_protocol.Enum_INV.ACK_GET_INFOS_R_INV[msgstruct.State])
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
            self.selectedInfo = nil
        else
            self:refresh_list(msgstruct.Infos)
            self.Layout:control_selectionViewGroup(false)
            self.selectedInfo = nil

            self.Layout.tb_info:setText("Refresh Infos")
            self.PROJ.Style.TB.InfoSuccess(self.Layout.tb_info)
        end
        self.PROJ.UIRunner:ReDrawAll()
    end)

    self.PROJ.Sallo.Client:send_GET_INFOS()
end

---@param infoName string
function SCENE:get_info_fromServer(infoName)
    self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_GET_INFO, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO
        if msgstruct.Success == false then
            self.Layout.tb_info:setText(sallo_protocol.Enum_INV.ACK_GET_INFO_R_INV[msgstruct.State])
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
            self.selectedInfo = nil
        else
            self.Layout:refresh_infoPanels(msgstruct.Info)
            self.selectedInfo = msgstruct.Info

            self.Layout:control_selectionViewGroup(true)
        end
        self.PROJ.UIRunner:ReDrawAll()
    end)

    self.PROJ.Sallo.Client:send_GET_INFO(infoName)
end

function SCENE:reset()
    self.Layout.tb_info:setText("Search & Inspect accounts")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
    self.selectedInfo = nil

    self:refresh_list_fromServer()
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
    self.PROJ.Sallo.Handle:clearAllMsgHandle()
end

return SCENE
