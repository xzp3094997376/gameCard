local m = {}

function m:update(lua)
    self.delegate = lua.delegate
    self.index = lua.index
    self.pos = lua.pos
	self.type = lua.type
	if lua.data ~= nil then 
		self.char = lua.data.char
	end 
    self:updateIcon()
end

function m:onClick(go, name)
    if name == 'button' then
        if self.delegate ~= nil and self.index ~= nil then
            self.delegate:selectIcon(tonumber(self.index))
        end
    end
end

--设置选中图标状态
function m:setSelectState(flag)
    if self.select ~= nil then self.select:SetActive(flag) end 
end

--获取位置
function m:getPos()
    return self.pos
end

--设置位置
function m:setPos(pos)
    self.pos = pos
end

--更新icon
function m:updateIcon()
    if self.char == nil then --无角色
		self.info:SetActive(false)
		-- self.icon_frame.spriteName = "frame_while"
		if self.txt_name ~= nil then self.txt_name.text = "" end
		if self.txt_power ~= nil then self.txt_power.text = "" end
		--self.unselect.spriteName = "jibang-yeqiandi"
		if self.lock ~= nil then self.lock:SetActive(true) end
		if self.type == "char" then 
			local max_slot = Player.Resource.max_slot
			if self.index > max_slot then --未解锁
				if self.lockObj ~= nil then self.lockObj:SetActive(true) end 
				if self.add_sprite ~= nil then self.add_sprite:SetActive(false) end 
				local lv = TableReader:TableRowByID("playerArgs", "slot" .. self.index).value
				if self.txt_need ~= nil then self.txt_need.text =string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",lv) end
			else --解锁
				if self.lockObj ~= nil then self.lockObj:SetActive(false) end 
				if self.add_sprite ~= nil then self.add_sprite:SetActive(true) end 
				if self.txt_need ~= nil then self.txt_need.text = TextMap.GetValue("Text1395") end
				self.isEmpty = true
			end
		else 
			local lv = TableReader:TableRowByID("playerArgs", "pet_slot").value
			if lv and Player.Info.level < lv then --未解锁
				if self.lockObj ~= nil then self.lockObj:SetActive(true) end 
				if self.add_sprite ~= nil then self.add_sprite:SetActive(false) end 
				if self.txt_need ~= nil then self.txt_need.text =string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",lv) end
			else --解锁
				if self.lockObj ~= nil then self.lockObj:SetActive(false) end 
				if self.add_sprite ~= nil then self.add_sprite:SetActive(true) end 
				if self.txt_need ~= nil then self.txt_need.text = TextMap.GetValue("Text1395") end
				self.isEmpty = true
			end
		end
		if self.type == "pet" then 
			self.img_bg.gameObject:SetActive(false)
			self.icon_frame.gameObject:SetActive(false)
		end 
    else --有角色
		--self.unselect.spriteName = "jibang-yeqiandi"
		self.info:SetActive(true)
		if self.lock ~= nil then self.lock:SetActive(false) end 
		local spriteName = self.char:getHeadSpriteName()
		self.pic:setImage(spriteName, "headImage")
		local frame = self.char:getFrame()
		self.icon_frame.spriteName = frame
		self.img_bg.spriteName = self.char:getFrameBG()
		if self.txt_name ~= nil then self.txt_name.text = self.char:getDisplayName() end
		if self.txt_power ~= nil then self.txt_power.text = self.char.power end
		self.txt_lv.text = self.char.lv
		--self.shengjie.spriteName = self.char:getStarFrame()
		if self.type == "pet" then 
			self.img_bg.gameObject:SetActive(true)
			self.icon_frame.gameObject:SetActive(true)
		end 
		self.binding:CallManyFrame(function()
			m:checkRedPoint()
		end, 2)
    end
end

local treasureKinds = 
{
	"fang",
	"gong"
}

function m:equipIsEmpty()
	if self.char == nil then return false end 
	local isEmpty = false
	local treasure = Player.Treasure
	local treasureSlot = Player.Chars[self.char.id].treasure --self.char.treasure
    local list = {}
    for i=0,1 do
        if i > treasureSlot.Count then
            isEmpty = Tool.checkRedTreasureKind(treasureKinds[i])
			if isEmpty == true then return isEmpty end 
        else
            local key = treasureSlot[i]
            if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
                if treasure[key] == nil then
                    isEmpty = Tool.checkRedTreasureKind(treasureKinds[i])
					if isEmpty == true then return isEmpty end 
				else 
					-- 检测更牛逼的宝物
					local ts = Treasure:new(treasure[key].id, key)
					isEmpty = Tool.checkRedTreasureStar(ts.star, ts.kind) or ts:redPointQianHua()
					if isEmpty == true then return isEmpty end
				end
			else
				isEmpty = Tool.checkRedTreasureKind(treasureKinds[i])
				if isEmpty == true then return isEmpty end 
			end
		end
	end
	
	local index = self.index	
    local ghostSlot = Player.ghostSlot
    local ghost = Player.Ghost
    local slot = ghostSlot[index-1]
    local postion = slot.postion
    local len = postion.Count
    
    for i = 1, 4 do
        if i > len then
            isEmpty = Tool.checkRedGhostKind(i-1)
			if isEmpty == true then return isEmpty end 
        else
            local key = postion[i - 1]
            if key ~= "" and key ~= nil and key ~= 0 and key ~= "0" then
                local g = ghost[key].id
                if g == 0 then
					isEmpty = Tool.checkRedGhostKind(i-1)
					if isEmpty == true then return isEmpty end 
				else 
					local gh = Ghost:new(g, key)
					isEmpty = Tool.checkRedGhostStar(gh.star, gh.kind) or gh:redPointQianHua()
					if isEmpty == true then return isEmpty end
				end
			else
				isEmpty = Tool.checkRedGhostKind(i-1)
				if isEmpty == true then return isEmpty end 
			end
		end
	end
	
	isEmpty = Tool.checkRedPetKind(index-1)
	
	isEmpty = isEmpty or false
    return isEmpty
end

function m:checkRedPoint()
	if self.type == "char" then 
		local ret =  false
		if self.char ~= nil then 
			ret = m:equipIsEmpty() or false -- Tool.checkGhostRedPiont(self.index - 1) or false --or self.char:redPointForStrong() or false --Tool.checkGhostRedPiont(self.index - 1) or false
		else
			ret = false
		end 
		self.red_point:SetActive(ret)
	end
end 

--根据star获取外框名字
function m:getFrameName(star)
    local icon = "kuang_baise"
    if star == 2 then
        icon = "kuang_lvse"
    elseif star == 3 then
        icon = "kuang_lanse"
    elseif star == 4 then
        icon = "kuang_zise"
    elseif star == 5 then
        icon = "kuang_chengse"
    elseif star == 6 then
        icon = "kuang_hongse"
    end
    return icon
end

--获取角色是否为空标志
function m:getFlag()
    return self.isEmpty
end

--设置角色是否为空标志
function m:setFlag(flag)
    if flag == nil then return end
    self.isEmpty = flag
end

function m:Start()
end

return m