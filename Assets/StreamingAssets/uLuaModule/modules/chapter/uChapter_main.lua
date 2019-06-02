local chapter = {}
--关闭界面
function chapter:OnDestroy()
 
end

local bgs = {}
---------------------------------------------------------------------------------------------------------------------------------------------------
-- 开始设置数据

--1.外部超链接或者固定链接打开关卡界面
--tables[2]   0表示超链接打开直接到最新章节   -1 超链接打开到指定章节
function chapter:update(tables)
	LuaMain:ShowTopMenu(2)
	self.tables=tables
	DialogMrg.levelUp()
	local currentChapterType = tables[3]
	self.currentChapterType = currentChapterType
	if currentChapterType == "commonChapter" then
		self.uiChapterType = 1
	elseif currentChapterType == "hardChapter" then
		self.uiChapterType = 2
	elseif currentChapterType == "heroChapter" then
		self.uiChapterType = 3
    	chapter:checkChapterRedPoint(self.currentChapterType)
	elseif currentChapterType == "specialChapter" then
		local linkData = Tool.readSuperLinkById( 10)
        local limitLv = linkData.unlock[0].arg
        linkData = nil
        if Player.Info.level < limitLv then
            MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_823"),"{0}",limitLv))
            self.uiChapterType = 1
        else
			self.uiChapterType = 4
			Api:checkUpdateSpecialChapter(function(result)
				if self.dialy_chapter == nil then
					self.dialy_chapter = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/dialy_chapter", self.gameObject)
				end
				self.dialy_chapter.gameObject:SetActive(true)
				self.dialy_chapter:CallUpdate({})
				self:updateBtnStatus()
				end)
			return
		end
	end
	self:updateBtnStatus()
	self.uChapter:CallTargetFunctionWithLuaTable("setDelegate", self)
	self.uChapter:CallUpdate(tables)
	self.maskT:SetActive(true)
	if not GuideMrg:isPlaying() then
		self.binding:CallAfterTime(0.8,function()
			self.maskT:SetActive(false)
	    end)
	end 	
    chapter:checkTab()
end

function chapter:checkHeroChapter()
	local row = TableReader:TableRowByID("heroChapter_config", "max_time")
    local totaltimes = 0
    if row.args1 ~= nil and row.args1.Count > 0 then
        totaltimes = row.args1[Player.Info.vip]
    end

    local lefttimes = totaltimes - Player.NBChapter.totaltimes
	return lefttimes
end

function chapter:checkRedPoint()
	self["red_point_commonChapter"]:SetActive(false)
    for i=1,Player.Chapter.lastChapter do
        if Tool.checkChuangguan("commonChapter", i) then

            self["red_point_commonChapter"]:SetActive(true)
            break
        end
    end

    self["red_point_hardChapter"]:SetActive(false)
    for i=1,Player.HardChapter.lastChapter do
        if Tool.checkChuangguan("hardChapter", i) then
            self["red_point_hardChapter"]:SetActive(true)
            break
        end
    end

    self["red_point_heroChapter"]:SetActive(false)
    if chapter:setChapterType("heroChapter") == false then
    	if chapter:checkHeroChapter() > 0 then
    		self["red_point_heroChapter"]:SetActive(true)
    	end
	    for i=1,Player.NBChapter.lastChapter do
	        if Tool.checkChuangguan("heroChapter", i, true) then
	            self["red_point_heroChapter"]:SetActive(true)
	            break
	        end
	    end
	end
	
    self["daily_red_point"]:SetActive(false)
    local linkData = Tool.readSuperLinkById( 10)
    local limitLv = linkData.unlock[0].arg
    linkData = nil
    if Player.Info.level >= limitLv then
    	TableReader:ForEachLuaTable("specialChapter_config",
    		function(index, item)
    			if item.des3<=Player.Info.level then 
    				local open = Player.specialChapter[item.id].open
    				if open==true then 
    					local specialChapter = Player.specialChapter[item.id]
    					local times = specialChapter.max_fight - specialChapter.fight
    					if times>0 then 
    						self["daily_red_point"]:SetActive(true)
    						return true
    					end 
    				end 
    			end 
    			return false
    		end)
    end
