-- 忍转身
local m = {}

function m:onClick(go, name)
    if name == "btn_add" then
		local bind = UIMrg:pushWindow("Prefabs/moduleFabs/hero/gui_detail_hero_select")
		bind:CallUpdate({ delegate = self })
	elseif name == "btn_target" then 
		if self.char == nil then return end 
		local bind = UIMrg:pushWindow("Prefabs/moduleFabs/hero/gui_renzhuanshen_select")
		bind:CallUpdate({ delegate = self, sourceChar = self.char, targetChar = self.targetChar })
	elseif name == "btn_select" then
		m:setSelected(not self.isSelect)
    elseif name == "btn_zhuanshen" then
		m:onZhuanShen()
	elseif name == "btn_rule" then
		UIMrg:pushWindow("Prefabs/moduleFabs/qiancengta/qiancengta_rule", {19,title = TextMap.GetValue("Text_1_785")})
	elseif name == "btn_zhuanshen_show" then
		m:showZhuanShen()
		--local bind = UIMrg:pushWindow("Prefabs/moduleFabs/hero/gui_renzhuanshen_info")
		--bind:CallUpdate({ sourceChar = self.char, targetChar = self.targetChar })
    end
end

function m:showZhuanShen()
	if self.char == nil or self.targetChar == nil then 
		return 
	end
	local idArr = {}
	idArr[1] = self.char.id
	local dictid = self.targetChar.dictid
	Api:charChange(false, idArr, dictid, self.isSelect, function(ret)
		if ret.ret == 0 then 
			local bind = UIMrg:pushWindow("Prefabs/moduleFabs/hero/gui_renzhuanshen_info")
			bind:CallUpdate({ sourceChar = self.char, targetChar = self.targetChar, targetInfo = ret.cc })
		end
	end)
end

function m:resetUI()
	if self.costItem then 
		self.costItem:updateInfo()
		self.txt_num.text = self.costItem.count or 0
	end 
	self.msg:SetActive(false)
	self.img1:SetActive(false)
	self.img2:SetActive(false)
	self.go_add:SetActive(true)
	self.img_diamond.gameObject:SetActive(false)
	self.img_renhun.gameObject:SetActive(false)
	self.txt_diamond.text = ""
	self.txt_renhun.text = ""
	self.go_target:SetActive(false)
	self.jianying:SetActive(true)
	self.hero1.gameObject:SetActive(false)
	self.hero2.gameObject:SetActive(false)
	self.btn_target.gameObject:SetActive(false)
	self.btn_zhuanshen_show.gameObject:SetActive(false)
	self.char = nil 
	self.targetChar = nil
end 

function m:showFx()
	self.mask:SetActive(true)
	if self.eff_zs == nil then 
		self.eff_zs = ClientTool.load("Effect_New/Prefab/renzhuanshen", self.eff_zhuanshen)
	else 
		self.eff_zs:SetActive(true)
	end
	self.binding:CallAfterTime(2, function()
		self.eff_zs:SetActive(false)
		self.mask:SetActive(false)
		m:showSummond()
		m:resetUI()
		self.btn_zhuanshen.isEnabled = true
	end)
end 

function m:showSummond()
    local luaTable = {
        char = self.targetChar,
        cb = function()
            UIMrg:pop()
        end,
		isShowInfo = true
    }
    Tool.push("RewardChar", "Prefabs/moduleFabs/choukaModule/RewardChar", luaTable)
end 

-- 是否存在上阵列表中
function m:isExitTeam(id)
    local teams = Player.Team[0].chars
    if teams == nil then
        return false
    end
    for i = 0, 5 do
        if teams.Count > i then
            if tonumber(teams[i]) == id then 
				return true
			end 
        end
    end
    return false
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

function m:onCheckCantHero(char)
	if char.Table.can_renzhuanshen ~= 1 then return false end -- 上阵的不能添加
   	if char.Table.star < 5 then return false end 
	if m:isExitTeam(char.id) then return true end --上阵
	if m:checkFriend(char.id) then return true end --小伙伴
	for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return true end
    end

	if Player.Info.level < self.maxRedLv then 
		-- 排除红卡
		if char.Table.star == 6 then return false end 
	end

	return false
end

function m:onFilter(char)
	if char.Table.can_renzhuanshen ~= 1 then return false end -- 上阵的不能添加
	if m:isExitTeam(char.id) then return false end --上阵
	if m:checkFriend(char.id) then return false end --小伙伴
	for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return false end
    end
	 if char.Table.star < 5 then return false end 

	if Player.Info.level < self.maxRedLv then 
		-- 排除红卡
		if char.Table.star == 6 then return false end 
	end 
	return true
end 

function m:update(lua)
    self.delegate = lua.delegate
    self.char = lua.char
end

