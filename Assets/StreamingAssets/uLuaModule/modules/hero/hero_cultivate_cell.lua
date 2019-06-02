
local m = {}

function m:update(data)
    self._data = data
    self.index = data.index
    self.delegate = data.delegate
    local atlasName = packTool:getIconByName(data.cur.icon)
    self.img_icon1:setImage(data.cur.icon, atlasName)
    if data.cur.type == data.next.type then
        self.txt_value1.text = (data.cur.num + data.next.num)
        self.binding:Hide("img_icon2")
        self.binding:Hide("txt_value2")
        self.binding:Hide("add")
    else
        self.binding:Show("img_icon2")
        self.binding:Show("txt_value2")
		self.binding:Show("add")
        atlasName = packTool:getIconByName(data.next.icon)
        self.img_icon2:setImage(data.next.icon, atlasName)
        self.txt_value2.text = data.next.num
        self.txt_value1.text = data.cur.num
    end
    self.txt_title.text = data.type
    if data.times ~= nil then
        self:SelectNum(data.times)
    end
	
	if self.delegate and self.delegate.selectType == self.index then 
		self.select1:SetActive(true)
	else	
		self.select1:SetActive(false)
	end 
end

function m:onClick()
    self.delegate:selectTypeFun(self.index)
end

function m:SelectNum(_times)
    if self._data.cur.type == self._data.next.type then
        self.txt_value1.text = (self._data.cur.num + self._data.next.num)*_times
    else
        self.txt_value2.text = self._data.next.num * _times
        self.txt_value1.text = self._data.cur.num * _times
    end
end

return m

