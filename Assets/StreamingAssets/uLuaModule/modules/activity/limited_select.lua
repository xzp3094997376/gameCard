local m = {} 

function m:update(lua)
    --获取那些角色被选择了的
    self.teamList={}
    self.select_num=0
    for i,v in ipairs(lua.teams) do
    	self.select_num=self.select_num+1
    	table.insert(self.teamList,v)
    end
    self.delegate = lua.delegate
    self.date=lua.data
    self.charList={}
    self.isCanAdd=false
    self.selectNum.text=self.select_num .. "/" .. self.date.num
    if self.date.type=="char" then 
        self.charList=self:getHeroList()
        if self.isCanAdd==false then
            MessageMrg.show(TextMap.GetValue("Text_1_51"))
            if self.teamList~=nil and #self.teamList>0 then 
                self.delegate:AfterAddItem({})
            end
            UIMrg:popWindow()
            return false
        else 
            self.scrollView:refresh(self.charList, self, false)
        end 
    elseif self.date.type== "pet" then 
        self.charList=self:getPets()
        if self.isCanAdd==false then
            MessageMrg.show(TextMap.GetValue("Text_1_52"))
            if self.teamList~=nil and #self.teamList>0 then 
                self.delegate:AfterAddItem({})
            end 
            UIMrg:popWindow()
            return false
        else 
            self.scrollView:refresh(self.charList, self, false)
        end 
    elseif self.date.type== "ghost" then 
        self.charList=self:getGhostList()
        if self.isCanAdd==false then
            MessageMrg.show(TextMap.GetValue("Text_1_53"))
            if self.teamList~=nil and #self.teamList>0 then 
                self.delegate:AfterAddItem({})
            end
            UIMrg:popWindow()
            return false
        else 
            self.scrollView:refresh(self.charList, self, false)
        end 
    elseif self.date.type== "treasure" then 
        self.charList=self:getTreasure()
        if self.isCanAdd==false then
            MessageMrg.show(TextMap.GetValue("Text_1_54"))
            if self.teamList~=nil and #self.teamList>0 then 
                self.delegate:AfterAddItem({})
            end
            UIMrg:popWindow()
            return false
        else 
            self.scrollView:refresh(self.charList, self, false)
        end 
    end 
end
function m:updateTeams(char,ret)
	if ret==true then 
		self.select_num=self.select_num+1
		self.selectNum.text=self.select_num .. "/" .. self.date.num
		table.insert(self.teamList,char)
	else
		for i,v in ipairs(self.teamList) do
			if v.id ==char.id then
				self.select_num=self.select_num-1
				self.selectNum.text=self.select_num .. "/" .. self.date.num
				table.remove(self.teamList,i)	
			end 
		end
	end 
	
end

function m:onClick(go, name)
	print(name)
	if name == "btn_ok" then --确认选择了那些英雄
		self.delegate:AfterAddItem(self.teamList)
		UIMrg:popWindow()
	elseif name == "btnBack" then 
		self.teamList=nil
		UIMrg:popWindow()
    elseif name == "btClose" then
    	self.teamList=nil
        UIMrg:popWindow()
    end
end

function m:getTreasure()
    local list = {}
    local _list = {}
    local all_list = Tool.getUnUseTreasure()
    for k,v in pairs(all_list) do
        local m = {}
        local char = Treasure:new(v.value.id, v.key)
         if char.star== tonumber(self.date.star) then 
            if char.kind~="jing" and char.lv==1 and char.exp==0 and char.power==0 then 
                local isChoose = self:isInTeam_two(char)
                m.char = char
                self.isCanAdd=true
                m.char.isChoose = isChoose
                m.num=1
                m.char.isCanChoose = true
                table.insert(list, m)
            -- else 
            --     m.char = char
            --     m.char.isChoose = false
            --     m.num=1
            --     m.char.isCanChoose = true
            --     table.insert(_list, m)
            end 
        end
    end
    table.sort(list, function(aData, bData)
        local a = aData.char
        local b = bData.char
        if a.lv ~= b.lv then return a.lv < b.lv end
        if a.power ~= b.power then return a.power < b.power end
        return a.id < b.id
    end)
    -- table.sort(_list, function(aData, bData)
    --     local a = aData.char
    --     local b = bData.char
    --     if a.lv ~= b.lv then return a.lv < b.lv end
    --     if a.power ~= b.power then return a.power < b.power end
    --     return a.id < b.id
    -- end)
    -- for i,v in ipairs(_list) do
    --     table.insert(list, v)
    -- end
    list = self:getData(list)
    return list
