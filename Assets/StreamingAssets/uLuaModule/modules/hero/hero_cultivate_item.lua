local m = {}

function m:update(data)
    --self.effect_node:SetActive(false)
    --self.txt_attr.text = data.name
	local data = data.data
    self.delegate = data.delegate
	if data == nil then return end 
	--print_t(data)
    self.txt_progress.text = data.cur .. "/" .. data.max
    local sub = data.max - data.cur
    local arg = data.next
    if arg ~= nil and sub > 0 and arg > sub then arg = sub end
    local num = arg or 0
	self.txt_top.gameObject:SetActive(false)
    if sub == 0 then
        self.txt_top.text = TextMap.GetValue("Text1129")
		self.txt_top.gameObject:SetActive(true)
        if self.delegate ~= nil then
            self.delegate:isHasFull()
        end
	end
    if num == 0 then
        num = "0"
		self.imgDown.gameObject:SetActive(false)
		self.imgAdd.gameObject:SetActive(false)
    elseif num > 0 then
        num = m:getNum(num)
		self.imgDown.gameObject:SetActive(false)
		self.imgAdd.gameObject:SetActive(true)
    elseif num < 0 then
        num = m:getNum(num)
		self.imgDown.gameObject:SetActive(true)
		self.imgAdd.gameObject:SetActive(false)
    end
    self.txt_add.text = num
    self.bar_progress.value = data.cur / data.max
    self.data = data
end

function m:getNum(num)
    if num > 0 then
        return "[00ff00]+ " .. num .. "[-]"
    else
        return "[ff0000]- " .. (-num) .. "[-]"
    end
end

function m:showEffect(arg)
    self.effect_node:SetActive(false)
    self.effect_node:SetActive(true)
    self.txt_num_after.transform.localScale = Vector3(0, 0, 0)
    local sub = self.data.max - self.data.cur
    if arg > sub then arg = sub end

    local num = arg
    if num == 0 then
        num = TextMap.GetValue("Text1129")
    elseif num > 0 then
        num = m:getNum(num)
    elseif num < 0 then
        num = m:getNum(num)
    end

    self.txt_num_after.text = num
    self.down:SetActive(arg < 0)
    self.up:SetActive(arg > 0)
    local go = self.txt_num_after.gameObject
    self.binding:CallAfterTime(0.3, function()
        self.binding:ScaleToGameObject(go, 0.2, Vector3(1, 1, 1))
    end)
end

return m