end

--触发器调用的检测红点
function chapter:checkChapterRedPoint(model)
	if model == "commonChapter" then
		self["red_point_commonChapter"]:SetActive(false)
		for i=1,Player.Chapter.lastChapter do
	        if Tool.checkChuangguan("commonChapter", i, true) then
	            self["red_point_commonChapter"]:SetActive(true)
	            break
	        end
	    end
	elseif model == "hardChapter" then
	    self["red_point_hardChapter"]:SetActive(false)
		for i=1,Player.HardChapter.lastChapter do
	        if Tool.checkChuangguan("hardChapter", i, true) then
	            self["red_point_hardChapter"]:SetActive(true)
	            break
	        end
    	end
	elseif model == "heroChapter" then
	    self["red_point_heroChapter"]:SetActive(false)
	    if chapter:setChapterType("heroChapter") == false then
	    	if chapter:checkHeroChapter() > 0 then
	    		self["red_point_heroChapter"]:SetActive(true)
	    	end
			for i=1,Player.NBChapter.lastChapter do
		        if Tool.checkChuangguan("heroChapter", i, true) then
		    		self["red_point_heroChapter"]:SetActive(true)
		            break
		        end
	    	end
	    end
	end
end

function chapter:checkDailtyRedPoint()
	self["daily_red_point"]:SetActive(false)
    local linkData = Tool.readSuperLinkById( 10)
    local limitLv = linkData.unlock[0].arg
    linkData = nil
    if Player.Info.level >= limitLv then
    	TableReader:ForEachLuaTable("specialChapter_config",
    		function(index, item)
    			if item.des3<=Player.Info.level then 
    				local open = Player.specialChapter[item.id].open
    				if open==true then 
    					local specialChapter = Player.specialChapter[item.id]
    					local times = specialChapter.max_fight - specialChapter.fight
    					if times>0 then 
    						self["daily_red_point"]:SetActive(true)
    						return true
    					end 
    				end 
    			end 
    			return false
    		end)
    end
end

function chapter:onEnable()
    chapter:update(self.tables)
end

function chapter:checkTab()
	self.btnJingYing_gray:SetActive(chapter:setChapterType("hardChapter"))
    self.btnYingXiong_gray:SetActive(chapter:setChapterType("heroChapter"))
    self.btnDaily_gray:SetActive(chapter:setChapterType("btnDaily"))
end

function chapter:setChapterType(chapter_type)
    if chapter_type == "hardChapter" then
        local linkData = Tool.readSuperLinkById(240)
        local limitLv = linkData.unlock[0].arg
        linkData = nil
        if Player.Info.level < limitLv then
            return true
        end
    end
    if chapter_type == "heroChapter" then
        local linkData = Tool.readSuperLinkById(5)
        local limitLv = linkData.unlock[0].arg
        linkData = nil
        if Player.Info.level < limitLv then
            return true
        end
    end
    if chapter_type == "btnDaily" then
        local linkData = Tool.readSuperLinkById(10)
        local limitLv = linkData.unlock[0].arg
        linkData = nil
        if Player.Info.level < limitLv then
            return true
        end
    end
    return false
end

function chapter:onClick(go, name)
	if name == "btnMainLine" then 
		self.uiChapterType = 1
		self:updateBtnStatus()
		self.uChapter.target:setChapterType("commonChapter")
	elseif name == "btnJingYing" then 
		self.uiChapterType = 2
		self:updateBtnStatus()
		local ret = self.uChapter.target:setChapterType("hardChapter")
		if ret == false then 
			self.uiChapterType = 1
			self:updateBtnStatus()
		end 
	elseif name == "btnYingXiong" then 
		self.uiChapterType = 3
		self:updateBtnStatus()
		local ret = self.uChapter.target:setChapterType("heroChapter")
		if ret == false then 
			self.uiChapterType = 1
			self:updateBtnStatus()
		end 
	elseif name == "btnDaily" then
		local linkData = Tool.readSuperLinkById( 10)
        local limitLv = linkData.unlock[0].arg
        linkData = nil
        if Player.Info.level < limitLv then
            MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_823"),"{0}",limitLv))
            return
        end
		self.uiChapterType = 4
		Api:checkUpdateSpecialChapter(function(result)
			if self.dialy_chapter == nil then
				self.dialy_chapter = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/chapterModule/dialy_chapter", self.gameObject)
			end
			self.dialy_chapter.gameObject:SetActive(true)	
			self.dialy_chapter:CallUpdate({})
			self:updateBtnStatus()
			end)
	elseif name == "btnBack" then 
		Tool.updateActivityOpen()
		UIMrg:pop()
    elseif name == "awardBtn" then
        chapter:getAwardHandler()
    elseif name == "btn_buzhen" then
        print("buzhen")
    end
