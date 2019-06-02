local chapterFightPanel = require("uLuaModule/modules/chapter/uChapterFight.lua")
local chapter = {}
local isLinkOpen = false
local lastMoveChapter = -1
local currentBing = {}
local lastOpenLocation

local totelChapter = 1 --各种条件下，能打开的最后一章的关卡
local currentChapterType = "nothing" -- 当前章节类型
local currentSelectSection = -1 --玩家选择打开的小节

local nicelho = false --是否是内部切换

local cRealChapterDataSet = nil

--关闭界面
function chapter:OnDestroy()
    chapter = nil
    lastOpenLocation = nil
    isLinkOpen = false
    Events.RemoveListener('showHand')
    Events.RemoveListener("FindDaXu")
end

function chapter:setDelegate(delegate)
	self.delegate = delegate
end 

function chapter:setChapterType(chapter_type)
    if currentChapterType == chapter_type then
        return true
    end
    if chapter_type == "commonChapter" then
        openArg = { 1, 0, chapter_type }
        chapter:update(openArg)
        return true
    end
    if chapter_type == "hardChapter" then
        local linkData = Tool.readSuperLinkById( 240)
        local limitLv = linkData.unlock[0].arg
        linkData = nil
        if Player.Info.level < limitLv then
            MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_824"),"{0}",limitLv))
            return false
        end
        openArg = { 1, 0, chapter_type }
        chapter:update(openArg)
        return true
    end
    if chapter_type == "heroChapter" then
        local linkData = Tool.readSuperLinkById( 5)
        local limitLv = linkData.unlock[0].arg
        linkData = nil
        if Player.Info.level < limitLv then
            MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_825"),"{0}",limitLv))
            return false
        end
        openArg = { 1, 0, chapter_type }
        chapter:update(openArg)
        return true
    end
end

-- 忍者入侵
function chapter:enemyInvade(currentChapterType)
	-- 精英副本才有入侵
	if currentChapterType == "hardChapter" then
		if self:isOpenEnemyInvade() then
			if self.enemyUI == nil then 
				self.enemyUI = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/gui_enemy_invade", self.con)
			else 
				self.enemyUI.gameObject:SetActive(true)
			end 
			self.enemyUI:CallUpdate({ delegate = self })
		else
			if self.enemyUI ~= nil then 
				self.enemyUI.gameObject:SetActive(false)
			end
		end
	else
		if self.enemyUI ~= nil then 
			self.enemyUI.gameObject:SetActive(false)
		end
	end
end

function chapter:isOpenEnemyInvade()
	local cps = Player.ninjaIntrusion:getLuaTable()
	for k, v in pairs(cps) do
		if v.status == 1 then -- 1正入侵 0 未入侵 2 已打败
			return true
		end 
	end
	return false
end 

---------------------------------------------------------------------------------------------------------------------------------------------------
-- 开始设置数据

