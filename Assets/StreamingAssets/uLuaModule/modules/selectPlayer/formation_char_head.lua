-- 头像
local m = {}


--点击事件
function m:onClick(uiButton, eventName)
    if (eventName == "btn_up") then
        if self.delegate._type == "char" then
            self.delegate:onCallBack(self.char, self.delegate._selectType)
            UIMrg:popWindow()
            return
		elseif self.delegate._type == "pet" or self.delegate._type == "pet_huyou" then 
			self.delegate:onCallBack(self.char, self.type)
            UIMrg:popWindow()
            return
        elseif self.delegate._type == "yuling"  then 
            self.delegate:onCallBack(self.char, self.type)
            UIMrg:popWindow()
            return
        end
        self:onSelect(uiButton)
    end
end

function m:onSelect(go)
    if self.char.isSelected == false then
        if self.delegate:isFull() then return end
    end
    self.char.isSelected = not self.char.isSelected
    local pos = self.delegate:pushToTeam(self.char, self.char.isSelected)
    if pos ~= -1 then
        self.char.formation_pos = pos
        self:updateState()
        self.delegate:setInfo()
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

function m:updatePet()
    local char = self.char
    self.labName.text = char:getDisplayName() --名字
	self.txt_lv.text = char.lv
	self.img_type.gameObject:SetActive(false)
	local ret = m:petIsOnTeam(char.id)
	self.txt_onteame:SetActive(ret)
	self.txt_fetter.gameObject:SetActive(false)
	--local hbret = m:checkFriend(char.id)
	--self.huoban:SetActive(hbret)
	self.txt_power.text = char.power
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
end

function m:updateYuling()
    local char = self.char
    self.labName.text = char:getDisplayName() --名字
    self.txt_lv.text = char.lv
    self.img_type.gameObject:SetActive(false)
    local info = Player.yuling[char.id] 
    local ret=false
    if info.huyou>0 then 
        ret=true
    end
    self.btn_up.isEnabled = not ret
    self.txt_onteame:SetActive(ret)
    self.txt_fetter.gameObject:SetActive(false)
    self.txt_power.text = char.power
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
end


function m:updateChar()
    local char = self.char
    self.labName.text = char:getDisplayName() --名字
	self.txt_lv.text = char.lv
	self.img_type.spriteName = char:getDingWei()
	local ret = m:checkChar(tonumber(char.id))
	self.txt_onteame:SetActive(ret)
	local hbret = m:checkFriend(char.id)
	self.huoban:SetActive(hbret)
	
	if self.delegate.module ~= "daili" then 
		self.txt_btn.text = TextMap.GetValue("Text_1_1013")
	else
		self.txt_btn.text = TextMap.GetValue("Text_1_778")
	end
    --    self.pic:setImage(char:getHeadSpriteName(), "headIcon_atlas")
    --    self.img_frame.spriteName = char:getFrame()
    --    self.lv_bg.spriteName = char:getLvFrame()
    --    self.txt_lv.text = char.lv
    --    local stars = {}
    --    for i = 1, char.star do
    --        stars[i] = i
    --    end

    --    ClientTool.UpdateGrid("", self.star, stars)
    --显示羁绊数量
    if self.char.fetter_number == nil or self.char.fetter_number == 0 then
        self.txt_fetter.gameObject:SetActive(false)
        self.txt_power.gameObject:SetActive(true)
        self.txt_power.text = char.power
    else
		self.txt_fetter.gameObject:SetActive(true)
        self.txt_fetter.text = TextMap.GetValue("Text_1_1050") .. self.char.fetter_number
        self.txt_power.gameObject:SetActive(false)
    end


    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })
    if self.delegate._type == "single" then
        -- self.selected:SetActive(false)
        Tool.SetActive(self.pos, char.teamIndex < 7)
        return
    end
    --self:updateState()
	if self.delegate.module == "ghost" and self.delegate._type == "char" then 
		local list = {}
		for i = 0, 5 do 
			list[i+1] = Player.Team[0].chars[i]
		end 
		list[self.delegate.pos_index] = self.char.id
		self.go_heti:SetActive(self.delegate.delegate:hasHeTi(list, self.char, true))
	else 
		self.go_heti:SetActive(false)
	end 
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

        --        self.binding:Hide("txt_pos")
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

function m:updatefigFetterNumber()
    if self.Label_piece ~= nil then
        self.Label_piece.gameObject:SetActive(false)
    end
    if self.delegate.module ~= "daili" then 
        self:configFetterNumber(self.char)
	else 
		-- 显示碎片
		local piece = self.char:getPiece()
		--piece:updateInfo()
		self.txt_fetter.gameObject:SetActive(false)
        if self.Label_piece ~= nil then
            self.Label_piece.gameObject:SetActive(true)
            self.Label_piece.text = TextMap.GetValue("Text_1_1051") .. (piece.count or 0)
        end
		self.txt_fetter.text = TextMap.GetValue("Text_1_1051") .. (piece.count or 0)
    end
end

function m:configFetterNumber(char)
    local team = self.delegate.delegate:getTeam()
    local friend = self.delegate.delegate:getXiaoHuoBanTeam()
    if self.delegate.module == "formation" or self.delegate.module == "ghost" then --替换主阵上的角色
        team[self.delegate.pos_index] = char.id
        local number = self.delegate:config(team, friend, char.dictid)
        char.fetter_number = number
    elseif self.delegate.module == "teamer" then --替换小伙伴
        if m:isContainTheKindChar(char,team,friend)==true then 
            char.fetter_number = 0
        else 
            friend[self.delegate.pos_index] = char.id
            local number = self.delegate:config(team, friend, char.dictid)
            char.fetter_number = number
        end
    end
	self.txt_power.gameObject:SetActive(true)
    self.txt_power.text = char.power
	
    --显示羁绊数量
    if char.fetter_number == nil or char.fetter_number == 0 then
		self.txt_fetter.gameObject:SetActive(false)
    else
		self.txt_fetter.gameObject:SetActive(true)
        self.txt_fetter.text = TextMap.GetValue("Text_1_1050").. char.fetter_number
    end
end

function m:isContainTheKindChar(char,team,friend)
    if team == nil and friend == nil then return false end
    local relationid =TableReader:TableRowByID("char",char.dictid).relationid
    for i = 1, 6 do
        local id = team[i]
        if id ~= nil and id ~= 0 and id ~= "0" and id ~=char.id then
            if Tool.getDictId(id)== char.dictid then 
                return true
            else 
                local _relationid =TableReader:TableRowByID("char",Tool.getDictId(id)).relationid
                if relationid==_relationid then 
                    return true 
                end 
            end 
        end 
    end
    if friend ~=nil then 
        for j=1,#friend do 
            local id = friend[j]
            if id ~= nil and id ~= 0 and id ~= "0" and id ~=char.id then
                if Tool.getDictId(id)== char.dictid then
                    return true
                else
                    local _relationid =TableReader:TableRowByID("char",Tool.getDictId(id)).relationid
                    if relationid==_relationid then
                        return true 
                    end 
                end 
            end
        end
    end
    return false
end

--更新角色列表
--@char 角色 uChar.lua
--@index 列表中的位置
--@delegate 数据控制
function m:update(lua)
	self.go_heti:SetActive(false)
    self.index = lua.index
    self.char = lua.char
	self.type = lua.char.type
    self.delegate = lua.delegate
	if self.type == "char" then 
		self:updateChar()
		self:updatefigFetterNumber()
	elseif self.type=="yuling" then 
        m:updateYuling()
    else 
		m:updatePet()
	end 
end


return m

