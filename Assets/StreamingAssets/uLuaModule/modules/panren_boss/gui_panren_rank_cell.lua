local m = {}

function m:update(data)
    if self.txt_no then
		if data.no <= 3 then 
			self.txt_no.text = ""
			self.img_rank.spriteName = "jiangpai_" .. data.no
			self.img_rank.gameObject:SetActive(true)
		else 
		   self.txt_no.text = data.no
		   self.img_rank.gameObject:SetActive(false)
		end 
    end
    self.txt_name.text = Char:getItemColorName(data.star, data.name)
    self.txt_dps.text = data.dps
	self.txt_gongji.text = TextMap.GetValue("Text_1_2937") .. data.power
	if data.tp == 1 then 
		self.txt_dps.text = TextMap.GetValue("Text_1_2938") .. data.gongxun
	else 
		self.txt_dps.text = TextMap.GetValue("Text_1_2939") .. data.dps
	end 
    if self.txt_no_rank then
        self.txt_no_rank.text = ""
        if data.name == "" and data.dps == "" then
            self.txt_no_rank.text = TextMap.GetValue("Text1134")
        end
    end
	m:setHead(data.dictid, data.star)
    --if self.bg ~= nil then
    --    if data.index ~= nil and data.index % 2 == 0 then
    --        self.bg.gameObject:SetActive(true)
    --    else
    --        self.bg.gameObject:SetActive(false)
    --    end
    --end
end

function m:setHead(dictid, star)
	local char = Char:new(nil, dictid)
	char.star = star
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_head.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", char, self.img_head.width, self.img_head.height, nil, nil, true })
	char = nil
end 

return m