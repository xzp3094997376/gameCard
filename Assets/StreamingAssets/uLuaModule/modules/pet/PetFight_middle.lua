local m = {} 

local list = {}

function m:update()
	m:setListInfo()
	for i = 1, 12 do
		local info = {}
		if Player.PetChapter[i] then
			info.data = Player.PetChapter[i]
			info.index = i
		else
			info.allRefresh = true
		end
		list[i]:CallUpdate(info)
	end


	-- for k, v in pairs(itemlist) do
	-- 	local info = {}
	-- 	info.data = v
	-- 	info.index = k
	-- 	list[k]:CallUpdate(info)
	-- end

	self.RedPoint.gameObject:SetActive(Tool.checkChongWu() or false)
end

function m:setListInfo()
	for i = 1, 12 do
		list[i] = self["GuanKa_"..i]
	end
end

function m:onClick(go, name)
	if name == "Btn_rw" then
    	UIMrg:pushWindow("Prefabs/moduleFabs/pet/PetFinishRw",{})
	end
end

return m