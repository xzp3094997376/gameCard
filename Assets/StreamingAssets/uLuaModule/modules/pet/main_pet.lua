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
		
    if tp == 1 then --升级
        if self.tabList[1] == nil then
            self.tabList[1] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/pet/pet_levelup", self.con)
        	self.tabList[1].gameObject:SetActive(false)
			self.binding:CallManyFrame(function()
				self.tabList[1].gameObject:SetActive(true)	
			end)
		end
        self.tab = self.tabList[1]
	elseif tp == 2 then  -- 升星
        if self.tabList[2] == nil then
            self.tabList[2] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/pet/pet_starup", self.con)
        	self.tabList[2].gameObject:SetActive(false)
			self.binding:CallManyFrame(function()
				self.tabList[2].gameObject:SetActive(true)	
			end)
		end
        self.tab = self.tabList[2]
    elseif tp == 3 then --神炼
		if self.tabList[3] == nil then
			self.tabList[3] = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/pet/pet_shenlian", self.con)
			self.tabList[3].gameObject:SetActive(false)
			self.binding:CallManyFrame(function()
				self.tabList[3].gameObject:SetActive(true)	
			end)
		end
		self.tab = self.tabList[3]
	end
    self:updatePanel(tp)
    if self.tab then
        self.tab:CallUpdate({ delegate = self, pet = self.pet })
    end
end

function m:updateColor()
	self.open_lv = self:checkLockNoMsg(151)
	self.open_star = self:checkLockNoMsg(152)
	self.open_shenlian = self:checkLockNoMsg(153)
	
	self.btn_lvup_down.gameObject:SetActive(self.open_lv)
	self.btn_lvup_gray.gameObject:SetActive(not self.open_lv)
	
	self.btn_jinjie_down.gameObject:SetActive(self.open_star)
	self.btn_jinjie_gray.gameObject:SetActive(not self.open_star)
	
	self.btn_shenlian_down.gameObject:SetActive(self.open_shenlian)
	self.btn_shenlian_gray.gameObject:SetActive(not self.open_shenlian)	
end 

function m:onEnter()
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
	--if self.pet.id == Player.Info.playercharid or self.pet.Table.can_lvup_consume ~= 1 then 
	--	if self.tp == 1 then self.tp = 3 end 
	--end 
    self:onUpdate(true, true)
    self:updateRedPoint()
	self:updateBtnState()
end

function m:updateItem(index)
	print("需要更新： " .. index)
	self:onUpdate(false, false)
	--if self.tab then
    --    self.tab:CallUpdate({ delegate = self, pet = self.pet })
    --end
end

--更新红点提示
function m:updateRedPoint()
    local pet = self.pet
	if m:isExitTeam(pet.id) then 
		self.redPoint_lvup:SetActive(pet:redPointForStrong() and self.open_lv) --升级突破
		self.redPoint_jinjie:SetActive(pet:redPointForJinHua() and self.open_star) --进化
		self.redPoint_shenlian:SetActive(pet:redPointForShenlian() and self.open_shenlian) --灵络
	end 
end

-- 是否在上阵或者护佑中
function m:isExitTeam(petId)
    local id = Player.Team[0].pet
    if id ~= nil and tonumber(id) ~= 0 and id == petId then
        return true
    end
	local ghostSlot = Player.ghostSlot
	for i = 0, 5 do 
		local slot = ghostSlot[i]
		local petid = slot.petid
		if petId == petid then 
			return true
		end 
	end 
    return false
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
		local isOpen = self:checkLock(151)
		if isOpen == true then 
			self.tp = 1
			self:updateBtnState()
			self:check(1)
		else 
			return 
		end
	elseif name == "btn_shenlian_down" or name == "btn_shenlian_gray" then 
		local isOpen = self:checkLock(153)
		if isOpen == true then 
			self.tp = 3
			self:updateBtnState()
			self:check(3)
		else 
			return 
		end
	elseif name == "btn_jinjie_down" or name == "btn_jinjie_gray" then 
		local isOpen = self:checkLock(152)
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
	list[3] = self.imgshenlianUp
	for i = 1, 3 do 
		if i == self.tp then list[i]:SetActive(true)
		else list[i]:SetActive(false) end
	end 
	
	for i = 1, 3 do
		self.btns[i].gameObject:SetActive(true)
	end 
		
	--if self.pet.id == Player.Info.playercharid or self.pet.Table.can_lvup_consume ~= 1 then 
	--	self.btn_lvup:SetActive(false)
	--	for i = 2, 5 do
	--		self.btns[i].gameObject.transform.localPosition = self.btnPos[i-1]
	--		self.btns[i].gameObject:SetActive(true)
	--	end 
	--	--self.btn_lvup_down.isEnabled = false
	--	--BlackGo.setBlack(0.5, self.btn_lvup.transform)
	--end 
	
	--if self.pet.star < 2 then 
	--	--self.btn_lvup:SetActive(false)
	--	--self.btn_jinjie:SetActive(false)
	--	--self.btn_tupo:SetActive(false)
	--	--self.btn_blood:SetActive(false)
	--	self.btn_lvup_down.isEnabled = false
	--	self.btn_jinjie_down.isEnabled = false
	--	self.btn_tupo_down.isEnabled = false
	--	self.btn_blood_down.isEnabled = false
	--	--if self.lvtxt ~= nil then self.lvtxt.color = Color(0.4, 0.4, 0.4) end
	--	--self.tupotxt.color = Color(0.4, 0.4, 0.4)
	--	--self.jinjietxt.color = Color(0.4, 0.4, 0.4)
	--	--self.bloodtxt.color = Color(0.4, 0.4, 0.4)
	--end 
end

--显示当前的培养面板，隐藏其余面板
function m:updatePanel(tp)
    for i = 1, 3 do
        if i == tp then
            self.tabList[tp].gameObject:SetActive(true)
        else
            if self.tabList[i] ~= nil then
                self.tabList[i]:CallTargetFunction("hideEffect") --将其余面板中的特效隐藏或销毁
                self.tabList[i].gameObject:SetActive(false)
            end
        end
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
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_918"))
    self.tp = 1
	--self.selectIndex = 1
    self.tabList = {}
	
	self.btns={}
	self.btns[1] = self.btn_lvup
	self.btns[2] = self.btn_jinjie
	self.btns[3] = self.btn_shenlian
	
	self.btnPos={}
	for i =1, 3 do 
		self.btnPos[i] = self.btns[i].gameObject.transform.localPosition
		self.btns[i].gameObject:SetActive(false)
	end 
	
	self:onUpdate(true, true)
	--self:updateBtnState()
end

return m