--1.外部超链接或者固定链接打开关卡界面
--tables[2]   0表示超链接打开直接到最新章节   -1 超链接打开到指定章节
function chapter:update(tables)
    chapter:SetTaoRenActive()
    --currentSelectSection = -1
    --self.currentSelectChapter = -1
    lastOpenLocation = tables
    local chapterTable = {}
    local refreshName = false
    local refreshChaptercontest = false
    if currentChapterType ~= tables[3] then
        refreshName = true
        refreshChaptercontest = true
        currentChapterType = tables[3]
	end
    self.moving = false

	local list = {} 
	local tempLastSection = 0
    if currentChapterType == "commonChapter" then
        list = chapter:getChapterOpen(currentChapterType)
        tempLastSection = Player.Chapter.lastSection
		self:replaceTitle("commonChapter")
    elseif currentChapterType == "hardChapter" then
        list = chapter:getChapterOpen(currentChapterType)
        tempLastSection = Player.HardChapter.lastSection
		self:replaceTitle("hardChapter")
    elseif currentChapterType == "heroChapter" then
        list = chapter:getChapterOpen(currentChapterType)
        tempLastSection = Player.NBChapter.lastSection
		self:replaceTitle("heroChapter")
    end
  
    if tables[1] > totelChapter then
        MessageMrg.show(TextMap.GetValue("Text_1_197"))
        --return
        tables[1] = nil
        tables[2] = nil
    end
    if tables[1] == totelChapter and tables[2] > tempLastSection then
        --MessageMrg.show("指定小节未开启！")
        tables[2] = nil
        --return
    end
    if tables[2] ~= nil and tables[2] > 0 then
        if currentSelectSection ~= tables[2] then
            refreshChaptercontest = true
        end
        currentSelectSection = tables[2]
    else
        if currentSelectSection ~= tempLastSection then
            refreshChaptercontest = true
        end
        currentSelectSection = tempLastSection
    end
    if totelChapter == 0 then
        totelChapter = 1
    end
    if currentSelectSection == 0 then
        refreshChaptercontest = true
        currentSelectSection = 1
    end
    
    if tables[1]  ~= nil and tables[1] > 0 and tables[2] ~= 0 then
        if self.currentSelectChapter ~= tables[1] then
            refreshName = true
            refreshChaptercontest = true
        end
        self.currentSelectChapter = tables[1]

    else
        if self.currentSelectChapter ~= totelChapter then
            refreshName = true
            refreshChaptercontest = true
        end
        self.currentSelectChapter = totelChapter
    end
    self.sIndex = self.currentSelectChapter
    local tempid = self.currentSelectChapter - 2
    if tempid < 0 then
        tempid = 0
    end
    if refreshName == true then
        list = self:getData(list, currentChapterType)
    	self.hero_list_bg:refresh(list, self, false, tempid)
        if self.currentSelectChapter - 2 > 0 then
            self.binding:CallAfterTime(0.01,
            function()
                self.hero_list_bg:goToIndex(tempid)
                self.nameScrollView:Scroll(0.2)  
            end)
        else
        end
    else
        self.nameScrollView:Scroll(0.1)  
        --Events.Brocast("CheckChuanguanPoint")
    end

    if currentChapterType == "heroChapter" then
        self.heroTime:SetActive(true)

        local row = TableReader:TableRowByID("heroChapter_config", "max_time")
        local totaltimes = 0
        if row.args1 ~= nil and row.args1.Count > 0 then
            totaltimes = row.args1[Player.Info.vip]
        end

        local lefttimes = totaltimes - Player.NBChapter.totaltimes

        self.hero_time.text = lefttimes .. ""
    else
        self.heroTime:SetActive(false)
    end
	
	self.chapterName.text = ""
	if list[self.sIndex] ~= nil then 
		local tb = split(list[self.sIndex].name, "：")
		self.chapterName.text = tb[2] or ""
	end 
    if refreshChaptercontest == true then
	   self:updateSubChapter(self.sIndex)
    else
        Events.Brocast("SetChuanguanStar")
        Messenger.Broadcast("ChapterMoveEnd")--新手引导的监听
    end
    self:updateContent()
    self:showSumStar(currentChapterType)
	self:enemyInvade(currentChapterType)
end

function chapter:SetTaoRenActive()
    local isDaxu = Tool.checkTaoRen()
    self.TaoRenInfo.gameObject:SetActive(isDaxu or false)
    if isDaxu then
        self.TaoRenInfo:CallUpdate()
    end
end

--检查是否有逃忍出现
function chapter:showTaoRenInfo()
    Events.Brocast("FindDaXu")
end

