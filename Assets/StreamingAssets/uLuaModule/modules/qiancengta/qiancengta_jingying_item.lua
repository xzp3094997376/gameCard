
local m = {}

function m:update(lua, index, delegate)
	self.delegate = delegate
	self.index = lua.index
	self.data = lua
	local avter = TableReader:TableRowByID("avter", self.data.model)  
	self.txt_name.text = Char:getItemColorName(self.data.star, self.data.name)--self.data.name  
	--self.name = tb.name
	self.img_frame.spriteName = Tool.getFrame(self.data.star)
	self.img_bg.spriteName = Tool.getBg(self.data.star)
	self.pic:setImage(avter.head_img,"headImage")
	---- 已被打败
	--self.img_killed:SetActive(self.data.status == 2)
	--
	--local lastChapter = Player.qianCengTa.lastTower
	--local isTowerCanFight = false
	--local isCanFight = false
	--for i = 0, self.data.unlock.Count - 1 do 
	--	local cell = self.data.unlock[i]
	--	if cell.unlock_condition == "towerChapter" then
	--		if lastChapter >  cell.unlock_arg then
	--			self.index = index
	--			isTowerCanFight = true
	--			if self.data.unlock.Count < 2 then 
	--				isCanFight = true
	--			end 
	--		end
	--	elseif cell.unlock_condition == "towerChapter_jingying" then 
	--		if m:isInFirstWin(cell.unlock_arg) == true then 
	--			isCanFight = isTowerCanFight
	--		end 
	--	end
	--end 
	if self.data.isCanFight == false then
		self.txt_lock.text = "" 
		self:isGray(true)
		self.lock:SetActive(true)
		self.isLock = true
	else 
		self:isGray(false)
		self.isLock = false
		self.txt_lock.text = ""
		self.lock:SetActive(false)
	end
	if self.index == self.delegate.index then 
		m:isSelect(true)
	else 
		m:isSelect(false)
	end 
end

function m:isSelect(ret)
	self.isSelected = ret 
	if self.select==nil then return end 
	self.select:SetActive(self.isSelected)
end

function m:isGray(isGray)
	self.pic:isShowGray(isGray)
	if isGray == true then
		self.img_frame.spriteName = "kuang_baise"
		self.img_bg.spriteName="tubiao_1"
	end
end

function m:SelectActCallBack(index)
	if index == self.index then 
		m:isSelect(true)
	else
		m:isSelect(false)
	end 
end

function m:Start()
	Events.AddListener("SelectTaoRenRuQin", funcs.handler(self, m.SelectActCallBack))
end

function m:OnDestroy()
    Events.RemoveListener("SelectTaoRenRuQin")
end

function m:onClick(go, name)
    if name == "btnCell" then
		-- 跳转章节
		if self.isLock == false then
			Events.Brocast("SelectTaoRenRuQin", self.index)
			m:isSelect(true)
			self.delegate:selectItem(self.data, self, self.index)
		else 
			MessageMrg.show(self.data.unlockMsg)
		end 
    end
end

return m

