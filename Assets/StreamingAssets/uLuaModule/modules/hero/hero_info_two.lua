local hero_info = {}

function hero_info:update(char)
    hero_info:setHero(char)
    self.char = char
    	local lua ={ type = "skill", nChar = self.char, char = char }
    	self:onUpdate()
    	self.skill:CallUpdate(lua)
    hero_info:setSoundState()
    if char.isGo~=nil and char.isGo==false then 
    	self.btnGoto.gameObject:SetActive(false)
    else 
    	self.btnGoto.gameObject:SetActive(true)
    end 
end

function hero_info:setSoundState()
	local soundInfo = TableReader:TableRowByID("avter", self.char.dictid)
	if soundInfo.jianjie_audio ~= nil and soundInfo.jianjie_audio ~= "" and soundInfo.jianjie_audio > 0 then
		self.soundId = soundInfo.jianjie_audio
		self.btn_sound.gameObject:SetActive(true)
	else
		self.btn_sound.gameObject:SetActive(false)
	end
end

function hero_info:onEnter()
	self:onUpdate()
end 

function hero_info:onUpdate()
	self.char:updateInfo()
	self:updateDes()
end 

function hero_info:updateDes()
	    --属性与描述
	if self.char.id<0 then 
		self.img_type.spriteName = self.char:getDingWei()
		self.txt_hero_desc.text = self.char.Table.desc
		local fetterList = self:getAllFetter()
		self.fate:CallUpdate({ type = "other", list = fetterList })
		self:updatePowerSkill()
		self:updateStarUpSkill()
		return 
	end 
end 


function hero_info:onClick(go, name)
    if name == "btnBack" then
        UIMrg:pop()
    elseif name=="btnGoto" then 
    	--local charPiece = CharPiece:new(self.char.dictid)
    	local temp = {}
		temp.obj = self.char
		temp._type = "char"
		MessageMrg.showTips(temp)
	elseif name == "btn_sound" then
 		MusicManager.playByID(self.soundId)
	end
end


function hero_info:updatePowerSkill()
	-- 天赋技能
	local that = self
	local tb = nil 
	local list = {}
	for i = 0, self.char.modelTable._powerUp_skill.Count - 1 do 
		local skill = self.char.modelTable._powerUp_skill[i]
		local unlock = TableReader:TableRowByUniqueKey("unlock_skill", "powerUp_skill", i+1)
		local starStr = self.char:getStageStarByNum(unlock.unlock_arg, false)
		local name = ""	
		local desc = ""
		if self.char.stage >= unlock.unlock_arg then
			name = "[ff0000]【" .. skill.name.."】[-] "
			desc = "[ff0000]" .. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_850")..starStr..TextMap.GetValue("Text_1_851")
		else
			name = "[ffc864]【" .. skill.name.."】[-]"
			desc = "[ffc864]".. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_852")..starStr..TextMap.GetValue("Text_1_853")
		end 
		table.insert(list, {name = name, desc = desc})
	end 
	self.awke_tianfu:CallUpdate({ type = "other", list = list })
end

function hero_info:updateStarUpSkill()
	-- 天赋技能
	local that = self
	local list = {}
	for i = 0, self.char.modelTable._starup_skill.Count - 1 do 
		local skill = self.char.modelTable._starup_skill[i]
		local unlock = TableReader:TableRowByUniqueKey("unlock_skill", "starup_skill", i+1)
		local star = math.floor ( unlock.unlock_arg / 10 )
		local starLv = math.fmod(unlock.unlock_arg,10) - 1
		local name = ""	
		local desc = ""
		if self.char.star_level >= unlock.unlock_arg then 
			name = "[ff0000]【" .. skill.name.."】[-]"
			desc = "[ff0000]".. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_839")..(unlock.unlock_arg)..TextMap.GetValue("Text_1_854")
		else
			name = "[ffc864]【" .. skill.name.."】[-]"
			desc = "[ffc864]".. skill.desc_eff .. " " .. TextMap.GetValue("Text_1_841")..(unlock.unlock_arg)..TextMap.GetValue("Text_1_855")
		end 
		table.insert(list, {name = name, desc = desc})
	end 
	self.jinhua_tianfu:CallUpdate({ type = "other", list = list })
