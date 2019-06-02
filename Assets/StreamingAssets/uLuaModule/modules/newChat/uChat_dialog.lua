local m = {} 

function m:Start( ... )
	chatMrg.HideChatBtn()
	self.imgList={}
	self.imgList[1]={}
	self.imgList[1].img=self.img_shijie
	self.imgList[1].tab="A"
	self.imgList[2]={}
	self.imgList[2].img=self.img_xueyuan
	self.imgList[2].tab="G"
	self.imgList[3]={}
	self.imgList[3].img=self.img_miyu
	self.imgList[3].tab="P"
	Events.AddListener("creatOneChat", function ()
		if self.tp ~=nil then 
			m:update({self.tp})
		end 
	end)
	Events.AddListener("changeSureBtn", function ()
		local isEnabled = chatMrg.isEnabled[self.imgList[self.tp].tab]
		if isEnabled==nil or isEnabled==true then 
			self.sure.isEnabled=true
		end 
	end) 
end

function m:OnDestroy()
	Events.RemoveListener("creatOneChat")
    Events.RemoveListener('changeSureBtn')
end

function m:update(data)
	self.tp=data[1]
	for i=1,3 do
		if i==self.tp then 
			self.imgList[i].img:SetActive(true)
		else 
			self.imgList[i].img:SetActive(false)
		end 
	end
	local isEnabled = chatMrg.isEnabled[self.imgList[self.tp].tab]
	if isEnabled==nil or isEnabled==true then  
		self.sure.isEnabled=true
	else 
		self.sure.isEnabled=false
	end
	self.row = TableReader:TableRowByID("ChatConfig",self.imgList[self.tp].tab) 
	if self.tp==3 then 
		self.Sprite_input:SetActive(false)
		self.Sprite_input2:SetActive(true)
		self.content2.text=string.gsub(TextMap.GetValue("LocalKey_862"),"{0}",self.row.word_limit)
		self.input_content.characterLimit=self.row.word_limit
		if data[2]~=nil then 
			self.input_name.value=data[2]
		end
	else
		self.Sprite_input:SetActive(true)
		self.Sprite_input2:SetActive(false)
		self.content.text=string.gsub(TextMap.GetValue("LocalKey_862"),"{0}",self.row.word_limit)
		self.input.characterLimit=self.row.word_limit
		local miyu = chatMrg.getChatList(3)
		if miyu~=nil and #miyu>0 then 
			for k,v in pairs(miyu) do
				if v.isNew==true then 
					self.red_point:SetActive(true)
					if chatMrg.bind~=nil then 
						chatMrg.bind:CallTargetFunctionWithLuaTable("ShowRed")
					end
				end 
			end
		end 
	end 
	local list = chatMrg.getChatList(self.tp)
	if list~=nil and #list>0 then 
		for k,v in pairs(list) do
			v.delegate=self
			if self.tp==3 and v.isNew==true then 
				v.isNew=false
				self.red_point:SetActive(false)
				if chatMrg.bind~=nil then 
					chatMrg.bind:CallTargetFunctionWithLuaTable("HideRed")
				end
			end 
		end
		self.scrollView:refresh(list, self, false,0)
		if #list>3 then 
			self.binding:CallAfterTime(0.1,function()
		        self.scrollView:goToIndex(#list-1)
		    end)
		end 
	else 
		self.scrollView:refresh({}, self, false,0)
	end 
end

function m:setInputName( str )
	if self.tp == 3 then 
		self.input_name.value=str
	end 
end

--点击事件
function m:onClick(uiButton, eventName)
	print(eventName)
	if eventName == "btnClose" then 
		chatMrg.ShowChatBtn()
		UIMrg:popWindow()
	elseif eventName=="btn_xueyuan"then
		self:update({2})
	elseif eventName=="btn_miyu" then 
		self:update({3})
	elseif eventName=="btn_shijie" then 
		self:update({1})
	elseif eventName == "sure" then  
		if self.tp==3 then 
			if self.input_name.value=="" then 
				MessageMrg.show(TextMap.GetValue("LocalKey_865"))
				return 
			elseif self.input_content.value=="" then 
				MessageMrg.show(TextMap.GetValue("LocalKey_866"))
				return 
			end 
		else 
			if self.input.value=="" then 
				MessageMrg.show(TextMap.GetValue("LocalKey_866"))
				return 
			end 
		end 
		local isSend =self:CheckConsume(self.row.consume)
		if isSend then 
			isSend=self:CheckUnlock(self.row.unlock)
			if isSend then 
				if self.tp~=3 then 
					self.sure.isEnabled=false
					Api:send(self.imgList[self.tp].tab,self.input.value,"",function ()
						self.sure.isEnabled=false
						chatMrg.cdTime(self.imgList[self.tp].tab)
					end,function ()
						self.sure.isEnabled=true
					end)
				else 
					local limit = TableReader:TableRowByID("Chatsetting",1).arg1
					if tonumber(limit)==1 then 
						self:GetFriends()
					else
						Api:send(self.imgList[self.tp].tab,self.input_content.value,self.input_name.value,function ()
							local char = Char:new(Player.Info.playercharid)
							chatMrg:showNewChat({
								scope=self.imgList[self.tp].tab,
								content=self.input_content.value,
								from=Player.Info.nickname,
								head=Player.Info.playercharid,
								vip=Player.Info.vip,
								quality=char.star,
								t=os.time()*1000,
								to=Char:getItemColorName(3,self.input_name.value)})
							self.sure.isEnabled=false
							chatMrg.cdTime(self.imgList[self.tp].tab)
						end,function ()
							self.sure.isEnabled=true
						end)
					end 
				end 
			end 
		else 
			MessageMrg.show(TextMap.GetValue("LocalKey_858"))
		end  	
	end
end

function m:GetFriends()
	if self.friends==nil then 
		self.friends={}
		self.sure.isEnabled=false
		Api:getSocialList("friend", function(result)
	        local count = result.list.Count
	        for i = 0, count - 1 do
	        	self.friends[result.list[i].name]=result.list[i]
	        end
	        m:sendMiyu()
	        end,function ()
		    	self.friends=nil 
		    	self.sure.isEnabled=true
		    	MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_863"),"{0}",self.input_name.value))
		    end)      
	else 
		m:sendMiyu()
	end 
end

function m:sendMiyu()
	if self.friends[self.input_name.value]~=nil then 
		self.sure.isEnabled=false
		Api:send(self.imgList[self.tp].tab,self.input_content.value,self.friends[self.input_name.value].name,function ()
			local char = Char:new(Player.Info.playercharid)
			chatMrg:showNewChat({
				scope=self.imgList[self.tp].tab,
				content=self.input_content.value,
				from=Player.Info.nickname,
				head=Player.Info.playercharid,
				vip=Player.Info.vip,
				quality=char.star,
				t=os.time()*1000,
				to=Char:getItemColorName(self.friends[self.input_name.value].quality,self.friends[self.input_name.value].name)})
			self.sure.isEnabled=false
			chatMrg.cdTime(self.imgList[self.tp].tab)
		end,function ()
			self.sure.isEnabled=true
		end)
	else 
		MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_863"),"{0}",self.input_name.value))
	end 
end


function m:CheckUnlock(table)
	if table.Count>0 then 
		for i=0,table.Count-1 do
			if table[i].unlock_condition=="level" then 
				if table[i].unlock_arg>Player.Info.level then 
					MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_859"),"{0}",table[i].unlock_arg))
					return false
				end
			elseif table[i].unlock_condition=="vip" then 
				if table[i].unlock_arg>Player.Info.vip then 
					MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_860"),"{0}",table[i].unlock_arg))
					return false
				end 
			elseif table[i].unlock_condition=="rank_guild" then 
				-- if table[i].unlock_arg>Player.Info.vip then 
				MessageMrg.show(string.gsub(TextMap.GetValue("LocalKey_861"),"{0}",table[i].unlock_arg))
				return false
				-- end  
			end 
		end
	end 
	return true 
end

function m:CheckConsume(table)
	if table.Count>0 then 
		for i=0,table.Count-1 do
			local item =table[i] 
			if Tool.typeId(item.consume_type) then 
				if Player.Resource[item.consume_type]<item.consume_arg then 
					return false
				end
			elseif type=="item" then 
				if Player.ItemBagIndex[item.consume_arg].count<item.consume_arg2 then 
					return false
				end 
			end 
		end
	end 
	return true 
end

return m