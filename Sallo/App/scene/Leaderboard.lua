local class = require("Class.middleclass")

local GOLKIN = DEPS.Sallo.Golkin
local golkin_protocol = GOLKIN.Web.Protocol

local THIS = PKGS.Sallo
local sallo_protocol = THIS.Web.Protocol

local TBL = DEPS.Sallo.Tabullet

---@class Sallo.App.Scene.Leaderboard : Tabullet.UIScene
---@field Layout Sallo.App.Layout.Leaderboard
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Sallo.App, UILayout:Tabullet.UILayout):Sallo.App.Scene.Leaderboard
local SCENE = class("Sallo.App.Scene.Leaderboard", TBL.UIScene)

---constructor
---@param ProjNamespace Sallo.App
---@param UILayout Sallo.App.Layout.Leaderboard
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_InfoMenu()
        end
    end

    self.Layout.bt_refresh.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:refresh_leaderboard_fromServer()
        end
    end

    ---@type table<number, Sallo.Web.Protocol.Struct.leaderboardInfo_t>
    self.__currentLeaderArr = {}
end

function SCENE:goto_InfoMenu()
    self:detachHandlers()
    self.PROJ.Sallo.Scene.InfoMenu:reset_before(self.PROJ.Sallo.Data.CurrentInfo)
    self.PROJ.Sallo.Scene.InfoMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
end

function SCENE:refresh_leaderboard_fromServer()
    self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_GET_LEADERBOARD_INFOS, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_GET_LEADERBOARD_INFOS
        if msgstruct.Success == false then
            self.Layout.tb_info:setText(sallo_protocol.Enum_INV.ACK_GET_LEADERBOARD_INFOS_R_INV[msgstruct.State])
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
            self.__currentLeaderArr = {}
            self.Layout.lb_leaderboard:setItemSource(self.__currentLeaderArr)
            self.Layout.lb_leaderboard:Refresh()
        else
            self.__currentLeaderArr = msgstruct.LeaderboardInfos
            self.Layout.lb_leaderboard:setItemSource(self.__currentLeaderArr)
            self.Layout.lb_leaderboard:Refresh()
        end
        self.PROJ.UIRunner:ReDrawAll()
    end)
    self.PROJ.Sallo.Client:send_GET_LEADERBOARD_INFOS()
end

function SCENE:reset()
    self.Layout.tb_info:setText("Who is the 1st?")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
    self:refresh_leaderboard_fromServer()
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
    self.PROJ.Sallo.Handle:clearAllMsgHandle()
end

return SCENE
