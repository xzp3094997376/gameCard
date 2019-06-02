local rList = {}
local playerList = {}
local timeId = -1 --定时器id

function rList:Start(...)
    --好友
    require("uLuaModule/modules/friends/friendUtil.lua")

    friendUtil.SetRecommendView(self)
    --获取推荐列表
    self:getList()
    self:SetRefreshTime(friendUtil.Recommend.CurRefreshTime)
end

function rList:OnDestroy()
    --好友
    require("uLuaModule/modules/friends/friendUtil.lua")

    friendUtil.SetRecommendView(nil)
end

function rList:getList(...)
    playerList = {}
    Api:randomPlayer(function(result)
        local count = result.list.Count
        for i = 0, count - 1 do
            local m = {}
            m.pid = result.list[i].pid
            m.gameUserId = result.list[i].pid
            m.sociatyName = result.list[i].guild
            m.guild = result.list[i].guild
            m.name = result.list[i].name
            m.level = result.list[i].level
            m.vip = result.list[i].vip
            m.head = result.list[i].head
            m.power = result.list[i].power
            m.online = result.list[i].online
			m.star = result.list[i].quality
			m.dictid = result.list[i].playerid
            if m.name ~= nil then
                table.insert(playerList, m)
            end
            m = nil
        end

        self.desc.gameObject:SetActive(count <= 0)
        self.view:refresh(playerList, self, true, 0)
    end, function()
    end)
end

--删除相应的item
function rList:deleteItem(index)
    table.remove(playerList, index)
    self.view:refresh(playerList, self, true, 0)
end

function rList:update(...)
    -- body
end

function rList:onRefresh()
    self:getList()
    --开始计时
    friendUtil.CountDownRefresh()
end

function rList:SetRefreshTime(curTime)
    if curTime > 0 then
        self.refresh.isEnabled = false
        self.refreshTime.text =string.gsub(TextMap.GetValue("LocalKey_687"),"{0}",curTime)
    else
        self.refresh.isEnabled = true
        self.refreshTime.text =string.gsub(TextMap.GetValue("LocalKey_687"),"{0}",friendUtil.Recommend.MinRefreshTime)
    end
end


function rList:onClick(go, name)
    if name == "btn_close" then
        self:onClose()
    elseif name == "refresh" then
        self:onRefresh()
    end
end

function rList:onClose(...)
    playerList = nil
    if timeId ~= -1 then
        LuaTimer.Delete(timeId)
    end
    UIMrg:popWindow()
end

return rList