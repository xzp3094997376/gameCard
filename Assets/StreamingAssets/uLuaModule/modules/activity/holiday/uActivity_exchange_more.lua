local m = {} 
--第五类型兑换UI的脚本弹出框

function m:update(data)
	self.data=data
	self.delegate = data[5]
    self.numberSelect.selectNum = 1
    self.numberSelect:maxNumValue(data[2])
    self.Grid:refresh(Item, data[3])
	self.Sprite_con:CallUpdate(data[1])
	self.numberSelect:setCallFun(m.setMoneyChange, self)
end
function m:setMoneyChange()
	local num = tonumber(self.selectNum.text)
	local consumeList = {}
	for i,v in ipairs(self.data[3]) do
		if v.item.type == "char" then
            local vo = v
            vo.rwCount = v.item.arg2*num
            table.insert(consumeList, vo)
        elseif Tool.typeId(v.item.type) then 
            local vo = itemvo:new(v.item.type, v.item.arg2, v.item.arg*num)
            vo.item=v.item
            vo.__tp = "vo"
            table.insert(consumeList, vo)
        else
            local vo = itemvo:new(v.item.type, v.item.arg2*num, v.item.arg)
            vo.item=v.item
            vo.__tp = "vo"
            table.insert(consumeList, vo)
        end
	end
	self.Grid:refresh(Item, consumeList)
	local drop = {}
	drop.type=self.data[1].type
	drop.arg=self.data[1].arg
	drop.arg2=self.data[1].arg2
	if Tool.typeId(self.data[1].type) then
		drop.arg=self.data[1].arg*num
	else
        drop.arg2=self.data[1].arg2*num 
    end
    self.Sprite_con:CallUpdate(drop)
end

function m:onClick(go,name)
	if name == "Btn_Dui" then
		local gid= self.data[4] .. "_" .. self.selectNum.text
		Api:getActGift(self.delegate.data.id, gid, function(result)
	        if result.drop ~= nil then
	            packTool:showMsg(result, nil, 1)
	        end
	        self.delegate:refreshActivityData()
	        self.gameObject:SetActive(false)
	        end)
	elseif name == "Btn_cancle" or name == "Btn_close" then
		self.gameObject:SetActive(false)
	elseif name == "" then

	elseif name == "" then

	end
end

return m