end

--对鬼道进行筛选，筛选出有培养过的鬼道
function m:getGhostList()
    local ghost = Tool.getUnUseGhost()
    local list = {}
    local _list = {}                                                                                      list = {}
    for i = 1, #ghost do
        local m = {}
        local gh = ghost[i]
        gh:updateInfo()
        if gh.star== tonumber(self.date.star) then 
            if gh.lv==1 and gh.exp==0 and gh.power==0 then 
                local isChoose = self:isInTeam_two(gh)
                m.char = gh
                m.char.isChoose = isChoose
                self.isCanAdd=true
                m.num=1
                m.char.isCanChoose = true
                table.insert(list, m)
            -- else 
            --     m.char = gh
            --     m.char.isChoose = false
            --     m.num=1
            --     m.char.isCanChoose = true
            --     table.insert(_list, m)
            end 
        end
    end
    table.sort(list, function(aData, bData)
        local a = aData.char
        local b = bData.char
        if a.lv ~= b.lv then return a.lv < b.lv end
        if a.power ~= b.power then return a.power < b.power end
        return a.id < b.id
    end)
    -- table.sort(_list, function(aData, bData)
    --     local a = aData.char
    --     local b = bData.char
    --     if a.lv ~= b.lv then return a.lv < b.lv end
    --     if a.power ~= b.power then return a.power < b.power end
    --     return a.id < b.id
    -- end)
    -- for i,v in ipairs(_list) do
    --     table.insert(list, v)
    -- end
    list = self:getData(list)
    return list
end

function m:isInTeam_two(char)
    local isIn = false
    if self.teamList~=nil and #self.teamList>0 then 
        table.foreach(self.teamList, function(k, v)
            if char.id == v.id and char.key == v.key then
                isIn = true
            end
        end)
    end 
    return isIn
end

function m:petIsOnTeam()
    local ret = false 
    if Player.Team[0].pet ~= nil and tostring(Player.Team[0].pet) ~= "0" then 
        ret = true 
    end 
    return ret
end 

function m:petOnFilter(pet)
    if self:checkHuyou(pet.id) then return false end 
    return true
end 


function m:checkHuyou(petId)
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

--对宠物进行筛选
function m:getPets()
    self.isCanAdd=false
    local ids = {}
    if self:petIsOnTeam() == true then
        ids[Player.Team[0].pet .. ""] = true
    end

    local function isShow(id)
        if ids[id .. ""] then
            return false
        end
        return true
    end

    local pets = Player.Pets:getLuaTable()
    local petsList = {}
    local _petsList = {}
    for k, v in pairs(pets) do
        local pet = Pet:new(k, v)
        if pet.star == tonumber(self.date.star) and isShow(pet.id) then
            if self.petOnFilter then
                if self:petOnFilter(pet) then
                    if pet.lv==1 and pet.info.exp==0 and pet.star_level==0 and pet.shenlian==0 and pet.shenlianExp==0 then 
                        local m = {}
                        m.num = 1
                        m.char = pet
                        m.char.isCanChoose=true
                        self.isCanAdd=true
                        m.char.isChoose = self:isInTeam(pet)
                        table.insert(petsList, m)
                        m = nil
                    -- else 
                    --     local m = {}
                    --     m.num = 1
                    --     m.char = pet
                    --     m.char.isCanChoose=false
                    --     m.char.isChoose = self:isInTeam(pet)
                    --     table.insert(_petsList, m)
                    --     m = nil
                    end 
                end
            else
                if pet.lv==1 and pet.info.exp==0 and pet.star_level==0 and pet.shenlian==0 and pet.shenlianExp==0 then 
                    local m = {}
                    m.num = 1
                    m.char = pet
                    m.char.isCanChoose=true
                    self.isCanAdd=true
                    m.char.isChoose = self:isInTeam(char)
                    table.insert(petsList, m)
                    m = nil
                -- else 
                --     local m = {}
                --     m.num = 1
                --     m.char = pet
                --     m.char.isCanChoose=false
                --     m.char.isChoose = self:isInTeam(char)
                --     table.insert(_petsList, m)
                --     m = nil
                end 
            end
        end
    end
    table.sort(petsList, function(aData, bData)
        local a = aData.char
        local b = bData.char
        if a.lv ~= b.lv then return a.lv < b.lv end
        if a.shenlian ~= b.shenlian then return a.shenlian < b.shenlian end
        if a.star_level ~= b.star_level then return a.star_level < b.star_level end
        return a.dictid < b.dictid
    end)
    -- table.sort(_petsList, function(aData, bData)
    --     local a = aData.char
    --     local b = bData.char
    --     if a.lv ~= b.lv then return a.lv < b.lv end
    --     if a.shenlian ~= b.shenlian then return a.shenlian < b.shenlian end
    --     if a.star_level ~= b.star_level then return a.star_level < b.star_level end
    --     return a.dictid < b.dictid
    -- end)
    -- for i,v in ipairs(_petsList) do
    --     table.insert(petsList, v)
    -- end
    petsList = self:getData(petsList)
    return petsList
