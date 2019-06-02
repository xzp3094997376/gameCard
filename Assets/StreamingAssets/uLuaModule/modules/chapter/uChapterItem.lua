local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")
local chapterItem = {}

local chapterData = {}
local currentSection = 0
local trueChapter = 0
local updateScroll = false
local setstarhander = nil

--确定
function chapterItem:onClick(go,name)
    if name == "btn_baoxiang" or name == "btn_baoxiangkai" then
        if Player.Chapter.status[currentSection].bGotBox and self.boxState == false then
            self.boxState = Player.Chapter.status[currentSection].bGotBox
            self:setData()
        end
        chapterItem:getAwardHandler()
        return
    end
    if trueChapter < self.obj.ZJ then
        MessageMrg.show(TextMap.GetValue("Text_1_209"))
        MusicManager.playByID(19)
        return
    end

    if trueChapter == self.obj.ZJ then
        local tempObj = TableReader:TableRowByID(self.obj.ZJType, currentSection) --这一个格子最小的id
        if tempObj.section > trueSection then
            MessageMrg.show(TextMap.GetValue("Text_1_209"))
            MusicManager.playByID(19)
            return
        end
    end
    MusicManager.playByID(21)
    chapterFightPanel.Show(self.obj.ZJType, currentSection, 10)
end

function chapterItem:OnScroll(go,name,detal)
	local sv = self.obj.delegate:getScrollView()
	if sv ~= nil then
		sv:Scroll(detal)
	end
end

function chapterItem:onPress(go,name,bPress)
	if not GuideMrg:isPlaying() then	
          local sv = self.obj.delegate:getScrollView()
        	if sv ~= nil then
        		sv:Press(bPress);
        	end
        end
end

function chapterItem:OnDrag(go,name,detal)
    if not GuideMrg:isPlaying() then
    	local sv = self.obj.delegate:getScrollView()
    	if sv ~= nil then
    		sv:Drag();
    	end
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
    temp.ZJid =   currentSection
    -- --0 未完成  1 false 未领取 2 true 领取
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
    temp.delegate = self
    UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterboxtwo", temp)
    temp = nil
end


function chapterItem:getDropByTable(drop)
    local _list = {}
    if drop.Count == 1 then
        if self:isUsedType(drop[0].type) then
            local m = {}
            m.type = drop[0].type
            m.arg = drop[0].arg
            m.arg2 = drop[0].arg2 or 0
            table.insert(_list, m)
            m = nil
        end
    else
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

function chapterItem:setStar()
    if self.obj.ZJType == "commonChapter" then
        if Player.Chapter.status[currentSection] ~= nil then
            self.star = Player.Chapter.status[currentSection].star
            self.boxState = Player.Chapter.status[currentSection].bGotBox
        end
    elseif self.obj.ZJType == "hardChapter" then
        if Player.HardChapter.status[currentSection] ~= nil then
            self.star = Player.HardChapter.status[currentSection].star
            self.boxState = Player.HardChapter.status[currentSection].bGotBox
        end
    elseif self.obj.ZJType == "heroChapter" then
        if Player.NBChapter.status[currentSection] ~= nil then
            self.star = Player.NBChapter.status[currentSection].star
            self.boxState = Player.NBChapter.status[currentSection].bGotBox
            self.starPrefabs.gameObject:SetActive(false)
        end
    end
    if self.obj.ZJType ~= "heroChapter" then
        if self.starPrefabs ~= nil then
            self.starPrefabs:setStar(self.star)
            --Events.Brocast("updateChar")
        end
    end
end

