local m = {} 

function m:update(lua)
	if lua~=nil then 
		print(lua.type)
		self.type=lua.type
		self.delegate=lua.delegate
		self.data=lua.data
		if self.tp ==nil or self.tp==0 then 
			self.tp=1
		end 
		self.list=self:SortOneParty(self.data) 
		for i=1,#self.list do
			self["group" .. i].gameObject:SetActive(true)
			self["group" .. i]:CallUpdate(self.list[i],i-1,self)
			if self.delegate.type==self.type and self.delegate.tp == i then 
				self["group" .. i].gameObject:SetActive(true)
			else 
				self["group" .. i].gameObject:SetActive(false)
			end
		end
	else
		print (self.delegate.type)
		print (self.delegate.tp)
		for i=1,#self.list do
			if self.delegate.type==self.type and self.delegate.tp == i then 
				self["group" .. i].gameObject:SetActive(true)
			else 
				self["group" .. i].gameObject:SetActive(false)
			end
		end
	end 
end

function m:SortOneParty(list)
	local charList={}
	local oneStar={}
	local twoStar={}
	local threeStar={}
	local fourStar={}
	local fiveStar={}
	local sixStar={}
	for i=1,#list do
		local char = Char:new(nil,list[i].id)
		if char.star==1 then 
			table.insert(oneStar, char)
		elseif char.star==2 then 
			table.insert(twoStar, char)
		elseif char.star==3 then 
			table.insert(threeStar, char)
		elseif char.star==4 then 
			table.insert(fourStar, char)
		elseif char.star==5 then 
			table.insert(fiveStar, char)
		elseif char.star==6 then 
			table.insert(sixStar, char)
		end 
	end
	local cell = {}
	if #sixStar>0 then 
		cell={}
		cell.char=sixStar
		cell.type=6
		table.insert(charList, cell)
	end
	if #fiveStar>0 then 
		cell={}
		cell.char=fiveStar
		cell.type=5
		table.insert(charList, cell)
	end
	if #fourStar>0 then 
		cell={}
		cell.char=fourStar
		cell.type=4
		table.insert(charList, cell)
	end
	if #threeStar>0 then 
		cell={}
		cell.char=threeStar
		cell.type=3
		table.insert(charList, cell)
	end
	if #twoStar>0 then 
		cell={}
		cell.char=twoStar
		cell.type=2
		table.insert(charList, cell)
	end
	if #oneStar>0 then 
		cell={}
		cell.char=oneStar
		cell.type=1
		table.insert(charList, cell)
	end
	return charList
end

return m