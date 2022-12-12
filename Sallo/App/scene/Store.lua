local class = require("Class.middleclass")

local GOLKIN = DEPS.Sallo.Golkin
local golkin_protocol = GOLKIN.Web.Protocol

local THIS = PKGS.Sallo
local sallo_protocol = THIS.Web.Protocol
local sallo_param = THIS.Param

local TBL = DEPS.Sallo.Tabullet

---@class Sallo.App.Scene.Store : Tabullet.UIScene
---@field Layout Sallo.App.Layout.Store
---@field PROJ Sallo.App
---@field new fun(self:Tabullet.UIScene, ProjNamespace:Sallo.App, UILayout:Tabullet.UILayout):Sallo.App.Scene.Store
local SCENE = class("Sallo.App.Scene.Store", TBL.UIScene)

---@class Sallo.App.Scene.Store.item_t
---@field type Sallo.App.Scene.Store.eItemType
---@field enumID number
---@field name string
---@field detail string
---@field unlocked boolean
---@field alreadyBuy boolean
---@field price number

---constructor
---@param ProjNamespace Sallo.App
---@param UILayout Sallo.App.Layout.Store
function SCENE:initialize(ProjNamespace, UILayout)
    TBL.UIScene.initialize(self, ProjNamespace, UILayout)

    ---@enum Sallo.App.Scene.Store.eItemType
    self.eItemType = { ["RANK"] = 1, ["THEMA"] = 2 }

    self.Layout.lb_items:setItemTemplate(function(obj)
        ---@cast obj Sallo.App.Scene.Store.item_t
        local result_string = ""
        if obj.type == self.eItemType.RANK then
            result_string = result_string .. "[RANK]" .. obj.name
        elseif obj.type == self.eItemType.THEMA then
            result_string = result_string .. "[THEMA]" .. obj.name
        end

        if obj.unlocked == true and obj.alreadyBuy == false then
            return result_string, nil, TBL.Enums.Color.blue
        end
        if obj.alreadyBuy == true then
            return result_string, nil, TBL.Enums.Color.white
        end
        if obj.unlocked == false then
            return result_string, nil, TBL.Enums.Color.red
        end
    end)

    self.Layout.lb_items.SelectedIndexChanged = function(obj)
        ---@type Sallo.App.Scene.Store.item_t
        local item = obj.obj
        self.Layout:setItemName(item.name)
        self.Layout:setItemPrice(item.price)
        self.Layout.tb_itemDetailC:setText(item.detail)

        self.Layout:itemDetail_control(true)
        if item.alreadyBuy == true or (item.unlocked == false) then
            self.Layout.bt_buy.Visible = false
        else
            self.Layout.bt_buy.Visible = true
        end
    end

    self.Layout.bt_arrow_down.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self.Layout.lb_items:setScroll(self.Layout.lb_items:getScroll() + 1)
        end
    end

    self.Layout.bt_arrow_up.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self.Layout.lb_items:setScroll(self.Layout.lb_items:getScroll() - 1)
        end
    end

    self.Layout.bt_back.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:goto_InfoMenu()
        end
    end

    self.Layout.bt_buy.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            local item = self.Layout.lb_items:getSelectedItem()
            if item ~= nil then
                ---@type Sallo.App.Scene.Store.item_t
                local item_t = item.obj
                self:buy_item(item_t)
            end
        end
    end

    self.Layout.bt_refresh_list.ClickEvent = function(obj, e)
        if e.Button == TBL.Enums.MouseButton.left then
            self:refresh_lb_from_server()
        end
    end
end

function SCENE:goto_InfoMenu()
    self:detachHandlers()
    self.PROJ.Sallo.Scene.InfoMenu:reset_before(self.PROJ.Sallo.Data.CurrentInfo)
    self.PROJ.Sallo.Scene.InfoMenu:reset()
    self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.InfoMenu)
end

---comment
---@param item_t Sallo.App.Scene.Store.item_t
function SCENE:buy_item(item_t)
    if item_t.type == self.eItemType.RANK then
        self:buy_item_rank_PIN(item_t.enumID)
    elseif item_t.type == self.eItemType.THEMA then
        self:buy_item_thema_PIN(item_t.enumID)
    else
        error("strange type value come, buy item " .. item_t.type)
    end
end

function SCENE:buy_item_rank_PIN(rankIndex)
    local infoName = self.PROJ.Sallo.Data.CurrentInfo.Name
    local infoPasswd = self.PROJ.Data.CurrentOwner.Password
    -- local accountPasswd = ""
    ---@type Sallo.Web.Protocol.Enum.RANK_NAME
    local rank = rankIndex
    self.PROJ.Scene.PIN:reset()
    self.PROJ.Scene.PIN:infoStr_normal("Input your account Passwd")
    self.PROJ.Scene.PIN.Event_bt_back = function(PIN)
        PIN:detachHandlers()
        self.PROJ.Sallo.Scene.Store:reset()
        self.PROJ.Sallo.Scene.Store:refresh_lb_from_server()
        self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.Store)
    end
    self.PROJ.Scene.PIN.Event_bt_enter = function(PIN)
        self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_BUY_RANK, function(msg, msgstruct)
            ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_BUY_RANK
            if msgstruct.Success == false then
                PIN:infoStr_error(sallo_protocol.Enum_INV.ACK_BUY_RANK_R_INV[msgstruct.State])
            else
                PIN.Event_bt_back(PIN)
            end
            self.PROJ.UIRunner:ReDrawAll()
        end)
        self.PROJ.Sallo.Client:send_BUY_RANK(infoName, infoPasswd, PIN.password, rank)
    end

    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)