function chapter:showSumStar(curChapTpye)
    local starNum = 0
   local chapterDate = TableReader:TableRowByUniqueKey("chapter", self.currentSelectChapter, currentChapterType)
   for i = 1, chapterDate.totelSection do
        local c = TableReader:TableRowByUniqueKey(curChapTpye, self.currentSelectChapter, i)
        if curChapTpye == "commonChapter" then 
            starNum = starNum + Player.Chapter.status[c.id].star
        elseif curChapTpye == "hardChapter" then 
            starNum = starNum + Player.HardChapter.status[c.id].star
        elseif currentChapterType == "heroChapter" then
            starNum = starNum + Player.NBChapter.status[c.id].star
        end
   end
    self.txt_star.text = starNum .. "/".. chapterDate.totelSection * 3
    starNum = nil
    self:showOrHideBtn()
end

function chapter:getRealChapter()
    if cRealChapterDataSet == nil then
        cRealChapterDataSet = {}
        TableReader:ForEachLuaTable("chapter",
        function(index, item)
            if cRealChapterDataSet[item.cha_type] == nil then
                cRealChapterDataSet[item.cha_type] = {}
            end

            table.insert(cRealChapterDataSet[item.cha_type], item)
        end)
    end
end

function chapter:getChapterOpen(ctype)
    local list = {}
    if cRealChapterDataSet == nil then
        self:getRealChapter()
    end

    list = cRealChapterDataSet[ctype]
    if ctype == "commonChapter" then
        totelChapter = Player.Chapter.lastChapter
    elseif ctype == "hardChapter" then
        totelChapter = Player.HardChapter.lastChapter
    elseif ctype == "heroChapter" then
        totelChapter = Player.NBChapter.lastChapter
    else
        totelChapter = Player.Chapter.lastChapter
    end
    
    if totelChapter > #list then
        totelChapter = #list
    end
    local item = TableReader:TableRowByUniqueKey("chapter", totelChapter, ctype)
    local canfight = true
    for i = 0, 1 do
        if item.unlock[i..""] ~= nil then
           if item.unlock[i..""].unlock_condition == "completeSectionMonster" then
                local chapterData = TableReader:TableRowByUniqueKey("commonChapter", Player.Chapter.lastChapter, Player.Chapter.lastSection)
                if chapterData ~= nil and chapterData.id <  item.unlock[i..""].unlock_arg then
                    canfight = false
                    break
                end
            elseif item.unlock[i..""].unlock_condition == "hardChaSection" then
                local chapterData = TableReader:TableRowByUniqueKey("hardChapter", Player.HardChapter.lastChapter, Player.HardChapter.lastSection)
                if chapterData ~= nil and chapterData.id <  item.unlock[i..""].unlock_arg then
                    canfight = false
                    break
                end
            elseif item.unlock[i..""].unlock_condition == "heroChaSection" then
                local chapterData = TableReader:TableRowByUniqueKey("heroChapter", Player.NBChapter.lastChapter, Player.NBChapter.lastSection)
                if chapterData ~= nil and chapterData.id <  item.unlock[i..""].unlock_arg then
                    canfight = false
                    break
                end
            elseif item.unlock[i..""].unlock_condition == "level" then
                if Player.Info.level < item.unlock[i..""].unlock_arg then
                    canfight = false
                    break
                end
            end
        end
    end
    if canfight == false then
        totelChapter = totelChapter - 1
    end
    
    return list
end

function chapter:updateItem(index, item, chapterName)
	if index > totelChapter then
        MessageMrg.show(TextMap.GetValue("Text_1_220"))
		item:isSelect(false)
        return
    end
	self.currentSelectChapter = index
    currentSelectSection = -1
	self.chapterName.text = chapterName or ""
	self:updateSubChapter(index)
    --点击左边章节  更新宝箱和星星状态
    self:showSumStar(currentChapterType)
end

function chapter:updateContent()
    self:showOrHideBtn()
end

function chapter:getChapterPageData()
    local list = {}
    local item = {}
    item.chapterPage = self.currentSelectChapter
    item.chapter_type = currentChapterType
    item.delegate = self
    item.gotoindex = currentSelectSection
    table.insert(list, item)
    return list
end

function chapter:getScrollView()
	return  chapter.scrollView
end

