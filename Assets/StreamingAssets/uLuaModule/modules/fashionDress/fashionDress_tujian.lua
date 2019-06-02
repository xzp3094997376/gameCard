local m = {} 

function m:update(lua)
	self.delegate=lua.delegate
	self.fashionList={}
	self.fashionList=self:GetAllfashion()
	--ClientTool.UpdateGrid("Prefabs/moduleFabs/fashionDress/item_cell", self.Content, self.fashionList, self)
	self.bindings = {}
	self.content:Reset(1, #self.fashionList, #self.fashionList)
	for i = 1, #self.fashionList do
		local binding = self.content.items[i - 1]:GetComponent(UluaBinding)
		if binding ~= nil then 
			self.bindings[i] = binding
			self.bindings[i]:CallUpdate({index = i, data = self.fashionList[i], delegate = self})
		end
	end
	self.binding:CallManyFrame(function()
		m:getSetChildsHeight()
	end, 1)
	
	--self.scrollview:refresh(self.fashionList, self, false, 0)
	self:updateProperty()
end

function m:getSetChildsHeight()
	local width = 0
	if self.bindings ~= nil then 
		for i = 1, #self.bindings do 
			local h = self.bindings[i].target:width()
			width = width + h
			if i < #self.bindings then 
				self.content.items[i].transform.localPosition = Vector3(width + (self.content.spacing.x), self.content.items[i].transform.localPosition.y, 0)
				width = width + self.content.spacing.x
			end 
		end 
	end 
end

function m:GetAllfashion()
	local list = {}
	TableReader:ForEachTable("fashion_suit",
        function(index, item)
            if item ~= nil then
            	local cell = {}
            	cell.item=item
            	cell.fashions={}
            	local fashions = item.fashions 
            	cell.active=true 
            	cell.hasNum=2
            	for i=0, fashions.Count-1 do 
            		if fashions[i]>0 then 
            			local onefashion = Fashion:new(fashions[i])
            			onefashion.delegate=self
            			if Player.fashion[fashions[i]] ==nil or Player.fashion[fashions[i]].powerlvl <=0 then 
            				cell.active=false
            				cell.hasNum=cell.hasNum-1
            			end 
            			table.insert(cell.fashions,onefashion)
            		end 
            	end 
            	table.insert(list,cell)
            end
            return false
        end)
	table.sort( list, function (a,b)
		if a.hasNum ~= b.hasNum then
            return a.hasNum>b.hasNum 
		elseif math.min(a.fashions[1].star,a.fashions[2].star) ~= math.min(b.fashions[1].star,b.fashions[2].star) then 
			return math.min(a.fashions[1].star,a.fashions[2].star)<math.min(b.fashions[1].star,b.fashions[2].star)
		else 
			return a.item.id <b.item.id 
		end 
	end )
	return list
end

function m:getScrollView()
	return self.view
end

local isup = false

function m:onClick(go, name)
    if name == "btn_gengduo" then 
		if isup==true then 
			if self.ani==nil then return end 
			isup=false
			self.ani.enabled=true
			self.ani:ResetToBeginning()
			self.ani.from=self.toPos
			self.ani.to=Vector3(42,110,0)
			self.tubiao.transform.localEulerAngles=Vector3(0,0,180)
		else 
			if self.ani==nil then return end 
			isup=true
			self.ani.enabled=true
			self.ani:ResetToBeginning()
			self.ani.from=Vector3(42,110,0)
			self.ani.to=self.toPos
			self.tubiao.transform.localEulerAngles=Vector3(0,0,0)
		end 
    end
end


function m:updateProperty()
	if self.fashionList==nil then return end
	local magic = {}
	for i=1,#self.fashionList do 
		if self.fashionList[i].active==true then
			local _addexpmagic = self.fashionList[i].item.magic
			for j=0,_addexpmagic.Count-1 do
				local tb =split(_addexpmagic[j]._magic_effect.format, "{0}")
				local magicItem = {}
				magicItem.tb1=tb[1]
				magicItem.tb2=tb[2]
				magicItem.denominator=_addexpmagic[j]._magic_effect.denominator
				magicItem.arg=_addexpmagic[j].magic_arg1
				if magic[_addexpmagic[j].magic_effect]==nil then 
					magic[_addexpmagic[j].magic_effect]=magicItem
				else 
					local arg = magic[_addexpmagic[j].magic_effect].arg
					magic[_addexpmagic[j].magic_effect].arg=_addexpmagic[j].magic_arg1+arg
				end 
			end
		end
	end
	local list = {}
	for i,v in pairs(magic) do
		table.insert(list,v)
	end
	magic=list
	if #magic == 0 then 
		for i=1,4 do
			self["baselabel".. i].text=""
		end
		self.desLabel:SetActive(true)
		for i=1,8 do
			self["baselabel".. i].text=""
		end
		--self.btn_gengduo.gameObject:SetActive(false)
	else
		magic=Tool.SortMagicList(magic)
		if #magic<=8 then 
			for i=1,#magic do
				if magic[i].tb2~=nil then 
					self["baselabel".. i].text="[F0E77B]" .. magic[i].tb1 .. "[24FC24] " .. magic[i].arg/tonumber(magic[i].denominator or 1) ..magic[i].tb2 .."[-]"
				else 
					self["baselabel".. i].text="[F0E77B]" .. magic[i].tb1 .. "[24FC24] " .. magic[i].arg/tonumber(magic[i].denominator or 1) .. "[-]"
				end 
			end
			for i=#magic+1,8 do
				self["baselabel".. i].text=""
			end
			--self.btn_gengduo.gameObject:SetActive(false)
		else 
			--self.btn_gengduo.gameObject:SetActive(true)
			for i=1,#magic do
				local text="[F0E77B]" .. magic[i]._magic_effect.format .. "[-]"
				if self["baselabel".. i]==nil then
					local go = NGUITools.AddChild(self.des, self["baselabel".. ((i-1)%4)+1].gameObject)
					go.transform.localPosition = Vector3(self["baselabel".. ((i-1)%4)+1].transform.localPosition.x, -38*(math.floor(i/4)+1), 0)
					self["baselabel".. i]=go:GetComponent(UILabel)
				end 
				if magic[i].tb2~=nil then 
					self["baselabel".. i].text="[F0E77B]" .. magic[i].tb1 .. "[24FC24] " .. magic[i].arg/tonumber(magic[i].denominator or 1) ..magic[i].tb2 .."[-]"
				else 
					self["baselabel".. i].text="[F0E77B]" .. magic[i].tb1 .. "[24FC24] " .. magic[i].arg/tonumber(magic[i].denominator or 1) .. "[-]"
				end 
			end	
		end 
		self.toPos=Vector3(42,110+(math.floor(#magic-4)+1)*50,0)
		self.desLabel:SetActive(false)
	end
	magic=nil
end


return m