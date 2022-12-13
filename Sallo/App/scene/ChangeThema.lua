local class = require("Class.middleclass")

local GOLKIN = DEPS.Sallo.Golkin
local golkin_protocol = GOLKIN.Web.Protocol

local THIS = PKGS.Sallo
local sallo_protocol = THIS.Web.Protocol
local sallo_param = THIS.Param

local TBL = DEPS.Sallo.Tabullet

---@class Sallo.App.Scene.ChangeThema : Tabullet.UIScene
---@field Layout Sallo.App.Layout.ChangeThema
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Sallo.App, UILayout:Tabullet.UILayout):Sallo.App.Scene.ChangeThema
local SCENE = class("Sallo.App.Scene.ChangeThema", TBL.UIScene)


---@class Sallo.App.Scene.ChangeThema.Thema_t
---@field Name string
---@field Enum number

---constructor
---@param ProjNamespace Sallo.App
---@param UILayout Sallo.App.Layout.ChangeThema
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_InfoMenu()
        end
    end

    self.Layout.bt_apply.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            local thema = self.__ThemaList[self.__selectedThemaIndex].Enum
            self:send_CHANGE_THEMA_toServer(thema)
        end
    end

    self.Layout.bt_arrow_left.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:scroll_to(self.__selectedThemaIndex - 1)
        end
    end

    self.Layout.bt_arrow_right.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:scroll_to(self.__selectedThemaIndex + 1)
        end
    end

    ---@type table<number, Sallo.App.Scene.ChangeThema.Thema_t>
    self.__ThemaList = {}
    self.__selectedThemaIndex = nil

end

function SCENE:goto_InfoMenu()
    self:detachHandlers()
    self.PROJ.Sallo.Scene.InfoMenu:reset_before(self.PROJ.Sallo.Data.CurrentInfo)
    self.PROJ.Sallo.Scene.InfoMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
end

---@param thema Sallo.Web.Protocol.Enum.THEMA
function SCENE:send_CHANGE_THEMA_toServer(thema)

    local infoName = self.PROJ.Sallo.Data.CurrentInfo.Name
    local infoPasswd = self.PROJ.Data.CurrentOwner.Password

    self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_CHANGE_THEMA, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_THEMA
        if msgstruct.Success == false then
            self.Layout.tb_info:setText(sallo_protocol.Enum_INV.ACK_CHANGE_THEMA_R_INV[msgstruct.State])
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
        else
            self.Layout:show_thema(thema)
            self.Layout.tb_info:setText("Thema Changed!")
            self.PROJ.Style.TB.InfoSuccess(self.Layout.tb_info)
        end
        self.PROJ.UIRunner:ReDrawAll()
    end)

    self.PROJ.Sallo.Client:send_CHANGE_THEMA(infoName, infoPasswd, thema)
end

---@param info_t Sallo.Web.Protocol.Struct.info_t
---@return number|nil foundindex
function SCENE:find_index(info_t)
    self.__ThemaList = {}
    -- refresh all thema list
    for i, v in pairs(info_t.Items) do
        if v.ItemType == sallo_protocol.Enum.ITEM_TYPE.THEMA then
            ---@type Sallo.App.Scene.ChangeThema.Thema_t
            local a = {}
            a.Enum = v.ItemIndex
            a.Name = sallo_param.Thema[v.ItemIndex].themaName
            table.insert(self.__ThemaList, a)
        end
    end

    -- find my thema
    self.__selectedThemaIndex = nil

    for i, v in ipairs(self.__ThemaList) do
        if v.Enum == info_t.Thema then
            self.__selectedThemaIndex = i
            break
        end
    end

    return self.__selectedThemaIndex
end

---scroll thema list by number
---@param idx number
function SCENE:scroll_to(idx)
    if self.__selectedThemaIndex == nil or idx == nil then
        self.Layout.bt_arrow_left.Visible = false
        self.Layout.bt_arrow_right.Visible = false
        return nil
    end

    if (idx < 1) then
        idx = 1
    end

    if (idx > #self.__ThemaList) then
        idx = #self.__ThemaList
    end

    if (idx == 1) then
        self.Layout.bt_arrow_left.Visible = false
    else
        self.Layout.bt_arrow_left.Visible = true
    end

    if (idx == #self.__ThemaList) then
        self.Layout.bt_arrow_right.Visible = false
    else
        self.Layout.bt_arrow_right.Visible = true
    end

    if (idx >= 1 and idx <= #self.__ThemaList) then
        local prevThema = self.__ThemaList[idx].Enum
        self.Layout:show_thema(prevThema)
    end

    self.__selectedThemaIndex = idx

end

function SCENE:reset()
    self.Layout.tb_info:setText("Select Thema")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)

    local found_idx = self:find_index(self.PROJ.Sallo.Data.CurrentInfo)
    self.Layout:show_thema(self.PROJ.Sallo.Data.CurrentInfo.Thema)
    if (found_idx ~= nil) then
        self:scroll_to(found_idx)
    end

end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
    self.PROJ.Sallo.Handle:clearAllMsgHandle()
end

return SCENE