function chapter:scrollViewPos(pos)
    local len = TableReader:TableRowByUniqueKey("chapter", self.currentSelectChapter, currentChapterType)["imageLen"]
    pos = pos * len / 1224
    chapter.scrollView:SetDragAmount(1,0.5,false)
    chapter.scrollView:Scroll(pos)
    Messenger.Broadcast("ChapterMoveEnd")--新手引导的监听
end

function chapter:updateSubChapter(chapterId)
	local list = self:getChapterPageData()
    ClientTool.UpdateGrid("Prefabs/moduleFabs/chapterModule/chapterPage_new", self.view_grid, list, self)
    self.binding:CallAfterTime(0.1,
    function()
        chapter.scrollView:InvalidateBounds()
    end)
end
--设置图标的状态
function chapter:setIconState()
    if currentChapterType == "commonChapter" then
        --self.simpleSprite.spriteName = "simple_select"
        --self.hardSprite.spriteName = "diff_normal"
        local linkData = Tool.readSuperLinkById( 240)
        local limit = linkData.unlock[0].arg
        if Player.Info.level < limit then
            --self.hardSprite.spriteName = "diff_gray"
        end
        linkData = nil
        tempChapter = nil
    elseif currentChapterType == "hardChapter" then
        --self.hardSprite.spriteName = "diff_select"
        --self.simpleSprite.spriteName = "simple_normal"
    end
end

function chapter:showOrHideBtn()
    if currentChapterType == "commonChapter" or currentChapterType == "hardChapter" then
        self.baoxiangbg:SetActive(true)    
    else
        self.baoxiangbg:SetActive(false)
    end
    self.UI_Vipbaoxiang:SetActive(false)
    
    local tasks = Player.Tasks:getLuaTable() --任务表
    local taskid = TableReader:TableRowByUniqueKey("chapter", self.currentSelectChapter, currentChapterType)["taskID"]
    if taskid == nil then
        return
    end
    
    for i=0,2 do   
        if taskid[i] ~= nil then
            local taskidv = taskid[i].taskID
            local row = TableReader:TableRowByID('allTasks', taskidv)
            if row == nil then
                break
            end
            self["txt_times"..i].text = row.complete[0].times
            self["_task"..i] = nil
            if row ~= nil then
                self["_taskDrop"..i] = row.drop
            end
            if tasks[taskidv] ~= nil then
                self["_task"..i]   = tasks[taskidv]
                self["_taskID"..i] = taskidv
                self["_state"..i]  = self["_task"..i]["state"]
            else
                self["_state"..i] = 3
                 
            end 
            --0 开启了任务 1未完成  2 完成了未领取 3 已完成并领取   --服务端宝箱领完就会删除 
            
            if self["_state"..i] == 0 or self["_state"..i] == 1 then
                self["btn_baoxiang"..i].gameObject:SetActive(true)
                self["kaibaoxiang"..i].gameObject:SetActive(false)
                self["baoxiangqude"..i]:SetActive(false)
            elseif  self["_state"..i] == 2 then
                self["btn_baoxiang"..i].gameObject:SetActive(true)
                self["kaibaoxiang"..i].gameObject:SetActive(false)
                self["baoxiangqude"..i]:SetActive(true)
            elseif  self["_state"..i] == 3 then
                self["btn_baoxiang"..i].gameObject:SetActive(false)
                self["kaibaoxiang"..i].gameObject:SetActive(true)
                self["baoxiangqude"..i]:SetActive(false)
            else
                self["btn_baoxiang"..i].gameObject:SetActive(false)
                self["kaibaoxiang"..i].gameObject:SetActive(true)
                self["baoxiangqude"..i]:SetActive(false)
            end
        end
    end
    tasks = nil
    chapter:setIconState()
end