end

function SCENE:buy_item_thema_PIN(themaIndex)
    local infoName = self.PROJ.Sallo.Data.CurrentInfo.Name
    local infoPasswd = self.PROJ.Data.CurrentOwner.Password
    -- local accountpasswd = ""
    ---@type Sallo.Web.Protocol.Enum.THEMA
    local thema = themaIndex
    self.PROJ.Scene.PIN:reset()
    self.PROJ.Scene.PIN:infoStr_normal("Input your account passwd!")
    self.PROJ.Scene.PIN.Event_bt_back = function(PIN)
        PIN:detachHandlers()
        self.PROJ.Sallo.Scene.Store:reset()
        self.PROJ.Sallo.Scene.Store:refresh_lb_from_server()
        self.PROJ.UIRunner:attachScene(self.PROJ.Sallo.Scene.Store)
    end
    self.PROJ.Scene.PIN.Event_bt_enter = function(PIN)
        self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_BUY_THEMA, function(msg, msgstruct)
            ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_BUY_THEMA
            if msgstruct.Success == false then
                PIN:infoStr_error(sallo_protocol.Enum_INV.ACK_BUY_THEMA_R_INV[msgstruct.State])
            else
                PIN.Event_bt_back(PIN)
            end
            self.PROJ.UIRunner:ReDrawAll()
        end)
        self.PROJ.Sallo.Client:send_BUY_THEMA(infoName, infoPasswd, PIN.password, thema)
    end

    self.PROJ.UIRunner:attachScene(self.PROJ.Scene.PIN)
end

function SCENE:reset()
    self.Layout.tb_info:setText("Anything to buy?")
    self.PROJ.Style.TB.Info(self.Layout.tb_info)
    self.Layout:itemDetail_control(false)
    self:refresh_lb_items()
end

function SCENE:detachHandlers()
    self.PROJ.Handle:clearAllMsgHandle()
    self.PROJ.Sallo.Handle:clearAllMsgHandle()
end

function SCENE:refresh_lb_from_server()
    self.PROJ.Sallo.Handle:attachMsgHandle(sallo_protocol.Header.ACK_GET_INFO, function(msg, msgstruct)
        ---@cast msgstruct Sallo.Web.Protocol.MsgStruct.ACK_GET_INFO
        if msgstruct.Success == false then
            self.Layout.tb_info:setText(sallo_protocol.Enum_INV[msgstruct.State])
            self.PROJ.Style.TB.InfoFail(self.Layout.tb_info)
        else
            self.Layout.tb_info:setText("Reload Infos")
            self.PROJ.Style.TB.InfoSuccess(self.Layout.tb_info)

            self.PROJ.Sallo.Data.CurrentInfo = msgstruct.Info
            self:refresh_lb_items()
            self.Layout:itemDetail_control(false)
            self.Layout.bt_buy.Visible = false
        end
        self.PROJ.UIRunner:ReDrawAll()
    end)
    self.PROJ.Sallo.Client:send_GET_INFO(self.PROJ.Sallo.Data.CurrentInfo.Name)
end

function SCENE:refresh_lb_items()
    local items = {}
    local currentInfo = self.PROJ.Sallo.Data.CurrentInfo


    for i = 1, 17, 1 do
        local nowRank = sallo_param.Rank[i]
        if nowRank.level_min <= currentInfo.Main.Level then
            ---@type Sallo.App.Scene.Store.item_t
            local a = {}
            a.enumID = i
            a.name = nowRank.rank_name
            a.detail = "upgrade your rank to " .. a.name
            a.type = self.eItemType.RANK
            a.price = sallo_param.Price.Rank[a.enumID].rankPrice

            a.alreadyBuy = false
            if (currentInfo.Main.Rank >= i) then
                a.alreadyBuy = true
            end
            a.unlocked = true
            if currentInfo.Main.Rank < nowRank.rank_rqr then
                a.unlocked = false
            end
            table.insert(items, a)
        end
    end


    for i = 1, 17, 1 do
        local price = sallo_param.Price.Thema[i]
        if price.unlocked_rank_level <= currentInfo.Main.Rank then
            ---@type Sallo.App.Scene.Store.item_t
            local a = {}
            a.enumID = i
            a.name = price.themaName
            a.detail = "Get new Thema " .. a.name
            a.type = self.eItemType.THEMA
            a.price = price.rankPrice

            a.alreadyBuy = false
            for kk, vv in pairs(currentInfo.Items) do
                if vv.ItemType == sallo_protocol.Enum.ITEM_TYPE.THEMA and
                    vv.ItemIndex == a.enumID then
                    a.alreadyBuy = true
                    break
                end
            end

            a.unlocked = false
            for kk, vv in pairs(currentInfo.Items) do
                if vv.ItemType == sallo_protocol.Enum.ITEM_TYPE.THEMA and
                    vv.ItemIndex == price.unlocked_thema_level then
                    a.unlocked = true
                    break
                end
            end
            if i == 1 then
                a.unlocked = true
            end
            table.insert(items, a)
        end
    end

    self.Layout.lb_items:setItemSource(items)
    self.Layout.lb_items:Refresh()
    self.Layout.lb_items:setScroll(1)
end

return SCENE
