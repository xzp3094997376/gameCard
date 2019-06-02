

local m = {}
local index = 1
local totalCount = 0
local timerId = 0
local direction = 1 -- 1 向右， 0向左

function m:updateHero(data)
	if data == nil then 
		return
	end 
	self.char = data.char
	self:updateFx()
	self.currentHero:CallUpdate({char = self.char, delegate = self, isClick = true})
end

function m:hideFx()
	self.isHideFx = true
	if self.fx_zi.activeSelf then self.fx_zi:SetActive(false) end 
	if self.fx_huang.activeSelf then self.fx_huang:SetActive(false) end 
	if self.fx_hong.activeSelf then self.fx_hong:SetActive(false) end 
end 

function m:updateFx()
	if self.char == nil then return end 
	if self.buffStar == self.char.star then 
		if self.isHideFx == nil or self.isHideFx == false then
			return
		end
	end 
	print("char = " .. self.char.name)
	print("star = " .. self.char.star)
	self.isHideFx = false
	self.fx_zi:SetActive(false)
	self.fx_huang:SetActive(false)
	self.fx_hong:SetActive(false)
	self.buffStar = self.char.star
	if self.char.star == 4 then 
		self.fx_zi:SetActive(true)
	elseif self.char.star == 5 then 
		self.fx_huang:SetActive(true)
	elseif self.char.star >= 6 then 
		self.fx_hong:SetActive(true)
	end 
end 

--获取上阵角色信息
function m:getTeamInfo()
    local teams = Player.Team[0].chars
    local charList = {}
    for i = 0, 5 do
        local char = {}
        char.index = i + 1
        if teams.Count > i then
            if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then --可以添加一个从服务器端传过来的死亡状态，如果死亡则不上阵
            local last_char = Char:new(teams[i .. ""], Tool.getDictId(teams[i .. ""]))
            char.char = last_char
            end
        end
		if char.char ~= nil then 
			table.insert(charList, char)
		end
    end
	totalCount = #charList
    return charList
end

-- dir = -1 什么都没有， 1 左  2 右
function m:Start()
	self.buffStar = -1
	--self.isHideFx = false
	local this = self
	timerId = LuaTimer.Add(10000, 10000, function()
		if not self.gameObject.activeInHierarchy then return end 
		if self.isDrag == true then return end
		local teamInfos = this:getTeamInfo()
		local n = 1
		if direction == 1 then 
			if index + 1 > totalCount then 
				direction = 0
				n = -1
			else
				n = 1
			end
		elseif direction == 0 then 
			if index - 1 < 1 then 
				direction = 1
				n = 1
			else
				n = -1
			end 
		end
		index = index + n
		this:updateHero(teamInfos[index])
	end)
	local teamInfos = this:getTeamInfo()
	if teamInfos[1] ~= nil then 
		self.char = teamInfos[1].char
	end
	--滑动
	self.dir = -1
	self.offsetX = 400
	self.isDrag = false
	self.currentHero = self.hero
	self.assistHero = self.hero2
	self.original = self.currentHero.gameObject.transform.localPosition
	self:resetHero()
	if self.char ~= nil then 
		self.currentHero:CallUpdate({char = self.char, delegate = self, isClick = true})
		self:updateFx()
	end
	--self.currentHero:
	--m:updateData()
end

function m:onLeft()
	if index - 1 < 1 then 
		return 
	end 
	local teamInfos = self:getTeamInfo()
	if teamInfos[index - 1] ~= nil then 
		index = index - 1
		self:updateHero(teamInfos[index])
	end 
end

function m:onRight()
	if index + 1 > 6 then 
		return
	end 
	local teamInfos = self:getTeamInfo()
	if teamInfos[index + 1] ~= nil then 
		index = index + 1
		self:updateHero(teamInfos[index])
	end 
end

function m:onClick(go, name)
	if name == "left" then 
		self:onLeft()
	elseif name == "right" then 
		self:onRight()
	end
end

-- 滑动系列函数
-- 重置位置
function m:resetHero()
	-- 排序
	self.currentHero.gameObject.transform.localPosition = self.original
	self.assistHero.gameObject.transform.localPosition = Vector3(
		self.currentHero.gameObject.transform.localPosition.x + self.offsetX,
		self.currentHero.gameObject.transform.localPosition.y, 0)
	self.currentHero.gameObject:GetComponent(BoxCollider).enabled = true
	self.assistHero.gameObject:GetComponent(BoxCollider).enabled = false
	self.dir = -1
	self.isDrag = false
end

function m:updateAssistPos(dir)
	local offset = -self.offsetX
	if dir == 1 then 
		offset = self.offsetX 
	end 
	self.assistHero.gameObject.transform.localPosition = Vector3(
	self.currentHero.gameObject.transform.localPosition.x + offset,
	self.currentHero.gameObject.transform.localPosition.y, 0)
