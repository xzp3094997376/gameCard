local m = {} 

function m:Start()
	self.active_btn.isEnabled=false
	local chartNum = Tool.getCountByType("renlingzhi")
	self.chartNum.text=TextMap.GetValue("Text_1_2982") .. chartNum
	m:updateChengjiu()
	self.target.onFinished=function ()
		local obj = self.target.centeredObject
		if obj ~=nil then 
			local index=tonumber(string.sub(obj.name,5,-1))
			self.numbg:SetActive(true)
			self.num.text=TextMap.GetValue("Text_1_2983") .. self.chengjiuList[index+1].renlingzhi .. TextMap.GetValue("Text_1_2984")
			local magic = self.chengjiuList[index+1].magic[0]
			local tb =split(magic._magic_effect.format, "{0}")
			local denominator=magic._magic_effect.denominator/magic._magic_effect.denominator
			tb[2]=tb[2] or ""
			self.shuxing.text="[ffff96]" .. tb[1] .. "[-][ffffff]" .. denominator .. tb[2] .. "[-]"
			self.msglist={}
			table.insert(self.msglist, self.shuxing.text )
			self.currentId=self.chengjiuList[index+1].id
			if self.chengjiuList[index+1].isShow==1 then
				self.active_btn.isEnabled=true
				self.btn_name.text=TextMap.GetValue("LocalKey_242")
			elseif self.chengjiuList[index+1].isShow==2 then 
				self.active_btn.isEnabled=false
				self.btn_name.text=TextMap.GetValue("Text_1_2989")
			else
				self.active_btn.isEnabled=false
				self.btn_name.text=TextMap.GetValue("LocalKey_242")
			end 
		end 
	end 
	self.view.onDragStarted=function ()
		self.numbg:SetActive(false)
	end
end

function m:updateChengjiu()
	local chartNum = Tool.getCountByType("renlingzhi")
	self.chengjiuList = {}
	local relIndex = 0
	local activeId = Player.renling.chengjiuPos -- 激活id
	TableReader:ForEachLuaTable("renling_chengjiu", function(index, item) --shopPurchase
		if tonumber(item.id) <= tonumber(activeId) then 
			item.isShow=2
		elseif tonumber(item.renlingzhi)<=chartNum and tonumber(item.id)==activeId+1 then 
			item.isShow=1
		else 
			item.isShow=0
		end 
		relIndex=relIndex+1
		item.relIndex=relIndex
		item.delegate=self
		table.insert(self.chengjiuList,item)
		return false
		end)
	for i=1,#self.chengjiuList do
		if i==#self.chengjiuList then 
			self.chengjiuList[i].isShowLine=0
		elseif self.chengjiuList[i+1].isShow==2 then 
			self.chengjiuList[i].isShowLine=2
		else 
			self.chengjiuList[i].isShowLine=1
		end 
	end
	self.targetIndex=m:getTargetIndex()
	self.numbg:SetActive(false)
	ClientTool.UpdateGrid("", self.grid, self.chengjiuList)
end

function m:moveToTarget(go)
	print(go.name)
	self.target:CenterOn(go)
end

function m:updateShuxing()
	self.add_shuxing:SetActive(true)
	local magicList = {}
	local propertys = Player.renling.chengjiuPro
	TableReader:ForEachLuaTable("magics", function(index, item)
		if propertys[item.id]~=nil and propertys[item.id]>0 then 
			local tb =split(item.format, "{0}")
			local magicItem = {}
			magicItem.tb1=tb[1]
			magicItem.tb2=tb[2] or ""
			magicItem.denominator=item.denominator
			magicItem.arg=tonumber(propertys[item.id])
			table.insert(magicList,magicItem)
		end 
		return false
		end)
	for i=1,#magicList do
		if self["des".. i]==nil then
			local go = NGUITools.AddChild(self.bg.gameObject, self["des".. ((i-1)%2+1)].gameObject)
			go.transform.localPosition = Vector3(self["des".. ((i-1)%2+1)].transform.localPosition.x, -21-30*(math.floor((i-1)/2)), 0)
			self["des".. i]=go:GetComponent(UILabel)
		end
		self["des".. i].text="[F0E77B]" .. magicList[i].tb1 .. "[ffffff] " .. magicList[i].arg/tonumber(magicList[i].denominator or 1) .. magicList[i].tb2 .. "[-]"
	end
	for i=#magicList+1,2 do
		self["des".. i].text=""
	end
	if #magicList>6 then 
		self.bg.hight=100+30*(math.ceil(#magicList/2)-3)
	end 
end

function m:getTargetIndex( ... )
	for i=1,#self.chengjiuList do
		if self.chengjiuList[i].isShow<=1 then 
			return self.chengjiuList[i].relIndex
		end 
	end 
	return self.chengjiuList[#self.chengjiuList].relIndex
end

function m:onClick(go, name)
	if name == "btnClose" or name == "closeBtn" or name == "btn_quxiao" then
		UIMrg:popWindow()
	elseif name=="addition_btn" then 
		self:updateShuxing()
	elseif name=="closeBtn_shuxing" then 
		self.add_shuxing:SetActive(false)
	elseif name == "active_btn" then
		Api:activatedAchievement(self.currentId,function ()
			OperateAlert.getInstance:showToGameObject(self.msglist, UIMrg.top) 
			m:updateChengjiu()
		end)   
	end 
end 

return m