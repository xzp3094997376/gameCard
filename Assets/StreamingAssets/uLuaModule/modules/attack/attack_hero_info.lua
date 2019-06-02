-- 跨服比武挑战前三名玩家详细信息
local m = {}

function m:Start(...)
    ClientTool.AddClick(self.bg, funcs.handler(self, self.onClose))
    self.max_count = Player.CrossContest.max_fight 
    self.has_count = Player.CrossContest.has_fight
    self:readTable()
end

function m:onClose()
    UIMrg:popWindow()
end

function m:update(data)
    if data == nil then return end
    self.data = data
    self.name = data.name
    self.team = json.decode(data.team:toString())
    self.level = data.level
    self.vip = data.vip
    self.power = data.power
    self.sid = data.sid
    self.index = data.index
    self.defenceChar = data.defenceChar
    if self.hero ~= nil then
        local id = self:getChar(self.team)
        self.hero:LoadByCharId(id, "stand", function(ctl) end)
    end
    if self.index ~=nil then
        self.sprite_title.spriteName = "ZJM-TZSJ-tiaozhan_"..self.index
    end
    self.txt_power.text = self.power or 0
    self.txt_lv_name.text = "Lv"..self.level..self.name
    self.txt_count.text = TextMap.GetValue("Text_1_183")..(self.max_count - self.has_count)

    local drop = self.tabelData[self.index]
    if drop ~= nil then
        drop = self:updateDrop(drop)
        for i=1,#drop do
            local binding1 = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/mailModule/mail_item_in", self.grid.gameObject)
            binding1:CallUpdate(drop[i])
        end
    end
end

--获取玩家模型id
function m:getChar(list)
    for k,v in pairs(list) do
        if v ~= "" and v ~= "null" and v ~= 0 and v ~= nil then
            return v
        end
    end
    return 1
end

--读取配表
function m:readTable()
    self.tabelData = {}
    for i=1,3 do
        local row = TableReader:TableRowByID("statueReward", i.."_fail_drop")
        if row ~= nil then
            local drop = self:getDropByTable(row.drop)
            table.insert(self.tabelData,drop)
        end
    end
end

function m:updateDrop(drop)
    local m = {}
    table.foreach(drop, function(k, v)
        local l = {}
        l.v = v
        l.showName = true
        l.isGet = false
        l.isShowTips = false
        table.insert(m, l)
        l = nil
    end)
    return m 
end

function m:getDropByTable(drop)
    local _list = {}
    if drop[0] ~= nil then
        local m = {}
        m.type = drop[0].type
        m.arg = "" --drop[0].arg
        m.arg2 = ""--drop[0].arg2 or 0
        table.insert(_list, m)
        m = nil
    end
    for i=1,drop.Count-1 do
        local d = drop[i]
        local m = {}
        m.type = d.type
        m.arg = d.arg
        m.arg2 = ""--d.arg2
        table.insert(_list, m)
        m = nil
    end
    return _list
end

function m:onClick(go, name)
    if name == "btn_info" then 
        if self.defenceChar ~= nil then
            UIMrg:pushWindow("Prefabs/moduleFabs/attack/attack_hero_team", self.defenceChar)
        end
    elseif name == "btn_fight" then
        if self.index == nil then return end
        Api:fightTop3(self.index,function (result)
            UIMrg:popWindow()
            local fightData = {}
            fightData["battle"] = result
            fightData["mdouleName"] = "fightTop3"
            UIMrg:pushObject(GameObject())
            UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
            fightData = nil
        end)
    end
end

return m