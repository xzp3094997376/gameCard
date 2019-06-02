local m = {} 

function m:Start()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_3000"))
	LuaMain:ShowTopMenu(6,nil,{[1]={ type="yuhun"},[2]={ type="money"},[3]={ type="gold"}})
	local name = TableReader:TableRowByUnique("resourceDefine", "name","yuhun").cnName
	local resNum = Tool.getCountByType("yuhun")
	self.name1.text=name .. "：" .. toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	name = TableReader:TableRowByUnique("resourceDefine", "name","max_haogandu").cnName
	resNum = Tool.getCountByType("max_haogandu")
	self.name3.text=name .. "：" .. toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	if self.list ==nil then 
		self.list={}
		TableReader:ForEachTable("yulingshu_lvup",
	        function(index, item)
	            if item ~= nil then
	            	self.list[item.id]=item
	            	self.list[item.id].item={}
	            end
	            return false
	        end)
		TableReader:ForEachTable("yulingshu_magic_effect",
	        function(index, item)
	            if item ~= nil and self.list[item.level]~=nil then
	            	table.insert(self.list[item.level].item,item)
	            end
	            return false
	        end)
		self.itemIndex=1
	end 
	m:update()
end

function m:onClick(go, name)
	print(name)
    if name == "btn_see" then 
    	UIMrg:pushWindow("Prefabs/moduleFabs/yuling/yuling_yulingshu_yulan")
    elseif name == "btn_add" then 
    	UIMrg:pushWindow("Prefabs/moduleFabs/yuling/yuling_yulingshu_add")
    elseif name == "btn_toggle1" then 
    	if self.itemIndex~=1 then 
    		self.itemIndex=1
    		m:updateToggle()
    	end
    elseif name == "btn_toggle2" then 
    	if self.itemIndex~=2 then 
    		self.itemIndex=2
    		m:updateToggle()
    	end 
    elseif name == "btn_toggle3" then 
    	if self.itemIndex~=3 then 
    		self.itemIndex=3
    		m:updateToggle()
    	end 
    elseif name == "btn_toggle4" then 
    	if self.itemIndex~=4 then 
    		self.itemIndex=4
    		m:updateToggle()
    	end  
    elseif name=="btn_up" then 
    	local lv = Player.yuling.yulingshu.curLevel
    	local id = self.addMagic[self.itemIndex].id
    	local msg = {}
    	table.insert(msg,self.addMagic[self.itemIndex].msg)
    	self.btn_up.isEnabled=false
    	Api:yulingshuUp(lv,id,function ()
    		if Player.yuling.yulingshu.curLevel>lv then 
    			self.effect:SetActive(true)
    			OperateAlert.getInstance:showToGameObject(msg, UIMrg.top)
				self.binding:CallAfterTime(0.7, function()
					self.effect:SetActive(false)
					self.btn_up.isEnabled=true
					self.itemIndex=1
					m:update()
					end)
			else 
				OperateAlert.getInstance:showToGameObject(msg, UIMrg.top)
				self.btn_up.isEnabled=true
				m:updateToggle()
			end
    	end)
    end
end

function m:updateToggle()
	local lv = Player.yuling.yulingshu.curLevel or 1
	local totalCostNum=Player.Resource.haogandu
	local name = TableReader:TableRowByUnique("resourceDefine", "name","haogandu").cnName
	local resNum = Tool.getCountByType("haogandu")
	self.name2.text=name .. "：" .. toolFun.moneyNumberShowOne(math.floor(tonumber(resNum)))
	for i=1,4 do
		if i==self.itemIndex then 
			local id = self.list[lv].item[i].magic_effect
			local totalNum = self.list[lv].item[i].magic_arg1
			local num=Player.yuling.yulingshu[lv][id] or 0
			self["Slider" .. i].value=num/totalNum
			self["pro" .. i].text=num .. "/" .. totalNum
			local needCostNum = self.list[lv].item[i].consume[0].consume_arg
			if needCostNum<=totalCostNum then 
				self.btn_up.isEnabled=true 
			else 
				self.btn_up.isEnabled=false
			end
			self["Toggle" .. i].value=true 
			self.cosNum.text=TextMap.GetValue("LocalKey_4") .. needCostNum .. "/" .. totalCostNum
			if num>= totalNum then 
				self.btn_up.isEnabled=false
				if self.itemIndex<4 then 
					self.itemIndex=self.itemIndex+1
					m:updateToggle()
				end 
			end 
		else 
			self["Toggle" .. i].value=false
		end 
	end
end

function m:update()
	m:updateToggle()
	local lv = Player.yuling.yulingshu.curLevel
	self.name.text=self.list[lv].name
	if self.list[lv+1]~=nil then 
		self.des.gameObject:SetActive(true)
		self.des.text=TextMap.GetValue("Text_1_3022") .. self.list[lv+1].name
	else 
		self.des.gameObject:SetActive(false)
	end 
	self.addMagic = {}
	self.pic.spriteName=self.list[lv].icon
	for i=1,#self.list[lv].item do
		if self.list[lv].item[i]~= nil then 
			local format= self.list[lv].item[i]._magic_effect.format
			local tb = split(format,"：")
			self["text_name" .. i].text=tb[1]
			local id = self.list[lv].item[i].magic_effect
			local num=Player.yuling.yulingshu[lv][id] or 0
			local totalNum = self.list[lv].item[i].magic_arg1
			self["Slider" .. i].value=num/totalNum
			self["pro" .. i].text=num .. "/" .. totalNum
			local row = self.list[lv].item[i]
			local add = row.magic_arg2/row._magic_effect.denominator
			local add_magic = string.gsub("[ffff96]" .. row._magic_effect.format .. "[-]", "{0}", "[-][24FC24]+" .. add)
			local addItem = {}
			addItem.msg=add_magic
			addItem.id=row.magic_effect
			self.addMagic[i]=addItem
		end 
	end
end

return m