end

function m:checkFriend(char)
    local teams = Player.Team[12].chars
    local list = {}
    local len = teams.Count
    for i = 0, 7 do
        if i < len then
            if char.id .. "" == teams[i] .. "" then
                return true
            end
        end
    end
    return false
end

function m:onAgency(char)
    if char.id == Player.Info.playercharid then return true end 
    for i = 1, 6 do
        local it = Player.Agency[i]
        if tonumber(it.charId) == tonumber(char.id) then return true end
    end
    return false
end

function m:getHeroList()
    --获取角色列表和碎片列表
    self.isCanAdd=false
    local chars = Player.Chars:getLuaTable() --获取所有英雄
    local index = 1
    local list = {}
    local _list = {}
    --遍历所有角色
    for k, v in pairs(chars) do
        local char = Char:new(k, v)
        if char.star == tonumber(self.date.star) then 
	        if char.Table.can_return==1 and char.lv==1 and char.info.exp==0 and char.stage==0 and char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char)==false then --是初始状态并且未上阵
	            local m = {}
	            local isChoose = self:isInTeam(char)
	            m.num = 1
	            m.char = char
	            m.char.isChoose = isChoose
                self.isCanAdd=true
	            m.char.isCanChoose=true
	            table.insert(list, m)
	            m = nil
	        -- elseif char:getTeamIndex() == 7 and self:checkFriend(char) == false and self:onAgency(char)==false then --是初始状态并且未上阵
	        --     local m = {}
	        --     local isChoose = self:isInTeam(char)
	        --     m.num = 1
	        --     m.char = char
	        --     m.char.isCanChoose=false
	        --     m.char.isChoose = isChoose
	        --     table.insert(_list, m)
	        --     m = nil
	        end
	    end 
    end
    table.sort(list, function(aData, bData)
        local a = aData.char
        local b = bData.char
        if a.lv ~= b.lv then return a.lv < b.lv end
        if a.stage ~= b.stage then return a.stage < b.stage end
        if a.star_level ~= b.star_level then return a.star_level < b.star_level end
        return a.dictid < b.dictid
    end)
    -- table.sort(_list, function(aData, bData)
    --     local a = aData.char
    --     local b = bData.char
    --     if a.lv ~= b.lv then return a.lv < b.lv end
    --     if a.stage ~= b.stage then return a.stage < b.stage end
    --     if a.star_level ~= b.star_level then return a.star_level < b.star_level end
    --     return a.dictid < b.dictid
    -- end)
    -- for i,v in ipairs(_list) do
    -- 	table.insert(list, v)
    -- end
    list = self:getData(list)
    return list
end

function m:getData(data)
    local list = {}
    local row = 2
    for i = 1, table.getn(data), row do
        local li = {}
        local len = 0
        for j = 0, row - 1 do
            if data[i + j] then
                local d = data[i + j]
                if d.char:getType() == "char" then
                    d.realIndex = i + j
                end
                li[j + 1] = d
                len = len + 1
            end
        end
        if len > 0 then
            table.insert(list, li)
        end
    end
    return list
end

function m:isInTeam(char)
    local isIn = false
    if self.teamList~=nil and #self.teamList>0 then 
	    table.foreach(self.teamList, function(k, v)
	        if char:getType() == v:getType() and char.id == v.id then
	            isIn = true
	        end
	    end)
	end 
    return isIn
end

return m