--- 设置基本数据，根据当前关卡类型，当前类型关卡进度
function chapterItem:setData()
    self.starPrefabs:setStar(0)
    self.starPrefabs.gameObject:SetActive(true)
    self.star = 0
    self:setStar()
    
    self.gameObject.transform.localPosition = Vector3(chapterData.posx, chapterData.posy-45, 0) 
    self.chaptername.text = chapterData.show_name
    if updateScroll then
        self.binding:CallManyFrame(function()
            if chapterData.posy > 0 then
                self.obj.delegate:scrollViewPos((chapterData.posy) / 430 * 9)
            else
                self.obj.delegate:scrollViewPos((chapterData.posy - 100) / 430 * 9)
            end
        end, 1)
    end
    
    local chapterObj = TableReader:TableRowByID(self.obj.ZJType, currentSection) --拿到关卡数据
    --关卡宝箱
    local  box = chapterObj["box"]
    self._taskDrop = box
    if box.Count > 0 then
        if self.boxState then
            --已经领取
            self.btn_baoxiang.gameObject:SetActive(false)
            self.btn_baoxiangkai.gameObject:SetActive(true)
            self.baoxiangqude:SetActive(false)
        else
            --未领取 
            self.btn_baoxiang.gameObject:SetActive(true)
            self.btn_baoxiangkai.gameObject:SetActive(false)
            if self.star > 0 then 
                self.baoxiangqude:SetActive(true)
            else
                self.baoxiangqude:SetActive(false)
            end
            --Events.Brocast("CheckChuanguanPoint")
        end
    else
        self.btn_baoxiang.gameObject:SetActive(false)
        self.btn_baoxiangkai.gameObject:SetActive(false)
        self.baoxiangqude:SetActive(false)
    end

    self.ani:SetActive(false)
    if trueChapter == self.obj.ZJ then
        if chapterObj.section == trueSection then
            self.ani:SetActive(true)
			if self.hintMsg == nil then
				if Player.Info.level >= 5 and Player.Info.level <= 15 then 
					self.hintMsg = ClientTool.load("Prefabs/moduleFabs/chapterModule/gui_chapter_hint", self.gameObject)
					self.hintMsg.transform.localPosition = Vector3(-170, 15, 0)
				end 
			else
				if Player.Info.level >= 5 and Player.Info.level <= 15 then 
					self.hintMsg:SetActive(true)
				end
			end
		else 
			if self.hintMsg ~= nil then 
				self.hintMsg:SetActive(false)
			end 
        end
	else 
		if self.hintMsg ~= nil then 
			self.hintMsg:SetActive(false)
		end 
    end
end
--关闭界面
function chapterItem:OnDestroy()
   Events.RemoveListener("SetChuanguanStar", setstarhander)
end

function chapterItem:Start()
    setstarhander = function(params)
      chapterItem:setStar()
    end
    Events.AddListener("SetChuanguanStar", setstarhander)
end

function chapterItem:update(table)
    self.oldObj = self.obj
    self.obj = table[1]

    if self.obj.ZJType == "commonChapter" then
        trueChapter = Player.Chapter.lastChapter
        trueSection = Player.Chapter.lastSection
    elseif self.obj.ZJType == "hardChapter" then
        trueChapter = Player.HardChapter.lastChapter
        trueSection = Player.HardChapter.lastSection
    elseif self.obj.ZJType == "heroChapter" then
        trueChapter = Player.NBChapter.lastChapter
        trueSection = Player.NBChapter.lastSection
    end
    if trueChapter == 0 then
        trueChapter = 1
    end

    if  trueSection == 0 then
        trueSection = 1
    end
    chapterData = TableReader:TableRowByUniqueKey(self.obj.ZJType, self.obj.ZJ, self.obj.index)
    currentSection = chapterData.id
    updateScroll = false
    --print("self.obj.ZJ"..self.obj.ZJ)
    --print("self.obj.index"..self.obj.index)
    if self.obj.goIndex == nil or self.obj.goIndex <= 0 then
        if self.obj.ZJ == trueChapter then
            if trueSection == self.obj.index then
                updateScroll = true
            end
        else
            local temp = TableReader:TableRowByUniqueKey("chapter", self.obj.ZJ, self.obj.ZJType)
            if temp.totelSection == self.obj.index then
                updateScroll = true
            end

        end
    else
        if self.obj.goIndex == self.obj.index then
            updateScroll = true
        end
    end
    if self.oldObj == nil or self.obj.ZJType ~= self.oldObj.ZJType or self.obj.ZJ ~= self.oldObj.ZJ or self.obj.index ~= self.oldObj.index then
       self.textureEasy:LoadByModelId(chapterData.model, "idle", function() end, false, 2, 1, 255, 2)
    end
    --self.binding:CallManyFrame(function()
        self:setData()
   -- end, 0.01)
end

function chapterItem:create(binding)
	
    self.binding = binding
    return self
end

return chapterItem
