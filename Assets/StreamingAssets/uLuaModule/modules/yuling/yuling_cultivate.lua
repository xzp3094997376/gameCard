local m = {}

--[[
-- 1 升级
-- 2 升星
-- 3 神炼
]]
function m:onUpdate(top, refresh)
    local tp = self.tp	

	if self.pet == nil then return end
	
	m:updateColor()
	m:updateYulingDate()
		
    for i=1,2 do
    	if i== self.tp then 
    		self.tabList[i].gameObject:SetActive(true)
    		self.tab=self.tabList[i]
    		self.tab:CallUpdate({ delegate = self, pet = self.pet })
    	else 
    		self.tabList[i].gameObject:SetActive(false)
    		self.tabList[i]:CallTargetFunction("hideEffect") --将其余面板中的特效隐藏或销毁
    	end 
    end
end

function m:updateYulingDate()
	self.img_hero:LoadByModelId(self.pet.modelid, "idle", function() end, false, 100, 1)
	--self.txt_power.text=self.pet.power
	self.txt_name.text=self.pet:getDisplayColorName()
	local starLists = {}
	self.maxLv =TableReader:TableRowByID("yulingArgs","max_yuling_starup")
	self.maxLv=tonumber(self.maxLv.value)
	local showStar = false
    for i =1, self.maxLv do
		showStar = false
		if i <= self.pet.star_level then 
			showStar = true
		end
        starLists[i] = { isShow = showStar }
    end
	self.stars:refresh("", starLists, self)
end

function m:updateColor()
	self.open_lv = self:checkLockNoMsg(27)
	self.open_star = self:checkLockNoMsg(27)
	
	self.btn_lvup_down.gameObject:SetActive(self.open_lv)
	self.btn_lvup_gray.gameObject:SetActive(not self.open_lv)
	
	self.btn_jinjie_down.gameObject:SetActive(self.open_star)
	self.btn_jinjie_gray.gameObject:SetActive(not self.open_star)
	
end 

function m:onEnter()
	LuaMain:ShowTopMenu(1)
	if self.tab then
		self.pet:updateInfo()
        self.tab:CallUpdate({ delegate = self, pet = self.pet })
    end
	m:updateRedPoint()
end 

function m:update(lua)
    self.pet = lua.pet
    self.tp = lua.tp
	if self.pet == nil then return end 
    self:onUpdate(true, true)
    self:updateRedPoint()
	self:updateBtnState()
end

function m:updateItem(index)
	print("需要更新： " .. index)
	self:onUpdate(false, false)
end

--更新红点提示
function m:updateRedPoint()
    local pet = self.pet
	if pet.info.huyou>0 then 
		self.redPoint_lvup:SetActive(pet:redPointForStrong() and self.open_lv) --升级突破
		self.redPoint_jinjie:SetActive(pet:redPointForJinHua() and self.open_star) --进化
	end 
end


function m:updateHeroInfo(pet)
    if pet == nil then return end
    if self.__itemAll ~= nil then
        self.__itemAll:CallUpdate({ "pet", self.pet, self.img_frame.width, self.img_frame.height })
        self.txt_name.text = self.pet:getDisplayName()
        self.txt_power.text = self.pet.power
        self:updateRedPoint()
    end
end

function m:checkLockNoMsg(id)
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
        if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
           return false
        end
	end
	return true
end

function m:checkLock(id)
	local linkData = Tool.readSuperLinkById( id)
    local unlockType = linkData.unlock[0].type --解锁条件
    if unlockType ~= nil then
        local level = linkData.unlock[0].arg
        if Player.Info.level < level or Player.Info.vip < linkData.vipLevel then
            MessageMrg.show(string.gsub(TextMap.GetValue("Text_1_881"), "{0}", level))
            return false
        end
	end
	return true
end

function m:onClick(go, name)
    if name == "btn_lvup_down" or name == "btn_lvup_gray" then 
		local isOpen = self:checkLock(27)
		if isOpen == true then 
			self.tp = 1
			self:updateBtnState()
			self:check(1)
		else 
			return 
		end
	elseif name == "btn_jinjie_down" or name == "btn_jinjie_gray" then 
		local isOpen = self:checkLock(27)
		if isOpen == true then 
			self.tp = 2
			self:updateBtnState()
			self:check(2)
		else 
			return 
		end
	elseif name == "btnBack" then 
		UIMrg:pop()
    end
end

function m:updateBtnState()
	-- 1 升级  2 进阶 3 神炼 
	local list = {}
	list[1] = self.img_lvUp
	list[2] = self.imgJinjieUp
	for i = 1, 2 do 
		if i == self.tp then list[i]:SetActive(true)
		else list[i]:SetActive(false) end
	end 
	
	for i = 1, 2 do
		self.btns[i].gameObject:SetActive(true)
	end 
end

function m:onExit()
    self._exit = true
    -- if self.tp == 1 then
    --     self.tab:CallTargetFunction("hideEffect")
    -- end
end

--获取小伙伴队列
function m:checkFriend(charId)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if teams[i]~= nil and teams[i] == charId then
            return true
        end
    end
    return false
end

function m:check(tp)
    self.tp = tp
    self:onUpdate(false, true)
end

function m:onClose()
    if self.tp == 6 then
        self.tab:CallTargetFunction("onClose")
    else
        UIMrg:pop()
    end
end

function m:switch(tp)
    if tp == nil then return end
    self.tp = tp
    self:onUpdate(false, true)
end

function m:Start()
	LuaMain:ShowTopMenu()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_2993"))
    self.tp = 1
    self.tabList = {}
    self.tabList[1]=self.yuling_levelup
    self.tabList[2]=self.yuling_starup
	
	self.btns={}
	self.btns[1] = self.btn_lvup
	self.btns[2] = self.btn_jinjie
	
	self.btnPos={}
	for i =1, 2 do 
		self.btnPos[i] = self.btns[i].gameObject.transform.localPosition
		self.btns[i].gameObject:SetActive(false)
	end 
	
	self:onUpdate(true, true)
end

return m