function m:updateChar()
	local char = self.char
	local targetChar = self.targetChar
	self.go_add:SetActive(char == nil)
	self.go_target:SetActive(targetChar == nil)
	self.img1:SetActive(char ~= nil)
	self.img2:SetActive(targetChar ~= nil)
	self.jianying:SetActive(targetChar == nil)
	self.btn_target.gameObject:SetActive(false)
	self.btn_zhuanshen_show.gameObject:SetActive(false)
	if char ~= nil then
		self.hero1.gameObject:SetActive(true)
		self.hero1:LoadByModelId(char.modelid, "idle", function(ctl) end, false, 1)
		self.txt_name1.text = char:getDisplayName()
		self.btn_target.gameObject:SetActive(true)
	end
	if targetChar ~= nil then
		self.hero2.gameObject:SetActive(true)
		self.hero2:LoadByModelId(targetChar.modelid, "idle", function(ctl) end, false, 1)
		self.txt_name2.text = targetChar:getDisplayName()
		self.btn_zhuanshen_show.gameObject:SetActive(true)
	end
	
	if self.char ~= nil and self.targetChar ~= nil then 
		local tb = TableReader:TableRowByUniqueKey("renzhuanshen_consume", char.Table.rzs_pinzhi, self.targetChar.Table.rzs_pinzhi, char.Table.star)
		local res = uRes:new(tb.consume[0].consume_type)
		local res2 = uRes:new(tb.consume[1].consume_type)
		local img = res:getHeadSpriteName()
		local img2 = res2:getHeadSpriteName()
		local atlasName = packTool:getIconByName(img)
		local atlasName2 = packTool:getIconByName(img2)
		self.img_diamond:setImage(img, atlasName)
		self.img_renhun:setImage(img2, atlasName2)
		
		-- 计算一下消耗过的卡片
		local count = m:getCountByConsume(self.char)	
		self.img_diamond.gameObject:SetActive(true)
		self.img_renhun.gameObject:SetActive(true)
		--最终转换费用 = 总计角色数量 * 每单个角色转换消耗；
		local d_cost = (count + 1) * tb.consume[0].consume_arg
		local rh_cost = (count + 1) * tb.consume[1].consume_arg

		if Player.Resource.hunyu < rh_cost then 
			self.txt_renhun.text = "[ff0000]" .. rh_cost .. "[-]"
		else 
			self.txt_renhun.text = "[00ff00]" .. rh_cost .. "[-]"
		end 
		if Player.Resource.gold < d_cost then 
			self.txt_diamond.text = "[ff0000]" .. d_cost .. "[-]"
		else
			self.txt_diamond.text = "[00ff00]" .. d_cost .. "[-]"
		end

		if self.isSelect == false then 
			self.img_diamond.gameObject:SetActive(true)
			self.img_renhun.gameObject:SetActive(true)
			self.txt_diamond.gameObject:SetActive(true)
			self.txt_renhun.gameObject:SetActive(true)
		else 
			self.img_diamond.gameObject:SetActive(false)
			self.img_renhun.gameObject:SetActive(false)
			self.txt_diamond.gameObject:SetActive(false)
			self.txt_renhun.gameObject:SetActive(false)
		end
	end 
end

function m:getCountByConsume(char)	
	local count = 0
	-- 进化消耗的
	for i = 1,  char.star_level do 
		local row = TableReader:TableRowByUniqueKey("consume_starUp", char.Table.starUpid, i)
		if row then
			local consume = RewardMrg.getConsumeTable(row.consume, char.dictid)
			table.foreach(consume, function(i, v)
				if v:getType() == "char" then 
					count = count + v.rwCount
				end 
			end)
		end
	end
	-- 觉醒消耗的
	for i = 1,  char.stage - 1 do 
		local row = TableReader:TableRowByUniqueKey("powerUp", char.Table.powUpId, i)
		if row then
			local consume = RewardMrg.getConsumeTable(row.consume, char.dictid)
			table.foreach(consume, function(i, v)
				if v:getType() == "char" then 
					count = count + v.rwCount
				end
			end)
		end
	end
	return count or 0
end 

function m:onZhuanShen()
	if self.char == nil or self.targetChar == nil then return end 
	local idArr = {}
	idArr[1] = self.char.id
	local dictid = self.targetChar.dictid
	self.btn_zhuanshen.isEnabled = false
	Api:charChange(true, idArr, dictid, self.isSelect, function(ret)
		if ret.ret == 0 then 
			self:showFx()
		end 
	end, function()
		self.btn_zhuanshen.isEnabled = true
	end)
end

function m:onEnter()
	LuaMain:ShowTopMenu(6, nil, {[1]={ type="hunyu"},[2]={ type="gold"}})
end 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_786"))
	--LuaMain:ShowTopMenu(6, nil, nil)
	LuaMain:ShowTopMenu(6, nil, {[1]={ type="hunyu"},[2]={ type="gold"}})
	self:setSelected(false)
	--self.img1:SetActive(false)
	--self.img2:SetActive(false)
	--self.mask:SetActive(false)
	m:resetUI()
	
	
	self.effNode = ClientTool.load("Effect_New/Prefab/renzhuanshen-dizhen", self.eff)
	self.maxRedLv = TableReader:TableRowByID("renzhuanshen", "renzhuanshen_unlock_star_6").value2
	
	local tb = TableReader:TableRowByID("renzhuanshen", "renzhuanshenItem")
	local item = uItem:new(tb.value2)
	self.costItem = item
    local img = item:getHeadSpriteName()
    local assets = packTool:getIconByName(img)
	self.sp_icon:setImage(img, assets)
	self.txt_num.text = self.costItem.count or 0
end 

function m:onCallBack(char)
    UIMrg:popWindow()
	self:resetUI()
    self.char = char
    m:updateChar()
end

function m:onTargetCallBack(char)
    UIMrg:popWindow()
	self.targetChar = char
    m:updateChar()
end

function m:setSelected(selected)
	self.isSelect = selected
	self.selected:SetActive(self.isSelect)
	self.msg:SetActive(self.isSelect)
	
	self.img_diamond.gameObject:SetActive(not self.isSelect)
	self.img_renhun.gameObject:SetActive(not self.isSelect)
	self.txt_diamond.gameObject:SetActive(not self.isSelect)
	self.txt_renhun.gameObject:SetActive(not self.isSelect)
end

return m



