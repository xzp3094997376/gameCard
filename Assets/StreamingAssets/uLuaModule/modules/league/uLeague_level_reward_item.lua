local m = {} 

function m:update(data)
	self.data = data
	if self.__itemAll == nil then
		self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
	end
	self.__itemAll:CallUpdate({ "char", data, self.img_frame.width, self.img_frame.height, true, nil, })
    self.txt_name.text = data.name
    if data.shop_item.count > 1 then
   		self.number.text = data.shop_item.count
   	else
   		self.number.text = ""
	end

	local iconName = Tool.getResIcon(data.shop_item.sell_type)
    local assets = packTool:getIconByName(iconName)
    self.sp_money:setImage(iconName, assets)

    self.des.text =string.gsub(TextMap.GetValue("LocalKey_774"),"{0}",data.shop_item.guild_level_limit)

    self.isSell = true
	if data.shop_item.posid ~= nil and data.shop_item.posid ~= -1 then -- 表示为奖励类的商品,在<公会奖励商店|guildPackage>表中配置,在道具和奖励商店显示
        if Player.GuildPkg ~= nil and Player.GuildPkg[data.shop_item.posid] == 1 then
            self.isSell = true
        else
            self.isSell = false
        end
    end
    self.btn_get.isEnabled = not self.isSell
    if self.isSell then
    	self.btn_get:GetComponentInChildren(UILabel).text = TextMap.GetValue("Text1735")
    else
    	self.btn_get:GetComponentInChildren(UILabel).text = TextMap.GetValue("Text1736")
    end

    local color = "[00ff00]"
    if Tool.getCountByType(data.shop_item.sell_type) < data.shop_item.sell_price  and not self.isSell then
    	color = "[ff0000]"
    end

    self.txt_money.text = data.shop_item.sell_price



    ClientTool.AddClick(self.btn_get,function()
    	if GuildDatas:getMyGuildInfo().guildLevel < self.data.shop_item.guild_level_limit then
            MessageMrg.show(TextMap.GetValue("Text1737"))
        elseif self.isSell then
        	print(TextMap.GetValue("Text1671"))
       	else
       		if Tool.getCountByType(data.shop_item.sell_type) >= data.shop_item.sell_price then
                DialogMrg.ShowDialog(string.gsub(TextMap.GetValue("LocalKey_775"),"{0}",data.shop_item.sell_price), function()
                    self:GetLevelsRewards()
                end)
       		else
       			MessageMrg.show(TextMap.GetValue("Text1740"))
       		end
        end
    end)
end

function m:GetLevelsRewards()
    Api:buyPkgShop(self.data.shop_item.posid, "1",
            function(result)
                local name = self.data.name
                local num = self.data.shop_item.count
                MessageMrg.showMove(TextMap.GetValue("Text1741") .. name .. " [-]X " .. num)
                --UIMrg:popWindow()
                self:update(self.data)
            end,
            function()
                return false
            end)
end


return m