end

function hero_info:getMagics(magics)
    local txt = ""
    local len = magics.Count - 1
	local list = {}
    for i = 0, len do
        local row = magics[i]
        local magic_effect = row._magic_effect
        local magic_arg1 = row.magic_arg1
        -- local magic_arg2 = row.magic_arg2
        local desc = ""
        desc = string.gsub("[ffff96]" .. magic_effect.format .. "[-]", "{0}", magic_arg1 / magic_effect.denominator)
        if i < len then desc = desc .. "\n" end
        -- if math.floor(magic_arg1 / magic_effect.denominator) == 0 then desc =  "" end
        txt = txt .. desc
		list[i+1] = desc
    end
    return  txt, list
end


function hero_info:setHero(char)
	self.hero:LoadByModelId(char.modelid, "idle", function() end, false, 0, 1)
	self.txt_lv_name.text = char:getDisplayName()
    local tp = char:getType()
    local star = nil
    local piece = char

    if tp == "char" then
        star = char.star_level
        self.binding:Show("power_bg")
        self.binding:Hide("slider")
    else
        self.binding:Hide("power_bg")
        local info = piece:pieceInfo(star)
        self.slider.value = info.value
        self.binding:Show("slider")
        self.binding:Hide("btn_change")
    end
end

function hero_info:Start()
    ------------------------------------------------------------------- fix at 2015年5月6日 去掉星星------------------------------------------------------------------------------
    self.binding:Hide("star")
    self.binding:Hide("txt_lv")
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    self.btnType = 1
	self:adjust()
end

function hero_info:adjust()
	--self.con:SetActive(false)
	self.skill.gameObject:SetActive(false)
	self.fate.gameObject:SetActive(false)
	--self.binding:CallManyFrame(function()
	--	self.con:SetActive(true)
	--end)
	self.binding:CallManyFrame(function()
		self.skill.gameObject:SetActive(true)
	end, 2)	
	self.binding:CallManyFrame(function()
		self.fate.gameObject:SetActive(true)
	end, 3)		
end

function hero_info:updateHero()
	self:update(self.allChars[self.index])
end 

--获取所有的羁绊
--获取所有的羁绊
function hero_info:getAllFetter()
	local fetterList = {}
    local line = self.char.modelTable
    if line ~= nil then
        if line.relationship == nil then
            print("line.relationship is nil ")
        end
		local that = self 
        for i = 0, line.relationship.Count - 1 do
            if line.relationship[i] ~= nil and line.relationship[i].."" ~= "" then
                local tb = TableReader:TableRowByID("relationship", line.relationship[i])
                local fetterName = tb.show_name
				local ft = ""
				local ftdesc = ""
				local ret = that:checkFetter(tb.id)
				if  ret == true then 
					ft = "[ff0000]【" .. fetterName .. "】[-]"
					ftdesc = "[ff0000]" .. tb.desc_eff  .. " [-]" 
				else 
					ft = "[ffc864]【" .. fetterName .. "】[-]"
					ftdesc = "[ffc864]" .. tb.desc_eff  .. " [-]" 
				end 
				table.insert(fetterList, {name = ft, desc = ftdesc})
            end
        end
	end
	return fetterList
end

function hero_info:checkFetter(id)
    local list = self:getFetter(self.char.id) -- 获取该角色已经激活的羁绊列表
	local ret = false
    for i = 1, #list do
		local item = list[i]
        local line = TableReader:TableRowByID("relationship", item)
        if line == nil then
            line = TableReader:TableRowByUnique("relationship", item)
        end
		if line.id == id then return true end 
    end
	return false
end 

--获取某个角色已激活的羁绊id列表
function hero_info:getFetter(id)
    if id == nil then return end
    local fetters = Player.Chars[id].tie:getLuaTable()
    local tb = {}
    table.foreach(fetters, function(i, v)
        if v ~= nil then
            table.insert(tb, v)
        end
    end)
    return tb
end

return hero_info
