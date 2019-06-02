local m = {}

function m:update(lua)
    self.delegate = lua.delegate
	self.star = lua.star
	self:updateDes()
end

function m:updateDes()
	local str = ""
	if self.star == 1 then 
		str = m:getItemColorName(self.star, TextMap.GetValue("Text_1_805"))
	elseif self.star == 2 then 
		str = m:getItemColorName(self.star, TextMap.GetValue("Text_1_806"))
	elseif self.star == 3 then 
		str = m:getItemColorName(self.star, TextMap.GetValue("Text_1_807"))
	elseif self.star == 4 then 
		str = m:getItemColorName(self.star, TextMap.GetValue("Text_1_808"))
	elseif self.star == 5 then 
		str = m:getItemColorName(self.star, TextMap.GetValue("Text_1_809"))
	elseif self.star == 6 then 
		str = m:getItemColorName(self.star, TextMap.GetValue("Text_1_810"))
	end 
	self.txt_star.text = str
end 

function m:getItemColorName(color, names)
    local _names = names
	if color == 1 then
        _names = "[ffffff]" .. names .. "[-]"
    elseif color == 2 then
        _names = "[00ff00]" .. names .. "[-]"
    elseif color == 3 then
        _names = "[00b4ff]" .. names .. "[-]"
    elseif color == 4 then
        _names = "[ff00ff]" .. names .. "[-]"
    elseif color == 5 then
        _names = "[ff9600]" .. names .. "[-]"
    elseif color == 6 then
        _names = "[ff0000]" .. names .. "[-]"
    end
    return _names
end

function m:Start()
	self.select:SetActive(false)
	self.isSelect = false
end

function m:selected()
	self.isSelect = not self.isSelect
	if self.isSelect then 
		self.select:SetActive(true)
		self.delegate:onFilterCallback(self.star,true)
	else 
		self.select:SetActive(false)
		self.delegate:onFilterCallback(self.star,false)
	end 
end 

function m:onClick(go, name)
    if name == "btn_select" then
		m:selected()
	elseif name == "btn_ok" then 

    end
end

return m

