local m = {} 
--第五类型兑换UI的脚本弹出框

function m:update(data)
	self.data = data[1]
	self.taksId = data[4]
	self.actType = data[5]
	self.delegate = data[6]
    self.numberSelect.selectNum = 1
    self.numberSelect:maxNumValue(data[2])
	local gridList = {}
    self.Grid:refresh(Item, data[3])
	self.Sprite_con:CallUpdate(self.data.drop[0])
	--self.Label_targetName.text = self.data.drop[0]
end

function m:onClick(go,name)
	if name == "Btn_Dui" then
		Api:subDay14(self.actType, self.taksId, self.numberSelect.selectNum, function(result)
			--packTool:showMsg(result, nil, 2)
			Events.Brocast("UpdateRedPoint")
			self.gameObject:SetActive(false)
			self.delegate:TypeChoiseCb()
			self.delegate:showMsg(result)
		end, function() end)
	elseif name == "Btn_cancle" or name == "Btn_close" then
		self.gameObject:SetActive(false)
	elseif name == "" then

	elseif name == "" then

	end
end

return m