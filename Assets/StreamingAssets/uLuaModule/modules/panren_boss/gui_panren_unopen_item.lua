local m = {}

function m:update(data)
	if data ~= nil then 
		self.txt_name.text = Char:getItemColorName(data.quality, data.name)
		self.txt_gongji.text = toolFun.moneyNumberShowOne(math.floor(tonumber(data.gongxun))) .. TextMap.GetValue("Text_1_2942")
	else 
		self.txt_name.text =TextMap.GetValue("Text_1_2932")
   end
end

return m