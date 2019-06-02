
-- 过滤
local m = {}

function m:update(lua)
	self.delegate = lua.delegate
	for i = 1, 3 do 
		self["item"..i]:CallUpdate({ delegate = self, star = i })
	end 
end



function m:onUpdate()
	
end

function m:onFilterCallback(star ,ret)
	if ret ==true then 
		if star==1 and (self.select_star_one == nil or  self.select_star_one ==false) then 
			self.select_star_one=true 
		elseif star==2 and (self.select_star_two == nil or  self.select_star_two ==false) then 
			self.select_star_two=true 	
		elseif star==3 and (self.select_star_three == nil or  self.select_star_three ==false) then 
			self.select_star_three=true 
		end 
	else
		if star==1 and self.select_star_one ~= nil and  self.select_star_one ==true then 
			self.select_star_one=false 
		elseif star==2 and self.select_star_two ~= nil and  self.select_star_two ==true then 
			self.select_star_two=false 	
		elseif star==3 and self.select_star_three ~= nil and  self.select_star_three ==true then 
			self.select_star_three=false 
		end 
	end

end 

function m:onSelectCallback(charId)

end 

function m:onCallBack(char, tp)

end

function m:Start()

end

function m:onClick(go, name)
	if name == "btn_ok" then 
		-- 筛选
		self.delegate.select_star_one=self.select_star_one
		self.delegate.select_star_two=self.select_star_two
		self.delegate.select_star_three=self.select_star_three
		self.delegate:onUpdate()
		UIMrg:popWindow()
	elseif name == "btn_back" then 
		UIMrg:popWindow()
	end 
end

return m