function chapter:getAwardHandler()
    local j = 0
    if self.whichBaoXiang == 0 then
        j = 0
    elseif self.whichBaoXiang == 1 then
        j = 1
    elseif self.whichBaoXiang == 2 then
        j = 2
    end

    if self["_taskDrop"..j] == nil then
        return
    end
    local temp = {}
    temp.obj = chapter:getDropByTable(self["_taskDrop"..j])
    temp.index = self["_taskID"..j]
    temp.state = self["_state"..j]
    temp.currentChapterType = currentChapterType
    temp.delegate = self
    temp._go = self.binding.gameObject
    UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/chapterbox", temp)
    temp = nil
    j = nil
end

--2015.4.23 策划说小红点要换地方
function chapter:changeRedPointState()
    --self.chapter_red_point:SetActive(false)
    if currentChapterType == "commonChapter" then
        self.simple_red_point:SetActive(false)
        self.hard_red_point:SetActive(RedPoint.checkChapterPoint("th0"))
        if RedPoint.checkChapterPoint("t0") then
            --self.chapter_red_point:SetActive(true)
        end
    elseif currentChapterType == "hardChapter" then
        self.simple_red_point:SetActive(RedPoint.checkChapterPoint("t0"))
        self.hard_red_point:SetActive(false)
        if RedPoint.checkChapterPoint("th0") then
            --self.chapter_red_point:SetActive(true)
        end
    end
end

function chapter:replaceTitle(type)
	local imgpath = ""
	if type == "commonChapter" then 
		imgpath = UrlManager.GetImagesPath("sl_public/zhangjiemingzi_di.png")
	elseif type == "hardChapter" then 
		imgpath = UrlManager.GetImagesPath("sl_public/zhangjiemingzi_di2.png")
	elseif type == "heroChapter" then 
		imgpath = UrlManager.GetImagesPath("sl_public/zhangjiemingzi_di3.png")
	end 
	self.img_left.Url = imgpath
	self.img_right.Url = imgpath
end 

function chapter:isPassChapter(currentSelectChapter, curChapTpye)
    local tasks = Player.Tasks:getLuaTable() --任务表
    local taskid = TableReader:TableRowByUniqueKey("chapter", currentSelectChapter, curChapTpye)["taskID"]
    if taskid == nil then
        return false
    end
  
    local i = 2
    if taskid[i] ~= nil then
        local taskidv = taskid[i].taskID
        if tasks[taskidv] ~= nil then
            if tasks[taskidv]["state"] == 2 or tasks[taskidv]["state"] == 3 then
                return true 
            else
                return false
            end
        else
            return true
        end
    end
    return false         
end

function chapter:getData(data, chapter_type)
    local list = {}
    local unopennum = 0
    for i = 1, table.getn(data), 1 do
        local d = data[i]
        d.realIndex = i
		d.delegate = self
		d.totelChapter = totelChapter
		d.type = chapter_type
		--if chapter_type then 
		--	d.isPass = false --self:isPassChapter(d.realIndex, chapter_type)
		--end
		if d.realIndex <= totelChapter then 
			d.isOpen = true
            table.insert(list, d)
		else 
            unopennum = unopennum + 1
			d.isOpen = false
            if unopennum < 11 then
                table.insert(list, d)
            end
		end
    end

    return list
end


function chapter:getChapterStarNum(list)
	local starNum = 0
	for i = 1, #list do 
		local c = list[i]
		if self.currentChapterType == "commonChapter" then 
			starNum = starNum + Player.Chapter.status[c.id].star
		elseif self.currentChapterType == "hardChapter" then 
			starNum = starNum + Player.HardChapter.status[c.id].star
        elseif currentChapterType == "heroChapter" then
            starNum = starNum + Player.NBChapter.status[c.id].star
		end
	end
	return starNum, #list * 3
end

