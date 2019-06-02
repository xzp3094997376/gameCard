
-- 英雄升级
local m = {}

function m:update(lua)
	self.row = lua
    self:onUpdate()
end

function m:onUpdate()
	local items = {}
	local desc = ""
	local zhi =""
	local ming = ""
	for i = 0, self.row.teamMagic.Count do 
		local item = self.row.teamMagic[i]
		if item ~= nil then 
			table.insert(items, item)
			local magic_effect = item._magic_effect
			local magic_arg1 = item.magic_arg1
			local arg1 = magic_arg1 / magic_effect.denominator
			if self.row.isGreen~=nil and self.row.isGreen==true then 
				local tb=split(magic_effect.format, "{0}")
				if tb[2]~=nil then 
					ming = "[ffff96]"..tb[1].."[-]"
					zhi="[24FC24]+" .. arg1 .. tb[2] .."[-]"
					ming = ming .. zhi
				else 
					ming="[ffff96]"..tb[1].."[-]"
					zhi="[24FC24]+" .. arg1 .."[-]"
					ming = ming .. zhi
				end 
			else 
				local tb=split(magic_effect.format, "{0}")
				if tb[2]~=nil then 
					ming = "[ffff96]"..tb[1].."[-]"
					zhi= "+" .. arg1 .. tb[2] .."[-]"
					ming = ming .. zhi
				else 
					ming ="[ffff96]"..tb[1].."[-]"
					zhi = "+" .. arg1 .."[-]"
					ming = ming .. zhi
				end 
			end 
			if item.position==0 then 
				desc = desc .. TextMap.GetValue("Text_1_967") .. (item.position + 1) .. "[-]  " .. ming .. "\n"
			else 
				desc = desc .. TextMap.GetValue("Text_1_967") .. (item.position + 1) .. "[-] " .. ming .. "\n"
			end 
		end
	end
	local allproperty = ""
	if self.row.desc == nil or self.row.desc == "" then 
		if self.row.isGreen~=nil and self.row.isGreen==true then 
			allproperty = TextMap.GetValue("Text_1_968")
			zhi="[24FC24]+0%[-]"
			allproperty = allproperty .. zhi
		else 
			allproperty = TextMap.GetValue("Text_1_968")
			zhi= "[ffffff]+0%[-]"
			allproperty = allproperty .. zhi
		end 
	else 
		if self.row.isGreen~=nil and self.row.isGreen==true then 
			local tb=split(self.row.desc, "+")
			allproperty = tb[1]
			zhi="[24FC24]+" .. tb[2] .."[-]"
			allproperty = allproperty .. zhi
		else 
			local tb=split(self.row.desc, "+")
			allproperty = tb[1]
			zhi="+" .. tb[2] .."[-]"
			allproperty = allproperty .. zhi
		end 
	end 
	desc = desc .. "[ffff96]" .. allproperty .. "[-]"
	self.txt_demage.text = desc
	--self.txt_demage1.text = zhi
	self.txt_demage1.text = ""
	for i = 1, 6 do 
		self["pos"..i].color = Color(0.5, 0.5, 0.5)
		for j = 1, #items do 
			if i == (items[j].position + 1) then 
				self["pos"..i].color = Color(1, 1, 1)
				break
			end 
		end 
	end 
end

function m:getMagics(magics)
    local txt = ""
    local len = magics.Count - 1
	local list = {}
	local nList = {}
    for i = 0, len do
        local row = magics[i]
        local magic_effect = row._magic_effect
        local magic_arg1 = row.magic_arg1
        -- local magic_arg2 = row.magic_arg2
        local desc = ""
		local arg1 = magic_arg1 / magic_effect.denominator
        desc = string.gsub(magic_effect.format, "{0}", arg1)
        if i < len then desc = desc .. "\n" end
        -- if math.floor(magic_arg1 / magic_effect.denominator) == 0 then desc =  "" end
        txt = txt .. desc
		list[i+1] = desc
		nList[i+1] = arg1
    end
    return  txt, list, nList
end

function m:Start()

end


return m

