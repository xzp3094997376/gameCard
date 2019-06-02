local m = {} 
--第五类型兑换UI的脚本

function m:update(data)
	self.data = data.info
	self.taksId = data.info.id
	self.delegate = data.delegate
	self.actType = data.delegate.actType
	self.Text_Title.text = self.data.target_desc
	local hasDuiTime
	local state
	self.btn_Get.gameObject:SetActive(false)
	self.Cost_num.gameObject:SetActive(false)
	self.btn_Get.isEnabled = true
	if self.actType == "day7" then
    	hasDuiTime = Player.Day7s[self.data.id].complete[self.data.id].progress
    	state = Player.Day7s[self.data.id].state
    	self.PlayactTypeList = Player.Day7s
    else
    	hasDuiTime = Player.DayNs[self.actType][self.data.id].complete.progress
    	state = Player.DayNs[self.actType][self.data.id].state
    	self.PlayactTypeList = Player.DayNs[self.actType]
    end
    if actType == "day7" then
		if self.data.day_num <= Player.Day7s.day then
			self.btn_Get.gameObject:SetActive(true)
			self.Cost_num.gameObject:SetActive(true)
		end
    else
    	if self.data.day_num <= Player.DayNs[self.actType].day then
			self.btn_Get.gameObject:SetActive(true)
			self.Cost_num.gameObject:SetActive(true)
    	end
    end
    --print(self.data.day_num..":"..self.PlayactTypeList.day)
	if self.data.drwc == 1 and self.Text_Tip ~= nil then
		self.Text_Tip.gameObject:SetActive(true)
    	if self.data.day_num == self.PlayactTypeList.day then
    		self.Text_Tip.text = TextMap.GetValue("Text_1_90")
    	elseif self.data.day_num < self.PlayactTypeList.day then
    		if state == 2 or state == 3 then
    			self.Text_Tip.text = ""
    		else
    			self.Text_Tip.text = TextMap.GetValue("Text_1_91")
    		end
    	else
			self.Text_Tip.gameObject:SetActive(false)
    	end
    end

    self.canDuiTime = self.data.times - hasDuiTime
    --print("任务名称："..self.data.target_desc..",已经兑换次数："..hasDuiTime.."，状态:"..state)
	self.Cost_num.text =string.gsub(TextMap.GetValue("LocalKey_781"),"{0}",self.canDuiTime)--这里还需要减去后台的已兑换次数
	self.canbuyNum = self.canDuiTime or 0
	self.gridList = {}
	for i = 0, self.data.consume.Count do
		if self.data.consume[i] ~= nil then
			local data = {}
			data.type = self.data.consume[i].consume_type
			data.arg = self.data.consume[i].consume_arg
			data.arg2 = self.data.consume[i].consume_arg2
			if Tool.typeId(data.type) then
				local canbuyNum = math.floor(Tool.getCountByType(data.type)/tonumber(data.arg))
                self.canbuyNum = math.min(self.canbuyNum, canbuyNum)
            else
            	self:getCanbuyNum(data)
			end
			table.insert(self.gridList, data)
		end
	end
	if #self.gridList < 2 then
		self.Drag.gameObject:SetActive(false)
	else
		self.Drag.gameObject:SetActive(true)
	end
	self.Grid:refresh(Item, self.gridList)
	self.Target_sprite_Con:CallUpdate(self.data.drop[0])
	self.ScrollView:ResetPosition()
	--
	self.Sprite_dis.gameObject:SetActive(false)
	if self.Sprite_dis ~= nil and self.data.discount~= nil and self.data.discount~= "" then
		self.Sprite_dis.gameObject:SetActive(true)
		self.Text_dis.text = self.data.discount
	end

	self.Text_Tip.gameObject:SetActive(false)
	if self.canDuiTime == 0 and self.canbuyNum then
		self.btn_Get.isEnabled = false
	end
end

function m:onClick(go,name)
	if name == "btn_Get" then
		if self.canbuyNum > 1 then
			self.delegate:openDuiFrom({self.data, self.canbuyNum, self.gridList, self.taksId, self.actType})
		elseif self.canbuyNum == 1 then
			Api:subDay14(self.delegate.actType, self.taksId, 1, function(result)
				--packTool:showMsg(result, nil, 2)
				Events.Brocast("UpdateRedPoint")
				self.delegate:TypeChoiseCb()
				self.delegate:showMsg(result)
			end, function() end)
		elseif self.canbuyNum == 0 then
			MessageMrg.show(TextMap.GetValue("Text_1_93"))
		elseif self.canDuiTime == 0 then
			MessageMrg.show(TextMap.GetValue("Text_1_94"))
		end
	end
end

function m:getCanbuyNum(cell)
    local _Count = 0
    local type = cell.type
    if type == "char" then
        local chars = Player.Chars:getLuaTable() --获取所有英雄
        --遍历所有角色
        for k, v in pairs(chars) do
            local char = Char:new(k, v)
            local blood = 0
            local bloodline = Player.Chars[char.id].bloodline
            if bloodline ~= nil then
                blood= bloodline.level
            end
            if char.info.exp==0 and blood==0 and char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char)==false then --是初始状态并且未上阵
                if tonumber(char.dictid)==tonumber(cell.arg) then 
                    _Count=_Count+1
                end  
            end 
        end
    elseif type == "charPiece" then
        local item = CharPiece:new(cell.arg)
        _Count=item.count
    elseif type == "equip" then
        local item = Equip:new(cell.arg)
        _Count=item.count
    elseif type == "equipPiece" then
        local item = EquipPiece:new(cell.arg)
        _Count=item.count
    elseif type == "item" then
        local item = uItem:new(cell.arg)
        _Count=item.count
    elseif type == "ghost" then
        local item = Ghost:new(cell.arg)
        _Count=item.count
    elseif type == "ghostPiece" then
        local item = GhostPiece:new(cell.arg)
        _Count=item.count
    elseif type == "treasure"then
        local item = Treasure:new(cell.arg)
        _Count=item.count
    elseif type == "fashion" then
        local item = Fashion:new(cell.arg)
        _Count=item.count
    elseif type == "pet" then
        local item = Pet:new(nil, cell.arg)
        _Count=item.count
    elseif type == "petPiece" then
        local item = PetPiece:new(cell.arg)
        _Count=item.count  
    elseif type == "treasurePiece"then
        local item = TreasurePiece:new(cell.arg)
        _Count=item.count
    end
    if cell.arg2=="" then cell.arg=1 end 
    local canbuyNum = math.floor(_Count/cell.arg2)
    self.canbuyNum = math.min(self.canbuyNum,canbuyNum) 
end

return m