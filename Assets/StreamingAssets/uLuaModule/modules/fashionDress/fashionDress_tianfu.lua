local m = {} 

function m:update(char)
	self.char=char
	self.selectIndex=0
	self.list={}
	self.list=self:GetAllTianfu()
	--self.rewardView:refresh(self.list, self, false, 0)
	--ClientTool.UpdateGrid("Prefabs/moduleFabs/fashionDress/tianfu_cell", self.Content, self.list, self)
	--[[if self.selectIndex>0 then
		self.binding:CallAfterTime(0.1, function()
			self.rewardView:goToIndex(self.selectIndex)
			end)
	end]] 
end

function m:onClick(go, name)
    if name == "btnClose" then 
		UIMrg:popWindow()
	elseif name =="btn_next" then 
		UIMrg:popWindow()
    end
end

function m:GetAllTianfu()
	local list = {}
	local char = self.char
	if char~=nil and Player.fashion[char.id] ~=nil and Player.fashion[char.id].powerlvl~=nil then 
		local lv=Player.fashion[char.id].powerlvl
		if lv<1 then lv =1 end 
		if lv >300 then lv =300 end
		self.tip2.text=TextMap.GetValue("Text_1_340") .. lv
		local tianfuList = {}
		local powerUp_skill= self.char.modelTable.fashion_powerUp_skill
		local row =TableReader:TableRowByUniqueKey("fashion_powerup", self.char.star-3, lv)
		if row==nil then return end 
		local lock_skill=row.unlockskill
		for i = 0, powerUp_skill.Count-1 do 
			local skill =TableReader:TableRowByID("skill", powerUp_skill[i])
			if skill ~=nil then 
				local unlock = lock_skill[i]	
				local tianfuName = skill.show
				local ft = ""
				local ftdesc = ""
				if  unlock ~="" and unlock==i then 
					ft = "[ff0000]【" .. tianfuName .. "】[-]"
					ftdesc = "[ff0000]" .. skill.desc   .. " [-]" 
				else 
					ft = "[9a4c1e]【" .. tianfuName .. "】[-]"
					ftdesc = "[9a4c1e]" .. skill.desc   .. " [-]" 
				end 
				table.insert(tianfuList, {name = ft, desc = ftdesc}) 
			end
		end 
		self.Content:CallUpdate({ type = "other", list = tianfuList })
	end 
end 
return m