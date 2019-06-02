local m = {} 
local REFRESH_TIMER = 0
local index_zi=0
local index_row=1
local list={}
local ztime =0
local rtiem =0
local text = ""
local _text = ""
local isOver = false

function m:update(data)
	list=data[1]
	ztime=data[2]
	rtiem=data[3]
	self.tp=data[4]
	_text=""
	for i=1,#list do
		if i==1 then 
			_text=_text .. list[i]
		else 
			_text=_text .. "\n" .. list[i]
		end 
	end
	if self.tp=="guide" then 
		self.bg:SetActive(true)
		self.chapter:SetActive(false)
		--self.txt1.text=string.sub(list[index_row],1,index_zi)
		self.txt1.text=_text
		self.txt1.gameObject:SetActive(true)
		--m:updateText()
		self:updateOver()
	elseif self.tp=="chapter" then 
		self.step=data[5]
		self.cb=data[7]
		self.name.text=data[6]
		self.bg:SetActive(false)
		self.chapter:SetActive(true)
		self.next.text=TextMap.GetValue("Text_1_303")
		LuaTimer.Add(1000, function()
			self.textBg.gameObject:SetActive(true)
			if #list>4 then 
				self.textBg.height=300+(#list-4)*48
			end 
			self.txt1.text=_text
			self.txt1.gameObject:SetActive(true)
			self:updateOver()
			--self.txt1.text=string.sub(list[index_row],1,index_zi)
			--m:updateText() 
			self:updateOver()
			end)		
	end 
end

function m:updateOver()
	local totalTime = 0
	local num_words = 0
	for i=1,#list do
		num_words=num_words+string.len(list[i])
	end
	totalTime=totalTime+num_words*20
	totalTime=totalTime
	if totalTime<1 then 
		totalTime=1
	end 
	self.binding:CallAfterTime(totalTime/1000,function()
		if self.tp=="chapter" then 
			self.ani:SetActive(true)
			local item =uItem:new(43)
			self.icon.Url=item:getHead()
			self.des.text=TextMap.GetValue("Text_1_304") .. item.name .."X1"
			self.icon.gameObject:SetActive(true)
			self.binding:CallAfterTime(0.5,function()
				self.Next.gameObject:SetActive(true)
				self.des.gameObject:SetActive(true)
				end) 
		else 
			self.Next.gameObject:SetActive(true)
		end 
	end)
end

function m:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function m:onClick(go, name)
	if name =="Next" then 
		if self.tp=="guide" then 
			GuideMrg.CallNextStep()
			SendBatching.DestroyGameOject(self.binding.gameObject)
		elseif self.tp=="chapter" then 
			GuideMrg.Stop()
			Api:setGuide(self.step, 2, function() end)
			if self.cb then self.cb() end
			SendBatching.DestroyGameOject(self.binding.gameObject)
		end 
	end
end

--关闭
function m:OnDestroy()
    LuaTimer.Delete(REFRESH_TIMER)
end
function m:updateText()
	LuaTimer.Delete(REFRESH_TIMER)
	local  that = self
    REFRESH_TIMER = LuaTimer.Add(0, ztime, function(id)
		if list[index_row]~=nil and index_zi<=string.len(list[index_row]) then 
			if index_zi ==0 and index_row ~=1 then 
				text=text .. list[index_row-1] .. "\n"
			end
			index_zi=index_zi+1
			if self.txt1~=nil then 
				self.txt1.text =text .. string.sub(list[index_row],1,index_zi)
			end
		else 
			LuaTimer.Delete(REFRESH_TIMER)
			index_zi=0
			index_row=index_row+1
			if index_row<=#list then 
				LuaTimer.Add(rtiem, function()
					that:updateText()
					end)
			else 
				isOver=true
			end
		end 
		end)
end

return m