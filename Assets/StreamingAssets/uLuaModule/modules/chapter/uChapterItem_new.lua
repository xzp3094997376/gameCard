local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")
local chapterItem = {}

local currentUrl = "" --关卡图片路径
--local topologyData = {}
local currentSection = 0
local trueChapter = 0
local items  = {}
--关闭奖励显示
function chapterItem:destory()
    SendBatching.DestroyGameOject(self.binding.gameObject)
end

--确定
function chapterItem:onClick(go,name)
    if name == "btn_box" then     
        chapterItem:getAwardHandler()
    else
        if self.obj.data.chapter ~= self.obj.chapter.currentSelectChapter then
            return
        end
        if trueChapter < self.obj.data.chapter then
            MessageMrg.show(TextMap.GetValue("Text_1_209"))
            MusicManager.playByID(19)
            return
        end

        if trueChapter == self.obj.data.chapter then
           --local tempObj = TableReader:TableRowByID(self.obj.ZJType, topologyData.include_chapterid[0]) --这一个格子最小的id
           if self.obj.data.section > self.obj.currentSelectSection then
                MessageMrg.show(TextMap.GetValue("Text_1_209"))
                MusicManager.playByID(19)
                return
            end
        end
        MusicManager.playByID(21)
        chapterFightPanel.Show(self.obj.ZJType, self.obj.data.id, 10, self.star, self.full)
    end

end



function chapterItem:getAwardHandler()
    if self._taskDrop == nil then
        return
    end
    local temp = {}
    temp.obj = chapterItem:getDropByTable(self._taskDrop)
    --index
    temp.ZJType = self.obj.ZJType
    temp.ZJid =   self.obj.data.id
    -- --0 未完成  1 完成了未领取 2 已完成并领取
    if self.star < 1 then
        temp.state = 0 
    else
        if self.boxState then
            temp.state = 2
        else
            temp.state = 1
        end
    end
    temp._go = self.binding.gameObject
    UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterboxtwo", temp)
    temp = nil
end

function chapterItem:getDropByTable(drop)
    local _list = {}
    for i = 0, drop.Count - 1 do
        if self:isUsedType(drop[i].type) then

            local d = drop[i]
            local m = {}
            m.type = d.type
            m.arg = d.arg
            m.arg2 = d.arg2
            table.insert(_list, m)
            m = nil
        end
    end
    
    return _list
end

function chapterItem:isUsedType(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece", "money", "gold", "bp", "soul", "popularity", "credit", "honor", "donate", "exp", "hunyu", "ghost", "ghostPiece" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end


function chapterItem:getTypeSpriteName(_type, state)
    if _type == "hardChapter" then
        return "diffsmall_" .. state
    elseif _type == "hellChapter" then
        return "hellsmall_" .. state
    end
end

function chapterItem:update(obj)
    self.obj = obj
	self.star = 0
	self.txtId.text = obj.data.id
	self.txtName.text = obj.data.name
	self.starPrefabs:setStar(0)
    self.starPrefabs.gameObject:SetActive(true)
	currentSection = obj.data.section
    if self.obj.ZJType == "commonChapter" then
    	trueChapter = Player.Chapter.lastChapter
        self.starPrefabs:setStar(Player.Chapter.status[self.obj.data.id].star)
		self.star = Player.Chapter.status[self.obj.data.id].star
        self.boxState =  Player.Chapter.status[self.obj.data.id].bGotBox
    elseif self.obj.ZJType == "hardChapter" then
    	trueChapter = Player.HardChapter.lastChapter
        self.starPrefabs:setStar(Player.HardChapter.status[self.obj.data.id].star)
		self.star = Player.HardChapter.status[self.obj.data.id].star
        --self.chapter_type.spriteName = chapterItem:getTypeSpriteName(self.obj.ZJType, "normal")
        self.boxState =  Player.HardChapter.status[self.obj.data.id].bGotBox
    end
	
	self.tempItemData = {}
	local chapterObj = TableReader:TableRowByID(self.obj.ZJType, obj.data.id) --拿到关卡数据


    --关卡宝箱
    --print(self.obj.ZJType.."第几章...........第几关".. obj.data.id)
    local  box = chapterObj["box"]
    --print_t(box)
    self._taskDrop = box
    if box.Count > 0 then
        self.btn_box.gameObject:SetActive(true)
    else
        self.btn_box.gameObject:SetActive(false)
    end

    if self.boxState then
        --已经领取
        self.sp_box.spriteName = "xiangzi2"
        
    else
        --未领取 
        self.sp_box.spriteName = "xiangzi1"
    end

    

    

	local dropCount = chapterObj.probdrop.Count - 1
    for i = 0, dropCount do
        local itemobj = TableReader:TableRowByUnique(chapterObj.probdrop[i]["type"], "name", chapterObj.probdrop[i]["arg"])
        local vo = itemvo:new(chapterObj.probdrop[i]["type"], 1, itemobj.id, 1, "1")
        self.tempItemData[i + 1] = vo
    end
    if self.tempItemData ~= nil then
        table.sort(self.tempItemData, function(a, b)
            return a.itemTrueColor > b.itemTrueColor
        end)
    end
	local tempCount = dropCount
	if tempCount > 1 then tempCount = 1 end
    for j = 0, tempCount do
		if items[j+1] == nil then 
			local infobinding = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/chapterItemCell", self.rewardGrid.gameObject)
			items[j+1] = infobinding
		end
		items[j+1]:CallUpdate(self.tempItemData[j + 1])
        --infobinding = nil
        vo = nil
    end
	
	local data = TableReader:TableRowByID("avter", self.obj.data.model)
	local imageUrl = UrlManager.GetImagesPath("cardImage/" .. data.full_img_d .. ".png")
    self.hero.Url = imageUrl
	self.full = data.full_img_d
	
	if trueChapter == self.obj.data.chapter then
       if self.obj.data.section > self.obj.currentSelectSection then
			self.hero:changeColor({ 0.4, 0.4, 0.4 })
        else
			self.hero:changeColor({ 1, 1, 1 })
		end
    end
	
	if chapterObj.boss < 1 then 
		self.imgBoss.gameObject:SetActive(false)
	else
		if chapterObj.boss == 1 then 
			self.imgBoss.spriteName = "chapter_skull"
		elseif chapterObj.boss == 2 then 
			self.imgBoss.spriteName = "chapter_big_boss"
		end 
		self.imgBoss.gameObject:SetActive(true)
	end
	
	local times = chapterObj.fight_times - Player.HardChapter.status[obj.data.id].fight
    if chapterObj.fight_times <= 0 then
        self.txtNum.gameObject:SetActive(false)
        --self:setData()
        return
    end
    if times <= 0 then
        times = 0
        times = "[ff0000]" .. times .. "[-]"
    else
        times = "[00ff00]" .. times .. "[-]"
    end
	self.txtNum.gameObject:SetActive(true)
    self.txtNum.text = TextMap.GetValue("Text15") .. times .. "/" .. chapterObj.fight_times
end

function chapterItem:create(binding)
    self.binding = binding
    return self
end

function chapterItem:showEffect(index)
    self.effect = ClientTool.load("Effect/Prefab/chuangguan_frame0" .. index, self.Image.gameObject)
    self.effect.gameObject.transform.localPosition = Vector3(0, 0, 0)
    Events.Brocast("showHand", self.gameObject)
end

function chapterItem:destoryEffect()
    if self.effect == nil then
        return
    end
    GameObject.Destroy(self.effect)
    self.effect = nil
end

function chapterItem:Start()
	--UIEventListener.Get(self.gameObject).onClick = self.onClick
end

return chapterItem
