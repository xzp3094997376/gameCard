local arenaHangCell = {}

function arenaHangCell:update(tableData, index, delegate)
    self.data = tableData
    self.arena_hangCell.name = tableData.rank

    self.Sprite_jiangpai.gameObject:SetActive(true)
    self.txt_hang.gameObject:SetActive(false)
    if tableData.rank == 1 then
        self.Sprite_jiangpai.spriteName = "jiangpai_1"
    elseif tableData.rank == 2 then
        self.Sprite_jiangpai.spriteName = "jiangpai_2"
    elseif tableData.rank == 3 then
        self.Sprite_jiangpai.spriteName = "jiangpai_3"
    else
        self.Sprite_jiangpai.gameObject:SetActive(false)
        self.txt_hang.gameObject:SetActive(true)
        self.txt_hang.text =string.gsub(TextMap.GetValue("Text402"),"{0}",tableData.rank)
    end
    self.txt_lvl.text = TextMap.GetValue("Text_1_165")..tableData.level
    self.txt_name.text = Char:getItemColorName(tableData.quality, tableData.name or tableData.nickname) 
    --self.txt_power.text = tableData.power
    --self.txt_vip.text = tableData.vip
    self.delegate = delegate
	local obj = nil
	if self.delegate.type.."" == "2" then 
		self.rewardobj = self.delegate.rewardobj
		
		obj = self:getRewardByCrossArena()
	else 
		obj = self:getRewardBySelf()
	end 
	self:setRewardData(obj)
	self:setHead(tableData.dictid or tableData.playerid or "", tableData.quality)
end

function arenaHangCell:setHead(dictid, star)
	local char = Char:new(nil, dictid)
	char.star = star
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.simpleImage.gameObject)
    end
    self.__itemAll:CallUpdate({ "char", char, self.simpleImage.width, self.simpleImage.height, nil, nil, true })
end 

function arenaHangCell:onClick(go, name)
    if name == "arenaBtn" then
        Api:showDetailInfo(self.data.id or self.data.pid,self.data.sid,self.data.rank,
            function(result)
                local temp = {}
                temp.data = result.showRet[0].defenceTeam
                temp.show = false
                local datas = {}
                self.data.nickname = self.data.name or self.data.nickname
                datas["info"] = self.data
                datas.rank = self.data.rank
                temp.peopleVO = datas
                temp.pid = self.data.id or self.data.pid
                temp.sid = self.data.sid
                temp.tp = self.delegate.type
				temp.playercharid = result.showRet[0].playerid
                datas = nil
                UIMrg:pushWindow("Prefabs/moduleFabs/arenaModule/arena_enemy_info", temp)
                temp = nil
                result = nil
            end)
    end
end

function arenaHangCell:getRewardByCrossArena()
	if self.rewardobj == nil then return nil end 
	local tb = json.decode(tostring(self.rewardobj.Rewards)) 
	local lvTb = {}
	for i, j in pairs(tb) do
		local lv = tonumber(i)
		if lv ~= nil then 
			table.insert(lvTb, {rank = lv + 1, drop = j.drop})
		end 
	end
	table.sort(lvTb, function(a, b)
		return a.rank < b.rank
	end)
	for i = 1, #lvTb do 
		if self.data.rank <= lvTb[i].rank then 
			return lvTb[i].drop
		end 
	end
	return nil
end

function arenaHangCell:getRewardBySelf()
	local awardObj = nil
	local ishaveValue = false
	local rankingDesc = nil 
	TableReader:ForEachLuaTable("dailyPrize",
            function(index, item)
                if item.rank_tag == self.data.rank then
                    awardObj = TableReader:TableRowByUnique("dailyPrize", "rank_tag", item.rank_tag)
                    rankingDesc = item.desc
                    ishaveValue = true
                elseif item.rank_tag > self.data.rank then
                    if ishaveValue == false then
                        awardObj = TableReader:TableRowByUnique("dailyPrize", "rank_tag", rankingDesc)
                        rankingDesc = awardObj.rank_tag .. awardObj.desc
                        ishaveValue = true
                    end
                end
                if ishaveValue == false then
                    rankingDesc = item.rank_tag
                end
                return false
            end)
	local drop = {}
	for i = 0, awardObj.drop.Count do 
		table.insert(drop, awardObj.drop[i])
	end 
	return drop
end

function arenaHangCell:setRewardData(awardObj)
    if awardObj == nil then
        self.txt_honorCoin.text = 0
        self.txt_coin.text = 0
        self.txt_diamond.text = 0
    else
		local texts = nil
		local images = nil
		if self.delegate.type.."" == "2"  then
			texts = {self.txt_honorCoin, self.txt_coin, self.txt_diamond }
			images = {self.img_honorCoin, self.img_coin, self.img_diamond}
		else 
			texts = {self.txt_diamond, self.txt_coin, self.txt_honorCoin}
			images = {self.img_diamond, self.img_coin, self.img_honorCoin}		
		end
        local drop = awardObj
        if #drop == 0 then
			for i = 1, #texts do 
				texts[i].text = 0
			end 
        else
			for i = 1, #drop do 
				local item 
				if texts[i] ~= nil then 
					texts[i].text = toolFun.moneyNumberShowOne(tonumber(drop[i].arg2))
				end
				if drop[i].type == "treasure" then
					item = Treasure:new(drop[i].arg)
				elseif drop[i].type == "item" then 
					item = uItem:new(drop[i].arg)
				else 
					images[i]:setImage(Tool.getResIcon(drop[i].type), "itemImage")
					texts[i].text = toolFun.moneyNumberShowOne(tonumber(drop[i].arg))
				end 
				if item ~= nil then 
					if images[i] ~= nil then 
						images[i]:setImage(item:getHead())
					end
				end 
			end 
        end
		texts = nil
		images = nil
    end
end

function arenaHangCell:getHead(id)
    local img = id
    if (img == "" or img == nil) then img = "default" end
    local path = UrlManager.GetImagesPath("itemImage/" .. img .. ".png")
    return path
end

--初始化
function arenaHangCell:create(binding)
    self.binding = binding
    return self
end

return arenaHangCell