end

function m:updateAssistData(dir)
	local char = self:getTeamCharById(self.char.id, dir)
	if char ~= nil then 
		self.assistHero:CallUpdate({char = char, delegate = self, isClick = true})
		self.assistHero.gameObject:SetActive(true)
		self.canReplace = true
		self.assistChar = char
	else
		self.canReplace = false
		self.assistHero.gameObject:SetActive(false)
	end
end

function m:backOriginal()
	local tween = self.currentHero.gameObject:GetComponent(TweenPosition)
	if tween ~= nil then 
		tween.from = self.currentHero.gameObject.transform.localPosition
		tween.to = self.original
		tween.duration = 0.1
		tween.enabled = true
		tween:ResetToBeginning()
		self.binding:CallAfterTime(tween.duration, function()
			self:updateFx()
			if self.isReplace == true then 
				if self.assistChar ~= nil then 
					--self.char = self.assistChar
					--self:update(self.assistChar)
				end 
			end 
			self:resetHero()
		end)
	end 

end

function m:getTeamCharById(id, dir)
    local teams = Player.Team[0].chars
	local count = 0
    for i = 0, 5 do
        if teams.Count > i then
            if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" and teams[i..""] == id then --可以添加一个从服务器端传过来的死亡状态，如果死亡则不上阵
				-- 找到，使用方向找到身边的
				local char = nil 
				if dir == 1 then 
					if (i - 1) >= 0 and (i - 1) < teams.Count and teams[(i-1) .. ""] ~= 0 and teams[(i-1) .. ""] ~= "0" then 
						char = Char:new(teams[(i-1)..""])
						return char
					end 
				elseif dir == 2 then 
					if   (i + 1) >= 0 and (i + 1) < teams.Count  and teams[(i+1) .. ""] ~= 0 and teams[(i+1) .. ""] ~= "0" then 
						char = Char:new(teams[(i+1)..""])
						return char
					end 
				end 
            end
        end
    end
	local char = nil
	local id = -1
	if dir == 1 then
		-- 找到最右边的
		for i = 5, 0, -1 do
			if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then 
				id = teams[i .. ""]
				break
			end 
		end

	elseif dir == 2 then 
		-- 找到最左边的
		for i = 0, 5 do
			if teams[i .. ""] ~= 0 and teams[i .. ""] ~= "0" then 
				id = teams[i .. ""]
				break
			end 
		end
	end
	if id ~= -1 then 
		char = Char:new(id)
	end
	return char
end

function m:showAssist(dir)
	-- 向右
	self:updateAssistPos(dir)
	self:updateAssistData(dir)
end

-- 手指松开隐藏
function m:onCallbackPress(ret)
	if ret == false then
		-- 切换当前卡片
		self:replaceCurrent()
		-- 缓动回到原位
		self:backOriginal()
		if self.assistHero ~= nil then 
			self.assistHero.gameObject:SetActive(false)
		end 
	else
	
	end 
end 

function m:replaceCurrent()
	if self.canReplace and self.canReplace == true then
		self.isReplace = false
		local now = self.currentHero.gameObject.transform.localPosition.x
		local last = self.original.x
		local dis = math.abs(now - last)
		if dis > self.offsetX / 2 then 
			if self.assistChar ~= nil then 
				local temp = self.currentHero
				self.currentHero = self.assistHero
				self.assistHero = temp
				self.isReplace = true
				self.char = self.assistChar
			end
		end 
	end
end

function m:onDragStart()
	if self.isDrag ~= true then 
		if self.dir ~= -1 then 
			m:hideFx()
			self.isDrag = true
			self:showAssist(self.dir)
		end
	end 
end 

-- 获取方向
function m:onCallBackDir(dir)
	if self.isDrag == true then return end 
	if dir ~= -1 then 
		self.dir = dir
	end
end
-- 1 向左， 2向右

function m:herosMove(delta)
	if delta.x > 0.5 then
		if self.isDrag == false then 
			self:onDragStart()
			self:onCallBackDir(2)
		end
	elseif(delta.x < -0.5) then
		if self.isDrag == false then 
			self:onDragStart()
			self:onCallBackDir(1)
		end
	end
	local value = math.abs(delta.x)
	if value > 0.5 then 
		self:move(delta)
	end
end

function m:move(delta)
	-- 移动
	self.currentHero.gameObject.transform.localPosition = Vector3(
		self.currentHero.gameObject.transform.localPosition.x + delta.x,
		self.currentHero.gameObject.transform.localPosition.y,0)
	self.assistHero.gameObject.transform.localPosition = Vector3(
		self.assistHero.gameObject.transform.localPosition.x + delta.x,
		self.currentHero.gameObject.transform.localPosition.y,0)
end

return m