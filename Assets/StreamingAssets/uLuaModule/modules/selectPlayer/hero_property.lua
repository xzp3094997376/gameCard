
local hero_property = {}

function hero_property:update(data)
	self.delegate = data.delegate
    hero_property:setHero(data.char)
    self.char = Char:new(data.char.id, data.char.dictid)
	self:onUpdate()
end

function hero_property:onUpdate()
	self.char:updateInfo()
	self:updateDes()
end 

function hero_property:updateDes()
	    --属性与描述
    local list = self.char:getAttrDesc()
	self.txt_attr_left.text = list[1]
	self.txt_attr_left2.text = list[2]
	self.txt_attr_right.text = list[4]
	self.txt_attr_right2.text = list[5]
	self.img_type.spriteName = self.char:getDingWei()
	--self.txtLv.text = TextMap.GetValue("Text_1_876") .. self.char.lv
	self.txt_power.text = self.char.power
	
	self.txt_attr_left_advance.text = self:getMagics({"HitC", "CritC", "PhyDmgDecP" })
	self.txt_attr_right_advance.text = self:getMagics({"DodgeC", "ImmCritC", "PhyDmgIncP"})
	
	self.txt_huashen.gameObject:SetActive(false)
	
	local starLists = {}
	local showStar = false
	local star = math.floor (self.char.stage / 10 )
    for i = 1, 6 do
		showStar = false
		if i <= star then 
			showStar = true
		end
        starLists[i] = { isShow = showStar }
    end
	self.stars:refresh("", starLists, self)
	
    if self.char.star >= 5 and 
	   self.char.lv >= 90 and 
	   self.char.star_level >= 8 and 
	   self.char.id ~= Player.Info.playercharid then
		self.txt_huashen.gameObject:SetActive(true)
        self.txt_huashen.text = self.char:getHuaShenLevel(self.char.id, self.char.dictid, self.char.quality)
    end
	
	self.img_heti:SetActive(self.delegate:hasHeTi(Player.Team[0].chars, self.char))
	
	if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", self.char, self.img_frame.width, self.img_frame.height })

end 

function hero_property:getMagics(list)
	local str = ""
	for i = 1, #list do 
		local _, desc = self.char:GetAttrByChar(list[i])
		str = str .. desc .. "\n"
	end 
	return str
end


function hero_property:setHero(char)
	self.hero:LoadByModelId(char.modelid, "idle", function() end, false, 0, 1)
	self.txt_lv_name.text = char:getDisplayName()
end

function hero_property:Start()

end

--刷新英雄列表
function hero_property:findTeamHeroList()
    local charsList = {} --所有英雄

	local teams = Player.Team[0].chars
    self.team_count = 0
    for i = 0, 5 do
        if teams.Count > i then
            if teams[i] ~= 0 and teams[i] ~= "0" then
                local char = Char:new(teams[i])
				table.insert(charsList, char)
            end
        end
    end
	
    for i = 1,#charsList do
        local char = charsList[i]
		if char.id == self.char.id then 
			self.index = i
		end 
    end
	
	self.minIndex = 1
	self.maxIndex = #charsList
    self.allChars = charsList
end

function hero_property:onClick(go, name)
    if name == "btnBack" then
        UIMrg:popWindow()
	elseif name == "btn_left" then 
		self:onLeft()
	elseif name == "btn_right" then 
		self:onRight()
	end
end


function hero_property:onLeft()
	if self.allChars == nil then 
		self:findTeamHeroList()
	end  
	
	self.index = self.index - 1
	if self.index < self.minIndex then self.index = self.minIndex end 
	self:updateHero()
end 

function hero_property:onRight()
	if self.allChars == nil then 
		self:findTeamHeroList()
	end
	
	self.index = self.index + 1
	if self.index > self.maxIndex then self.index = self.maxIndex end 
	self:updateHero()
end 

function hero_property:updateHero()
	self:update({char = self.allChars[self.index], delegate = self.delegate})
end 

return hero_property
