--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/7/6
-- Time: 16:42
-- To change this template use File | Settings | File Templates.
--

local m = {}

function m:update(lua)
    self.delegate = lua.delegate
    m:updateXiaoHuoBanList()
    m:updateTexture()
end

--点击事件
function m:onClick(go, name)
    print (name)
    if name == "btn_friend" then
        self.friendPanel.gameObject:SetActive(true)
        self.friendPanel:CallUpdate({ delegate = self.delegate })
    elseif name == "btn_fitter" then
        if self.toggle == true then
            self.imgList:SetActive(false)
            self.scrollview:SetActive(true)
            -- self.teamerOption:CallTargetFunction("resetTable")
            self:resetTable()
            self.toggle = false
        else
            self.imgList:SetActive(true)
            self.scrollview:SetActive(false)
            self.toggle = true
        end
    end
end

function m:isFull()
    return self.delegate:CheckFull()
end

--设置小伙伴列表是否可以拖拽
function m:SetTeamOptionCanDrop(ret)
    for i = 1, 8 do
        self["teamer_pos" .. i]:CallTargetFunction("isCanDrop", ret)
        self["teamer_pos" .. i]:CallTargetFunction("setRedPoint", false)
    end
end

--更新小伙伴列表
function m:updateXiaoHuoBanList(...)
    local infos = self.delegate:getXiaoHuoBan()
    local teams = Player.Team[12].chars
    m:SetTeamOptionCanDrop(false)
    local lv = Player.Info.level
    if infos == nil or self.levelList == nil then return end
	print("teamerOption------------------------")
    for i = 1, 8 do
        self["teamer_pos" .. i].name = i
        if self.levelList[i] > lv then --未解锁
            if teams[i-1] ~= nil and teams[i-1] ~= 0 and teams[i-1] ~= "0"  then
                self["teamer_pos" .. i]:CallTargetFunction("setLock", false, self.levelList[i],"teamer")
                self["teamer_pos" .. i]:CallUpdate({ data = infos[i], index = i - 1, delegate = self ,type="teamer"})
            else
                self["teamer_pos" .. i]:CallTargetFunction("setLock", true, self.levelList[i],"teamer")
            end
        else --已解锁
            self["teamer_pos" .. i]:CallTargetFunction("setLock", false, self.levelList[i],"teamer")
            self["teamer_pos" .. i]:CallUpdate({ data = infos[i], index = i - 1, delegate = self ,type="teamer"})
        end
    end
end

--更新上阵英雄texture
function m:updateTexture()
    local team = self.delegate:getGuiDaoInfo()
    for i = 1, 6 do
        if self["icon" .. i] ~= nil then
            local data = {}
            local url = ""
            local name = ""
            local star = 3
            local count = 0
            if team[i].char == nil then
                self["icon" .. i].gameObject:SetActive(false)
                url = ""
            else
                print (Tool.getDictId(team[i].char.id))
                local line = TableReader:TableRowByID("avter", Tool.getDictId(team[i].char.id))
                local tb = TableReader:TableRowByID("char",  Tool.getDictId(team[i].char.id) )
                url = team[i].char:getImage()
                url = string.gsub(url, "cardImage", "smallCardImg")
                name = line.name
                print (name)
                star = tb.star
                local tb = self.delegate:getFetter(team[i].char.id)
                local char =Char:new(team[i].char.id)
                count = #tb
                data.dictid =Tool.getDictId(team[i].char.id)
                data.path = url
                data.name = char.name
                data.star = star
                data.count = count
                data.modelid=char.modelid
                self["icon" .. i].gameObject:SetActive(true)
                self["icon" .. i]:CallTargetFunction("updateTexture", data)
            end
        end
    end
    self:setFetterInfo()
end

--设置上阵角色羁绊信息
function m:setFetterInfo()
    local team = self.delegate:getTeam()
    if team == nil then return end
    for i = 1, 6 do
        if team[i] == 0 or team[i] == "0" then --阵位无角色
        self["zhenwei" .. i].gameObject:SetActive(false)
        else --阵位有角色
        self["zhenwei" .. i].gameObject:SetActive(true)
        self["zhenwei" .. i]:CallUpdate({ delegate = self.delegate, charid = team[i] })
        end
    end
    self:resetTable()
end

function m:resetTable()
    for i = 1, 6 do
        self["zhenwei" .. i]:CallTargetFunction("resetTable")
    end
    self.binding:CallAfterTime(0.5, function()
        self.uitable.repositionNow = true
    end)
end

--检查该羁绊是否已经激活
function m:checkFetter(fetterId, list)
    if fetterId == nil or list == nil then
        print("fetterId or list is nil ")
        return nil
    end

    for i = 1, #list do
        if list[i] == fetterId then
            return true
        end
    end
    return false
end

--设置小伙伴阵位是否已经解锁
function m:setLock()
    local lv = Player.Info.level
    if self.levelList == nil then return end
    for i = 1, 8 do
        if self.levelList[i] > lv then --未解锁
        self["teamer_pos" .. i]:CallTargetFunction("setLock", true, self.levelList[i])
        else --已解锁
        self["teamer_pos" .. i]:CallTargetFunction("setLock", false, self.levelList[i])
        end
    end
end

function m:Start()
    self.max_slot = 6
    self.friend_count = 8
    for i = 1, 8 do
        self["teamer_pos" .. i].name = i
    end
    self.levelList = {}
    TableReader:ForEachLuaTable("relationship_config", function(index, item) --等级限制列表
    self.levelList[index + 1] = item.arg2
    return false
    end)
    self.toggle = true
end

return m