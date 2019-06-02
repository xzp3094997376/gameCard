local m = {}

local str = {TextMap.GetValue("Text_1_2926"), TextMap.GetValue("Text_1_2927"), TextMap.GetValue("Text_1_2928")}

function m:Start()
	self.dmgRate = tonumber(TableReader:TableRowByID("taorenBossSetting", 5).arg1) / 1000
end

function m:update(data)
	self.id = data.id
	self.txt_desc.text = str[data.id] .. TextMap.GetValue("Text_1_2929") .. self.dmgRate .. TextMap.GetValue("Text_1_2930")
end 

-- 1善 2恶 3影
function m:onClick(go, name)
	if name == "btn_button" then 
		--string.gsub(TextMap.GetValue("LocalKey_594"), "{0}")
		local s1 = string.gsub(TextMap.GetValue("LocalKey_594"), "{0}", str[self.id])
		local s2 = string.gsub(s1, "{1}", str[self.id])
		local s3 = string.gsub(s2, "{2}", self.dmgRate)
		DialogMrg.ShowDialog(s3, function()
			Api:chooseCamp(self.id, function(ret)
				UIMrg:popWindow()
			end, function()

			end)
       end)
	end 
end

return m