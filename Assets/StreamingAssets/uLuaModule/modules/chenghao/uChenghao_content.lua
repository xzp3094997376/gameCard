local m = {}

function m:update(tables)
	self.index = tables.index 
	self.delegate = tables.delegate
	for i = 1 , 5 do
		local tmp = {}
		tmp.tab = tables.tab
		tmp.delegate = tables.delegate
		tmp.index = tables.index
		tmp.i = i
		self["item"..i]:CallUpdateWithArgs(tmp)
	end
	self.dianliang:SetActive(false)
	local  curren = math.floor((Player.Info.ninjialvl) / 5) + 1
	if self.index == curren then
		self.dianliang:SetActive(true)
		self.mystarlvup = TableReader:TableRowByID("playerstarlvup", Player.Info.ninjialvl + 1)
		if self.mystarlvup == nil then
			return
		end
		self.txt_prop.text = self.mystarlvup.desc
		local type = self.mystarlvup.consume[i].consume_type
        local arg = self.mystarlvup.consume[i].consume_arg
        local arg2 = self.mystarlvup.consume[i].consume_arg2
        if type == "item" then
        	local item = uItem:new(arg)
        	local temname = item:getDisplayColorName()
        	local temcount = item.count
        	self.txt_desc.text = TextMap.GetValue("Text_1_225") .. " " ..temname.."：[ffff00]"..temcount.."/"..arg2
        else
        	self.txt_desc.text = TextMap.GetValue("Text_1_225") .. " " ..self.mystarlvup.consume[1].name.."：[ffff00]"..self.mystarlvup.consume[1].count
        end
		
	end
end

function m:onClick(go, name)
	if name == "dianliangbtn" then
		Api:charNinjiaLevelUP(function(reuslt)
				MessageMrg.showMove(self.mystarlvup.desc)
				m.delegate:resetCurrentIndex()
				print(reuslt)
				packTool:showMsg(reuslt, nil, 1)
			end)
	end
end

return m