--供外部调用的快速选章的方法
function chapter:jumpToSelectedChapter(vaule)

    local openArg = { vaule, 9, currentChapterType }
    chapter:update(openArg)
    --self.currentSelectChapter = vaule
    --if TableReader:TableRowByUniqueKey("chapter", (totelChapter + 1), currentChapterType) ~= nil then
    --    self.chapterInit:setInit(self.currentSelectChapter .. "", (totelChapter + 1) .. "", false)
    --else
    --    self.chapterInit:setInit(self.currentSelectChapter .. "", totelChapter .. "", true)
    --end
    --self.title.text = TableReader:TableRowByUniqueKey("chapter", self.currentSelectChapter, currentChapterType)["name"]
    --self:showOrHideBtn()
end



function chapter:isUsedType(_type)
    local typeAll = { "equip", "equipPiece", "item", "char", "charPiece", "reel", "reelPiece", "money", "gold", "bp", "soul", "popularity", "credit", "honor", "donate", "exp", "hunyu", "ghost", "ghostPiece","shenhun" }
    for i, j in pairs(typeAll) do
        if _type == j then
            return true
        end
    end
    return false
end

function chapter:getDropByTable(drop)
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

function chapter:getDrop(info)
    local drop = info.drop:getLuaTable()
    local _list = {}
    for i, v in pairs(drop) do
        if chapter:isUsedType(v.type) then
            local m = {}
            m.type = v.type
            m.arg = v.arg
            m.arg2 = v.arg2
            table.insert(_list, m)
            m = nil
        end
    end
    return _list
end

function chapter:showHand(target)
    if not GuideMrg.hasStep() then
        if self._hand then
            self._hand.transform.parent = target.transform
            ClientTool.AlignToObject(self._hand, target, 3)
            Tool.SetActive(self._hand, true)
        end
    else
        Tool.SetActive(self._hand, false)
    end
end
--开始
function chapter:Start()
    Events.AddListener("FindDaXu", funcs.handler(self, self.SetTaoRenActive))
    currentSelectSection = -1
    if not GuideMrg.hasStep() then
        local row = TableReader:TableRowByID("GMconfig", 11)
        if row and row.args2 > Player.Info.level then
            if self._hand == nil then
                self._hand = ClientTool.load("Prefabs/publicPrefabs/guide_hand_chapter", self.gameObject)
                Tool.SetActive(self._hand, false)
            end
            Events.AddListener("showHand", funcs.handler(self, chapter.showHand))
        end
    end


end

function chapter:onClick(go, name)
    if self.moving then
        return
    end
        	
	if name == "closeBtn" then
        self:destory()
    elseif name == "rightBtn" then
        self:rightMove()
    elseif name == "leftBtn" then
        self:leftMove()
    elseif name == "btn_tab" then
        local bind = Tool.replace("chapter", "Prefabs/moduleFabs/EliteModule/chapterElite")
        bind:CallUpdate({ 1, 0 })
        bind = nil
    --elseif name == "awardBtn" then
        --chapter:getAwardHandler()
    elseif name == "btn_baoxiang0" or name == "kaibaoxiang0" then
        self.whichBaoXiang = 0
        chapter:getAwardHandler()
    elseif name == "btn_baoxiang1" or name == "kaibaoxiang1" then
        self.whichBaoXiang = 1
        chapter:getAwardHandler()
    elseif name == "btn_baoxiang2" or name == "kaibaoxiang2" then
        self.whichBaoXiang = 2
        chapter:getAwardHandler()
    elseif name == "selectChapter" then
    
        local temp = {}
        temp.view = self.scrollView
        temp.fun = toolFun.handler(self, self.junpToSelectedChapter)
        temp.totelChapter = totelChapter
        temp.chapter_type = currentChapterType
        UIMrg:pushWindow("Prefabs/moduleFabs/chapterModule/selectChapter", temp)
        temp = nil
    else
    end
end

function chapter:onEnter()
    self:enemyInvade(currentChapterType)
    if self.enemyUI ~= nil and self.enemyUI.gameObject.activeInHierarchy == true then 
	 	self.enemyUI:CallTargetFunctionWithLuaTable("onEnter")
    end 
    chapter:SetTaoRenActive()
end

return chapter
