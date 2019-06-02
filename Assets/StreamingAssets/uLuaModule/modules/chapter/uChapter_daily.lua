local m = {}
local currentChapter = 1 --当前关卡
local totelChapter = 3 --总的关卡
local bindingArr = {}
local bindingArrLength = 0
local currentId = 0
local currentSection = 0
local totaltimes = -1 --总的可挑战的次数-1
local isInit = false

local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")


function m:sortAnalogData()
    if peopleDatas ~= nil then
        table.sort(peopleDatas, function(a, b)
            return a.char_num < b.char_num
        end)
    end
end

local selectHero
function m:selectCallBack(bind)
    if selectHero ~= nil then
        selectHero.open:SetActive(false)
        selectHero.normal.transform.rotation = Quaternion.identity
        selectHero.normal:SetActive(true)
    end
    selectHero = bind
end

--之所以这个方法里面这么多注释，这么乱，是因为策划需求改变，请勿删除注释代码
local peopleDatas = {}
local peopleCounts = 0
function m:setData()
	local temp = peopleDatas[self.sIndex - 1]

    self.dec1.text=temp.desc2
    self.dec2.text=temp.desc
	
	local diffList = self:getAllDiffChapter(temp.id)
	
	local col = math.floor((#diffList + 2) / 3)
    currentId = temp.id
    currentSection=diffList[self.sectionIndex].id
	
	for i = 1, #diffList do
		self.itemContent.transform:GetChild(i-1):GetComponent(UluaBinding):CallUpdate({index = i, data = diffList[i],delegate=self})
	end
	
	m:setRetText()

	local sc = TableReader:TableRowByID("specialChapter", currentSection)
	local data = TableReader:TableRowByID("avter", sc.model)
    self.img_hero:LoadByModelId(data.id, "idle", function() end, false, 0, 1)
	--local imageUrl = UrlManager.GetImagesPath("cardImage/" .. data.full_img_d .. ".png")
    --self.img_hero.Url = imageUrl
    local drop =m:getDropDate(diffList[self.sectionIndex].drop)
    if drop ~=nil then 
        if self.iconItem ==nil then 
            self.iconItem =ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.Pic.gameObject)
        end
        self.iconItem.gameObject:SetActive(true)
        self.iconItem:CallUpdate({ "char", drop[1], self.Pic.width, self.Pic.height,true})
        self.name.text = drop[1]:getDisplayColorName()
        self.dropType = drop[1].item_item.type
        if drop[1].item_item.type=="gold" or drop[1].item_item.type=="money" then 
            self.num.text = toolFun.moneyNumberShowOne(math.floor(tonumber(drop[1].item_item.arg)))
        else
            if drop[1].item_item.times.Count > 1 then
                self.num.text = drop[1].item_item.arg2 * drop[1].item_item.times[0] .. "~" .. drop[1].item_item.arg2 * drop[1].item_item.times[1]
            elseif drop[1].item_item.times.Count == 1 then
                self.num.text= drop[1].item_item.arg2 * drop[1].item_item.times[0]
            end
        end
    else
        if self.iconItem ~=nil then 
            self.iconItem.gameObject:SetActive(false)
        end
    end

    local consume =diffList[self.sectionIndex].consume
    if consume~=nil then 
        self.xiaohao.text =consume[0].consume_arg
    else 
        self.xiaohao.text="0"
    end
end

function m:getAllDiffChapter(id)
	local list = {}
	local i = 1
	TableReader:ForEachLuaTable("specialChapter", function(index, item)
		if item.chapter == id then
			list[i] = item
			i = i + 1
		end
		return false
    end)
	return list
end

function m:getDropDate(lua)
    local list={}
    local drop = lua
    local count = drop.Count
    for i=0,count-1 do
        local item
        local cell = drop[i]
        local type = cell.type
        if type == "char" and cell.arg ~=nil and cell.arg ~=0 then
            item = Char:new(nil,cell.arg)
            item.isRes = true
            if item.info.level > 0 then
                item = CharPiece:new(item.id)
                item.isRes = true
                item.__count = item.needCharNumber
            end
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "charPiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = CharPiece:new(cell.arg)
            item.isRes = true
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "equip" and cell.arg ~=nil and cell.arg ~=0 then
            item = Equip:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "equipPiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = EquipPiece:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "ghostPiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = GhostPiece:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "ghost" and cell.arg ~=nil and cell.arg ~=0 then
            item = Ghost:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "treasure" and cell.arg ~=nil and cell.arg ~=0 then
            item = Treasure:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "treasurePiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = TreasurePiece:new(cell.arg,cell.arg2)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "reel" and cell.arg ~=nil and cell.arg ~=0 then
            item = Reel:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "reelPiece" and cell.arg ~=nil and cell.arg ~=0 then
            item = ReelPiece:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            table.insert(list, item)
        elseif type == "item" and cell.arg ~=nil and cell.arg ~=0 then
            item = uItem:new(cell.arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type 
            table.insert(list, item)
        else
            item = uRes:new(type, arg)
            item.item_pos = i
            item.item_item = cell
            item.item_type=type
            item.isRes = true
            table.insert(list, item)
        end
    end
    return list
end

function m:getsectionIndex()
    local temp = peopleDatas[self.sIndex - 1]
    local _index = 1
    TableReader:ForEachLuaTable("specialChapter", function(index, item)
        if item.chapter == temp.id then
            if item.unlock[0].unlock_arg<=Player.Info.level and self.sectionIndex<_index then 
                self.sectionIndex=_index
            end 
            _index=_index+1
        end
        return false
    end)
end

function m:Start()
	TableReader:ForEachLuaTable("specialChapter_config",
    function(index, item)
        peopleDatas[index] = item
        peopleCounts = peopleCounts + 1
        return false
    end)
    Events.AddListener("updateShiLian",
    function(params)
        m:setRetText()
    end)
end
function m:update()
    self.sIndex =m:getFristIndex(peopleDatas)
    self.sectionIndex=1--难度
    local list = m:getData(peopleDatas)
    self.daily_list:refresh(list, self, false, 0)
    self.binding:CallAfterTime(0.1,function()
        self.daily_list:goToIndex(self.sIndex-1)
    end)
    m:getsectionIndex()
    m:setData()
end

function m:OnDestroy()
    Events.RemoveListener('updateShiLian')
end

function m:getFristIndex(data)
    for i = 0, table.getn(data) do
        local d = data[i]
        d.realIndex = i+1
        d.delegate = self
        if m:specialChapterIsOpen(d) ==true then 
            return i+1
        end 
    end
    return 1
end

function m:getData(data)
    local list = {}
    for i = 0, table.getn(data) do
        local d = data[i]
        d.realIndex = i+1
		d.delegate = self
		table.insert(list, d)
    end
    local openList={}
    local notOpenList={}
    table.foreach(list, function(i, v)
        if m:specialChapterIsOpen(v) ==true then 
            --print ("open" .. i)
            table.insert(openList, v)
        else 
            table.insert(notOpenList, v)
        end 
    end)
    list =openList
    table.foreach(notOpenList, function(i, v)
        table.insert(list, v)
        end)

    return list
end

function m:specialChapterIsOpen(data)
    local _open=false
    local needLevel = data.des3
    if needLevel <= Player.Info.level then
        _open=true
        local isopen = Player.specialChapter[data.id].open
        --print (isopen)
        if isopen ==false then 
            _open=false
        end
    else
        _open = false
    end
    return _open
end

function m:setRetText()
    local specialChapter = Player.specialChapter[currentId]
    local times = specialChapter.max_fight - specialChapter.fight
    self.txt_count.text = TextMap.FIGHT_TIMES .. "[00ff00]" .. times
end

function m:updateItem(id, index, item)
	currentId = id
	self.sIndex = index
    self.sectionIndex=1
    self:getsectionIndex()
	self:setData()
	--self:onUpdate(false, false)
	--if self.tab then
    --    self.tab:CallUpdate({ delegate = self, char = self.char })
    --end
end

function m:updateSection(id, index, item)

    currentSection = id
    self.sectionIndex = index
    self:setData()
    --self:onUpdate(false, false)
    --if self.tab then
    --    self.tab:CallUpdate({ delegate = self, char = self.char })
    --end
end



function m:onUpdate()
    TableReader:ForEachLuaTable("specialChapter_config", function(index, item)
        if item.type == self._typeEN then
            moduleBaseData[item.id] = item
            local tempData = {}
            tempData.data = item
            --tempData.callBack = self.callBackClick

            local infobind = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/offer_challenge/fubenItem", self.Grid.gameObject)
            infobind:CallUpdate(tempData)
            table.insert(fubenItems, { bind = infobind, data = tempData })
        end

        return false
    end)

    self.binding:CallManyFrame(function()
        self.scrollview:ResetPosition()
    end)
end

function m:onEnter()
    local list = m:getData(peopleDatas)
    self.daily_list:refresh(list, self, false, 0)
    self.binding:CallAfterTime(0.1,function()
        self.daily_list:goToIndex(self.sIndex-1)
    end)
    m:setData()
end

function m:onEnable()
    peopleCounts = 0
    local list = m:getData(peopleDatas)
    self.daily_list:refresh(list, self, false, 0)
    self.binding:CallAfterTime(0.1,function()
        self.daily_list:goToIndex(self.sIndex-1)
    end)
    m:setData()
end

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

-- lzh 2015.05.07
-- 获取可挑战的次数
function m:getTotaltimes()
    --[[if totaltimes == -1 then
        local row = TableReader:TableRowByID("heroChapter_config", "max_time")
        if row.args1 ~= nil and tonumber(row.args1) ~= nil then
            totaltimes = row.args1
        else
            totaltimes = 0
        end
    end
    local lefttimes = totaltimes + Player.NBChapter.resettimes - Player.NBChapter.totaltimes
    return lefttimes;]]
    local specialChapter = Player.specialChapter[currentId]
    local times = specialChapter.max_fight - specialChapter.fight
    return times
end

function m:onClick(go, name)
    if name == "btn_add" then
        local buyType = "xs" .. currentId
        DialogMrg:BuyBpAOrSoul(buyType, "", toolFun.handler(self, self.updateForBuyBpAOrSoul),
            toolFun.handler(self, self.BuyBpAOrSoul_Change),
            toolFun.handler(self, self.SendResetAPI))
    elseif name == "up" then 
        self.scroll:Scroll(-1)
    elseif name == "bottom" then 
        self.scroll:Scroll(1)
    elseif name == "btn_battle" then
        if Tool.CheckTypeBagCount(self.dropType, 4) == false then return end
        if m:isOpen()==true then
            local temp = peopleDatas[self.sIndex - 1]
            if Player.specialChapter[currentId].open ==true then 
                local diffList = self:getAllDiffChapter(temp.id)
                local section=diffList[self.sectionIndex]
                Api:fightSpecialChapter(section.id, LuaMain:getTeamByIndex(0), 0, function(result)
                    Events.Brocast("updateShiLian")
                    print(Player.specialChapter[currentId].fight)
                    local fightData = {}
                    fightData["battle"] = result
                    fightData["mdouleName"] = "shilian"
                    fightData["id"] = section.id
                    fightData["arr"] = arr
                    UIMrg:pushObject(GameObject())
                    fightData["team"] = 0
                    UluaModuleFuncs.Instance.uOtherFuns:callBackFight(fightData)
                    fightData = nil
                    end, function(ret, reuslt)
                    return false
                    end)
            else 
                local arg =temp.remark
                MessageMrg.show(arg) 
            end 
        else
            local arg = m:getLockNum()
            tipsShowStr =string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",arg)
            MessageMrg.show(tipsShowStr)
        end
    end
end

--false 未解锁  true 已解锁
function m:isOpen()
    local temp = peopleDatas[self.sIndex - 1]
    if temp.des3 > Player.Info.level then
        return false
    else 
        local diffList = self:getAllDiffChapter(temp.id)
        local section=diffList[self.sectionIndex]
        if section.unlock[0].unlock_arg> Player.Info.level then
            return false
        else
            return true
        end
    end
end

function m:getLockNum()
    local temp = peopleDatas[self.sIndex - 1]
    if temp.des3 > Player.Info.level then
        return temp.des3
    else 
        local diffList = self:getAllDiffChapter(temp.id)
        local section=diffList[self.sectionIndex]
        if section.unlock[0].unlock_arg> Player.Info.level then
            return section.unlock[0].unlock_arg
        else
            return 0
        end
    end
end

function m:SendResetAPI(dlg)
    Api:resetSpecialChapterTicket(currentId, function(result)
        self:setRetText()

        if dlg ~= nil then
            if dlg.refreash ~= nil then
                dlg:refreash()
            end

            if dlg.showMoveDlg ~= nil then
                dlg:showMoveDlg()
            end
        end
    end)
end

function m:BuyBpAOrSoul_Change()
    self:updateForBuyBpAOrSoul()
end

function m:updateForBuyBpAOrSoul()
    self:setRetText()
end

return m