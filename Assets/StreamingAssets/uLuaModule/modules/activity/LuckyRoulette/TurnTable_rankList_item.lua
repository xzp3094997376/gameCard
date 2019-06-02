local member = {}

function member:update(data)
        print_t(data)
        --{"pid":"DukOR","name":"片冈怜那","act_id":"act2","point":930}
        data.quality=data.quality or 5
        data.playerdictid=data.playerdictid or 2
        self.txt_name.text = Char:getItemColorName(data.quality, data.name)
        self.txt_jifen.text ="[F0E77B]" .. TextMap.GetValue("Text409") .. "[-] " ..data.point
        if tonumber(data.index)<=3 then
                self.txt_rank.text=""
                self.img_rank.gameObject:SetActive(true)
                self.img_rank.spriteName="jiangpai_" .. data.index
        else 
                self.img_rank.gameObject:SetActive(false)
                local str = "[F0E77B]" .. TextMap.GetValue("Text402") .. "[-]"
                self.txt_rank.text =string.gsub(str, "{0}", "[-]" .. data.index .. "[F0E77B]")
        end 
        local char = Char:new(nil, data.playerdictid)
        char.star = data.quality
        if self.itemAll == nil then
                self.itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.pic.gameObject)
        end
        self.itemAll:CallUpdate({ "char", char, self.pic.width, self.pic.height, nil, nil, true })
end

return member