
local m = {}

function m:update(lua)
    self.pet = lua.pet
	self.delegate = lua.delegate
	self:onUpdate()
end

function m:onUpdate()
	self.pet:updateInfo()
	self:updateDes()
	self.txt_name.text = self.pet.char:getDisplayName()
	self.txt_name2.text = self.pet:getDisplayName()
	if self._char == nil then 
		self._char = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.imgframe1.gameObject)
	end 
	self._char:CallUpdate({ "char", self.pet.char, 110, 110 })
	
	if self._pet == nil then 
		self._pet = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.imgframe2.gameObject)
	end 
	self._pet:CallUpdate({ "char", self.pet, 110, 110 })
end 		


function m:updateDes()
	    --属性与描述
	local txt = {self.txt_attr_left2, self.txt_attr_left, self.txt_attr_right, self.txt_attr_right2}
	
	local magics = {}
	for i = 1, 20 do 
		local tb = TableReader:TableRowByID("petArgs", "pet_huyou_" .. i)
		if tb then 
			table.insert(magics, tb.value)
		else 
			break
		end 
    end
	
	local huyou_p = TableReader:TableRowByID("pet", self.pet.dictid)
	local rate = huyou_p.huyou
	
	for i = 1, #txt do 
		_, txt[i].text = self.pet:GetAttrNewByP(magics[i], self.pet.info.propertys, rate)
	end 
end 

function m:Start()

end

function m:onClick(go, name)
    if name == "btnBack" then
        UIMrg:popWindow()
	elseif name == "bt_delete" then 
		m:onDelete()
	elseif name == "bt_replace" then 
		m:onReplace()
	elseif name == "btn_hero" then 
		if self.pet then 
			Tool.push("petInfo", "Prefabs/moduleFabs/hero/hero_info", self.pet.char)
		end
	elseif name == "btn_pet" then 
		if self.pet then 
			Tool.push("petInfo", "Prefabs/moduleFabs/hero/pet_info", self.pet)
		end	
	end
end

function m:onDelete()
	Api:petHuyouUnload(self.pet.charIndex, function(result)
		UIMrg:popWindow()
		if self.delegate then 
			self.delegate:onUpdate()
		end
	end, function()
		return false
	end)
end 

-- 是否有同类型的宠物在护佑
function m:isOneKindExitTeam(dictid)
    local ghostSlot = Player.ghostSlot
    for i = 0, 5 do 
        local slot = ghostSlot[i]
        local petid = slot.petid
        if petid ~=nil and petid ~=0 then 
            local pet = Pet:new(petid,nil)
			print(pet.name)
			print(pet.dictid)
            if dictid == pet.dictid then 
                return true
            end 
        end 
    end 
    return false
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

function m:onFilterPet(pet)
	if m:checkHuyou(pet.id) then return false end 
	if m:isOneKindExitTeam(pet.dictid) == true then return false end 
	if m:petIsOnTeam(pet.id) == true then return false end 
	return true
end 

function m:petIsOnTeam(petId)
	if Player.Team[0].pet ~= nil and Player.Team[0].pet == petId then  
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

function m:onReplace()
	local bind = UIMrg:pushWindow("Prefabs/moduleFabs/formationModule/formation/formation_select_char")
    bind:CallUpdate({ type = "pet", module = "ghost", delegate = self, index = 1 })
end 

function m:onCallBack(char, tp)
    if tp == "pet" or tp == "pet_huyou" then 
		Api:petHuyou(char.id, self.pet.charIndex, function(result)
			self.delegate:onUpdate()
			UIMrg:popWindow()
			end, function()
			return false
		end)
    end
end

function m:updateHero()
	self:update(self.allChars[self.index])
end 

return m
