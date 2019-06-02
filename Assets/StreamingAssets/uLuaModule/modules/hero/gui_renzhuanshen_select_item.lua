-- 头像
local m = {}


--点击事件
function m:onClick(uiButton, eventName)
    if (eventName == "button") then
        self.delegate.delegate:onTargetCallBack(self.char)
        UIMrg:popWindow()
        return
    end
end

function m:updateChar()
    local char = self.char
	if char.source ~= nil then 
		char:initInfo(char.source)
	end
	if char.Table.rzs_pinzhi == 1 then 
		self.pos:SetActive(true)
	else 
		self.pos:SetActive(false)
	end 
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
	self.img_type.spriteName = char:getDingWei()
	self.txt_lv.gameObject:SetActive(true)
	self.txt_xuemai.gameObject:SetActive(true)
	self.button.gameObject:SetActive(true)
	--属性信息
	self.txt_lv.text = "[ffff96]" .. TextMap.GetValue("Text1143") .. "[-]" ..  char.lv
	self.txt_name.text = char:getDisplayName()
	self.txt_xuemai.text = "[ffff96]" .. TextMap.GetValue("Text1144") .. "[-]" .. Player.Chars[char.id].bloodline.level
	self.font.text = TextMap.GetValue("Text_1_778")

	if self.char.lv >= 50 then	
		self.stars.gameObject:SetActive(true)
		self.txt_juexing.text = TextMap.GetValue("Text_1_779") .. self.char:getStageStar()
		local star = math.floor ( self.char.stage / 10 )
		local starLists = {}
		local showStar = false
		for i = 1, 6 do
			showStar = false
			if i <= star then 
				showStar = true
			end
			starLists[i] = { isShow = showStar }
		end
		self.stars:refresh("", starLists, self)
		starLists = nil
		showStar = nil
	else
		self.txt_juexing.text = ""
		self.stars.gameObject:SetActive(false)
	end

	if self.HuaShenInfo ~= nil then self.HuaShenInfo.gameObject:SetActive(false) end

	if self.char.id ~= Player.Info.playercharid and self.char.star_level >= 8 and self.char.lv >= 90 and self.HuaShenInfo ~= nil then
		if self.char.star >= 5 then
			self.HuaShenInfo.gameObject:SetActive(true)
			self.Label_huashenLevel.text = self.char:getHuaShenLevel(self.char.id, self.char.dictid, self.char.quality) --TextMap.GetValue("Text_1_780")..
		else
			self.HuaShenInfo.gameObject:SetActive(false)
		end
	end
end

--判断角色是否上阵
function m:checkChar(charid)
    local teams = Player.Team[0].chars
    local list = {}
    for i = 0, 5 do
        if charid == tonumber(teams[i]) then
            return true
        end
    end
    return false
end

--获取小伙伴队列
function m:checkFriend(charId)
    local teams = Player.Team[12].chars
    local list = {}
    for i = 0, 7 do
        if tonumber(teams[i]) == charId then
            return true
        end
    end
    return false
end

function m:petIsOnTeam(petId)
	local ret = false 
	if Player.Team[0].pet ~= nil and tostring(Player.Team[0].pet) ~= "0" then 
		if petId == Player.Team[0].pet then 
			ret = true
		end 
	end 
	return ret
end 

function m:updateState()
    if self.char.isSelected == true then
        -- self.selected:SetActive(true)
        self.cant_selected:SetActive(false)
        --        self.txt_pos.text = self.char.formation_pos
        --        self.binding:Show("txt_pos")
        self.binding:Show("pos")
        self.bg.alpha = 1
    else
        self.binding:Hide("pos")

        if self.delegate:isFull() then
            self.bg.alpha = 166 / 255
            self.cant_selected:SetActive(true)
        else
            self.bg.alpha = 1
            self.cant_selected:SetActive(false)
        end
        -- self.selected:SetActive(false)
    end
end
--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
    self.index = lua.index
    self.char = lua.char
    self.delegate = lua.delegate
	self:updateChar()
end


return m

