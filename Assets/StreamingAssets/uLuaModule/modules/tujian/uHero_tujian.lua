local m = {} 
local shanren = {}--善忍列表
local eren = {} --恶忍列表
local yingren={} -- 影忍列表

function m:update(lua)
	self.type="shan"
	self.tp=1
	if #shanren ==0 then 
		TableReader:ForEachTable("char",
			function(index, item)
				if item ~= nil then
					if item.party==1 then 
						table.insert(shanren, item)
					elseif item.party==2 then 
						table.insert(eren, item)
					elseif item.party==3 then 
						table.insert(yingren, item)
					end 
				end
				return false
				end)
	end 
	self.contain_shan:CallUpdate({data=shanren,type="shan",delegate=self})
	self.contain_e:CallUpdate({data=eren,type="e",delegate=self})
	self.contain_ying:CallUpdate({data=yingren,type="ying",delegate=self})
	self.img_shan:SetActive(true)
	self.img_e:SetActive(false)
	self.img_ying:SetActive(false)
	self.img_kind={}
	self.img_kind[1]=self.img_hong
	self.img_kind[2]=self.img_cheng
	self.img_kind[3]=self.img_zi
	self.img_kind[4]=self.img_lan
	self.img_kind[5]=self.img_lv
	for i=1,5 do
		if i==self.tp then 
			self.img_kind[i]:SetActive(true)
		else
			self.img_kind[i]:SetActive(false)
		end 
	end
end


function m:onClick(go, name)
    if name == "btn_shan" then 
    	if self.type~="shan" then 
    		self.type="shan"
    		self.img_shan:SetActive(true)
    		self.img_e:SetActive(false)
    		self.img_ying:SetActive(false)
    		self.contain_shan:CallUpdate()
    		self.contain_e:CallUpdate()
    		self.contain_ying:CallUpdate()
    	end 
	elseif name == "btn_e" then 
		if self.type~="e" then 
    		self.type="e"
    		self.img_shan:SetActive(false)
    		self.img_e:SetActive(true)
    		self.img_ying:SetActive(false)
    		self.contain_shan:CallUpdate()
    		self.contain_e:CallUpdate()
    		self.contain_ying:CallUpdate()
    	end 
	elseif name == "btn_ying" then 
		if self.type~="ying" then 
    		self.type="ying"
    		self.img_shan:SetActive(false)
    		self.img_e:SetActive(false)
    		self.img_ying:SetActive(true)
    		self.contain_shan:CallUpdate()
    		self.contain_e:CallUpdate()
    		self.contain_ying:CallUpdate()
    	end 
    elseif name == "btn_hero1" then 
    	if self.tp~=1 then 
    		self.tp=1
    		for i=1,5 do
    			if i==self.tp then 
    				self.img_kind[i]:SetActive(true)
    			else
    				self.img_kind[i]:SetActive(false)
    			end 
    		end
    		self.contain_shan:CallUpdate()
    		self.contain_e:CallUpdate()
    		self.contain_ying:CallUpdate()
    	end 
    elseif name == "btn_hero2" then 
    	if self.tp~=2 then 
    		self.tp=2
    		for i=1,5 do
    			if i==self.tp then 
    				self.img_kind[i]:SetActive(true)
    			else
    				self.img_kind[i]:SetActive(false)
    			end 
    		end
    		self.contain_shan:CallUpdate()
    		self.contain_e:CallUpdate()
    		self.contain_ying:CallUpdate()
    	end 
    elseif name == "btn_hero3" then 
    	if self.tp~=3 then 
    		self.tp=3
    		for i=1,5 do
    			if i==self.tp then 
    				self.img_kind[i]:SetActive(true)
    			else
    				self.img_kind[i]:SetActive(false)
    			end 
    		end
    		self.contain_shan:CallUpdate()
    		self.contain_e:CallUpdate()
    		self.contain_ying:CallUpdate()
    	end 
    elseif name == "btn_hero4" then 
    	if self.tp~=4 then 
    		self.tp=4
    		for i=1,5 do
    			if i==self.tp then 
    				self.img_kind[i]:SetActive(true)
    			else
    				self.img_kind[i]:SetActive(false)
    			end 
    		end
    		self.contain_shan:CallUpdate()
    		self.contain_e:CallUpdate()
    		self.contain_ying:CallUpdate()
    	end 
    elseif name == "btn_hero5" then 
    	if self.tp~=5 then 
    		self.tp=5
    		for i=1,5 do
    			if i==self.tp then 
    				self.img_kind[i]:SetActive(true)
    			else
    				self.img_kind[i]:SetActive(false)
    			end 
    		end
    		self.contain_shan:CallUpdate()
    		self.contain_e:CallUpdate()
    		self.contain_ying:CallUpdate()
    	end 
	elseif name == "btnBack" then 
		UIMrg:pop()
    end
end


function m:setHaveNum(rest)
	-- body
end



return m