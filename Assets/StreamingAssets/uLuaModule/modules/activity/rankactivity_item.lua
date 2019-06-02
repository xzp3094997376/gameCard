local m = {}

function m:update(lua_data)
    self.data = lua_data.data
    self.muti = lua_data.muti
    self.type = lua_data.type
    if self.data == nil then
        self.rankItem:SetActive(false)
     return 
    end
    
    if self.data.name ~= nil then
        self.Label.text =Tool.getNameColor(self.data.quality or 1) .. self.data.name .. "[-]"
    end
    local s_value = self.data.act_value or 0
    if self.type == "rankPay" then
        s_value = s_value*self.muti
    end
    if s_value==0 then
        self.txt_power.text =TextMap.GetValue("Text_1_60") 
    else
        self.txt_power.text =TextMap.GetValue("Text_1_61") .. s_value
    end

    self.vip_num.text = "VIP " .. self.data.vip
    if self.data.rank>3 then 
        self.img_rank.enabled = false
        self.rank.text=string.gsub(TextMap.GetValue("Text402"),"{0}",self.data.rank)
    else
        self.img_rank.enabled = true
        self.img_rank.spriteName = "jiangpai_" .. self.data.rank  
        self.rank.text=""
    end
    self:setHead(self.data.playerid or 1, self.data.quality or 1)
end

function m:setHead(dictid, star)
    local char = Char:new(nil, dictid)
    char.star = star
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.icon.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", char, self.icon.width, self.icon.height, true, nil, true })
    self.__itemAll:CallTargetFunction("setTipsBtn",false)
end

function m:Start()
    -- self.img.Url = UrlManager.GetImagesPath("activity/rank_bg.png")
end

return m