end

function chapter:updateBtnStatus()
	if (self.uiChapterType == 1) then 
		-- 主线
		self.mainSelect:SetActive(true)
		self.jingyingSelect:SetActive(false)
		self.yingxiongSelect:SetActive(false)
		self.dailySelect:SetActive(false)
		self.currentChapterType = "commonChapter"
		
		if self.uChapter ~= nil then self.uChapter.gameObject:SetActive(true) end
		if self.dialy_chapter ~= nil then self.dialy_chapter.gameObject:SetActive(false) end
	elseif (self.uiChapterType == 2) then 
		-- 精英
		self.mainSelect:SetActive(false)
		self.jingyingSelect:SetActive(true)
		self.yingxiongSelect:SetActive(false)
		self.dailySelect:SetActive(false)
		self.currentChapterType = "hardChapter"

		
		if self.uChapter ~= nil then self.uChapter.gameObject:SetActive(true) end
		if self.dialy_chapter ~= nil then self.dialy_chapter.gameObject:SetActive(false) end
	elseif (self.uiChapterType == 3) then 
		-- 英雄
		self.mainSelect:SetActive(false)
		self.jingyingSelect:SetActive(false)
		self.yingxiongSelect:SetActive(true)
		self.dailySelect:SetActive(false)
		self.currentChapterType = "heroChapter"

		
		self.uChapter.gameObject:SetActive(true)
		if self.dialy_chapter ~= nil then self.dialy_chapter.gameObject:SetActive(false) end
	elseif (self.uiChapterType == 4) then 
		-- 日常
		self.mainSelect:SetActive(false)
		self.jingyingSelect:SetActive(false)
		self.yingxiongSelect:SetActive(false)
		self.dailySelect:SetActive(true)
		self.currentChapterType = nil

		if self.dialy_chapter ~= nil then 
			self.dialy_chapter.gameObject:SetActive(true)
		 end
		self.uChapter.gameObject:SetActive(false)
	end
end

function chapter:onExit()

end 

function chapter:OnDestroy()
    Events.RemoveListener('updateShiLian')
    Events.RemoveListener('CheckChuanguanPoint')
    Events.RemoveListener('CheckChapterOpen')
end

function chapter:onEnter()
	LuaMain:ShowTopMenu(2)
	self.uChapter:CallTargetFunctionWithLuaTable("onEnter")
end

function chapter:Start()
	--if gui_top_title ~= nil then 
	--	if gui_top_title.gameObject.activeSelf == true then 
	--		self.showTopTitle = true
	--		gui_top_title.gameObject:SetActive(false)
	--	end 
	--end 
	LuaMain:ShowTopMenu(2)
	self.uiChapterType = 1
	self:checkRedPoint()
	Events.AddListener("updateShiLian",
    function(params)
        chapter:checkDailtyRedPoint()
    end)
    Events.AddListener("CheckChuanguanPoint",
    function(params)
    	if self.currentChapterType ~= nil then
        	chapter:checkChapterRedPoint(self.currentChapterType)
    	end
    end)
    Events.AddListener("CheckChapterOpen",
    	function(params)
	        chapter:checkTab()
	        if params ~= nil then
	        	chapter:checkChapterRedPoint("heroChapter", params)
	        end
    end)
end

return chapter
