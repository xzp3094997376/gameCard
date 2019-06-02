
local m = {}


function m:update(skill)
	self.lua = skill
	self.type = skill.type
	if skill.type == "skill" then 
		m:updateSkill()
	elseif skill.type == "other" then 
		m:updateOther()
	end 
end

function m:updateOther()
	self.skill = self.lua.data
	self.txt_name.text = self.skill.name
	self.txt_des.text = self.skill.desc
	if self.bg ~= nil then
		self.bg.height = math.max(self.txt_des.height,self.txt_name.height) + 20
	end
end

function m:updateSkill()
	self.skill = self.lua.data
	if self.skill.customType == 4 then 
		self.txt_name.text = "[ffff96]【" .. self.skill.Table.show .. "】：[-]" .. self.skill.Table.desc
		self.img_icon.spriteName = m:getIcon(self.skill.customType - 1)
	else 
		self.txt_name.text = "[ffff96]【" .. self.skill.Table.show .. "】：[-]" .. self.skill.desc
		self.img_icon.spriteName = m:getIcon(self.skill.customType)
	end
end

function m:height()
	if self.type == "skill" then 
		return math.max(self.txt_des.height,self.txt_name.height)
	elseif self.type == "other" then 
		if self.bg==nil then 
			return math.max(self.txt_des.height,self.txt_name.height)
		else 
			return self.bg.height
		end 
	end 
end 

function m:getIcon(type)
	local str = ""
	if type == 1 then 	-- 普通攻击
		str = "jineng_pu"
	elseif type == 2 then -- 普通技能
		str = "jineng_ji"
	elseif type == 3 then -- 合体技	
		str = "jineng_he"
	end 
	return str
end 

function m:Start()

end


function m:onClick(go, name)
   
end

return m
