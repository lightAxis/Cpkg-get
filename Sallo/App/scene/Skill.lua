local class = require("Class.middleclass")

local GOLKIN = DEPS.Sallo.Golkin
local golkin_protocol = GOLKIN.Web.Protocol

local THIS = PKGS.Sallo
local sallo_protocol = THIS.Web.Protocol

local param = THIS.Param

local TBL = DEPS.Sallo.Tabullet

---@class Sallo.App.Scene.Skill : Tabullet.UIScene
---@field Layout Sallo.App.Layout.Skill
---@field PROJ Sallo.App
---@field newSkillState Sallo.Web.Protocol.Struct.skillState_t
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Sallo.App, UILayout:Tabullet.UILayout):Sallo.App.Scene.Skill
local SCENE = class("Sallo.App.Scene.Skill", TBL.UIScene)

---constructor
---@param ProjNamespace Sallo.App
---@param UILayout Sallo.App.Layout.Skill
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_InfoMenu()
        end
    end

    self.Layout.bt_EFF_up.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:press_EFF_bt(1)
        end
    end

    self.Layout.bt_EFF_down.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:press_EFF_bt(-1)
        end
    end

    self.Layout.bt_PRO_up.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:press_PRO_bt(1)
        end
    end

    self.Layout.bt_PRO_down.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:press_PRO_bt(-1)
        end
    end

    self.Layout.bt_CON_up.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:press_CON_bt(1)
        end
    end

    self.Layout.bt_CON_down.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:press_CON_bt(-1)
        end
    end

    self.Layout.bt_apply.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:send_skillState()
        end
    end

    self.newSkillState = nil
end

function SCENE:goto_InfoMenu()
    self:detachHandlers()
    self.PROJ.Sallo.Scene.InfoMenu:reset_before(self.PROJ.Sallo.Data.CurrentInfo)
    self.PROJ.Sallo.Scene.InfoMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
end

function SCENE:reset()
    local skillState_t = textutils.serialize(self.PROJ.Sallo.Data.CurrentInfo.SkillState)
    self.newSkillState = textutils.unserialize(skillState_t)
    self.Layout:refresh_display(self.newSkillState, self.PROJ.Sallo.Data.CurrentInfo.Main.Rank)
end

---@param dir number -1 or 1
function SCENE:press_EFF_bt(dir)
    if dir == 1 then
        local skillpt = param.Skill.EFF[self.newSkillState.Efficiency_level].require_sp
        self.newSkillState.Left_sp = self.newSkillState.Left_sp - skillpt
        if self.newSkillState.Left_sp < 0 then
            return nil
        end
    elseif dir == -1 then
        local skillpt = param.Skill.EFF[self.newSkillState.Efficiency_level - 1].require_sp
        self.newSkillState.Left_sp = self.newSkillState.Left_sp + skillpt
        if self.newSkillState.Left_sp < 0 then
            return nil
        end
    else
        error("dir must be -1 or 1 " .. dir)
    end
    self.newSkillState.Efficiency_level = self.newSkillState.Efficiency_level + dir
    self.Layout:refresh_display(self.newSkillState, self.PROJ.Sallo.Data.CurrentInfo.Main.Rank)
end

function SCENE:send_skillState()
    self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_CHANGE_SKILL_STAT, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_CHANGE_SKILL_STAT
        if msgstruct.Success == false then
            self.Layout.tb_info:setText(sallo_protocol.Enum_INV.ACK_CHANGE_SKILL_STAT_R_INV[msgstruct.State])
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
        else
            self.Layout.tb_info:setText("SUCCESS")
            self.PROJ.Style.TB.InfoSuccess(self.Layout.tb_info)
        end
        self.PROJ.UIRunner:ReDrawAll()
    end)

    self.PROJ.Sallo.Client:send_CHANGE_SKILL_STAT(self.PROJ.Sallo.Data.CurrentInfo.Name, self.newSkillState)
end

---@param dir number -1 or 1
function SCENE:press_PRO_bt(dir)
    if dir == 1 then
        local skillpt = param.Skill.PRO[self.newSkillState.Proficiency_level].require_sp
        self.newSkillState.Left_sp = self.newSkillState.Left_sp - skillpt
        if self.newSkillState.Left_sp < 0 then
            return nil
        end
    elseif dir == -1 then
        local skillpt = param.Skill.PRO[self.newSkillState.Proficiency_level - 1].require_sp
        self.newSkillState.Left_sp = self.newSkillState.Left_sp + skillpt
        if self.newSkillState.Left_sp < 0 then
            return nil
        end
    else
        error("dir must be -1 or 1 " .. dir)
    end
    self.newSkillState.Proficiency_level = self.newSkillState.Proficiency_level + dir
    self.Layout:refresh_display(self.newSkillState, self.PROJ.Sallo.Data.CurrentInfo.Main.Rank)
end

---@param dir number -1 or 1
function SCENE:press_CON_bt(dir)
    if dir == 1 then
        local skillpt = param.Skill.CON[self.newSkillState.Concentration_level].require_sp
        self.newSkillState.Left_sp = self.newSkillState.Left_sp - skillpt
        if self.newSkillState.Left_sp < 0 then
            return nil
        end
    elseif dir == -1 then
        local skillpt = param.Skill.CON[self.newSkillState.Concentration_level - 1].require_sp
        self.newSkillState.Left_sp = self.newSkillState.Left_sp + skillpt
        if self.newSkillState.Left_sp < 0 then
            return nil
        end
    else
        error("dir must be -1 or 1 " .. dir)
    end
    self.newSkillState.Concentration_level = self.newSkillState.Concentration_level + dir
    self.Layout:refresh_display(self.newSkillState, self.PROJ.Sallo.Data.CurrentInfo.Main.Rank)
end

function SCENE:detachHandlers()
    self.PROJ.Sallo.Handle:clearAllMsgHandle()
    self.PROJ.Handle:clearAllMsgHandle()
end

return SCENE
