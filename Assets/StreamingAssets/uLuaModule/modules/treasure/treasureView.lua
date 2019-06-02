local m = {} 

function m:update(data)
	self.iteminfo = data.treasure
	self.typemode = data.typemode
	self:ActiveOrNot(self.typemode)
	if self.typemode == "strength" then
		self:ChooseStrength()
	elseif self.typemode == "jinglian" then
		self:ChooseJinglian()
	elseif self.typemode == "duanzao" then	
		self:ChooseDuanzao()
	end

	ClientTool.AddClick(self.btn_qianghua_down,function()
		self:RefreshView()
		self:ChooseStrength()
	end)
	ClientTool.AddClick(self.btn_jinglian_down,function()
		self:RefreshView()
		self:ChooseJinglian()
	end)
	--ClientTool.AddClick(self.btn_duanzao,function()
	--	self:RefreshView()
	--	self:ChooseDuanzao()
	--end)
	local config = TableReader:TableRowByID("treasureArgs","treasure_casting_open").arg
   	--self.btn_duanzao.gameObject:SetActive(config == 1)
	--self.BlockButton:Reposition()
	m:updateRedPoint()
end

function m:ChooseStrength()
	self:ActiveOrNot("strength")
	self.StrengthMode:CallUpdate(self.iteminfo)
end

function m:ChooseJinglian()
	self:ActiveOrNot("jinglian")
	self.JinglianMode:CallUpdate(self.iteminfo)
end

function m:ChooseDuanzao()
	if self.iteminfo.star ~= 5 then
		MessageMrg.show(TextMap.GetValue("Text_1_2807"))
		return
	end
	self:ActiveOrNot("duanzao")
	local datats = {}
	datats.treasure = self.iteminfo
	datats.delegate = self
	self.DuanzaoMode:CallUpdate(datats)
end

function m:onClick(go, name)
	if name == "btnBack" then 
		UIMrg:pop()
	end 
end

function m:ActiveOrNot(_type)
	self.StrengthMode.gameObject:SetActive(_type == "strength")
	self.JinglianMode.gameObject:SetActive(_type == "jinglian")
	self.DuanzaoMode.gameObject:SetActive(_type == "duanzao")
	self.imgQianghuaUp:SetActive(_type == "strength")
	self.imgJinglianUp:SetActive(_type == "jinglian")
	--self.duanzao_obj:SetActive(_type == "duanzao")
end

function m:onEnter()
	LuaMain:ShowTopMenu()
end

function m:Start()
	LuaMain:ShowTopMenu()
	Tool.loadTopTitle(self.gameObject, TextMap.GetValue("Text_1_774"))
end

function m:updateRedPoint()
	--self.redPoint_qh:SetActive(self.iteminfo:redPointQianHua())
	--self.redPoint_jl:SetActive(self.iteminfo:redPointJingLian())
end

function m:RefreshView()
	local info = Player.Treasure[self.iteminfo.key]
	local new_data = Treasure:new(self.iteminfo.id,self.iteminfo.key)
	self.iteminfo = new_data
end

return m