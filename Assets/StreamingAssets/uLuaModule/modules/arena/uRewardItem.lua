local m = {}

function m:update(data)
    self.data = data
	self.rank = data.rank
	
	self.txt_rank.text = self.rank
	self.delegate = data.delegate
	local obj = nil
	local rank = nil
	if self.delegate.type.."" == "2" then 
		self.rewardobj = self.delegate.rewardobj
		
		obj, rank  = self:getRewardByCrossArena()
	else 
		obj = self:getRewardBySelf()
	end 
	self:setRewardData(obj, rank)
end

function m:getRewardByCrossArena()
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
	return nil, lvTb[#lvTb].rank
end

function m:getRewardBySelf()
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
	if awardObj ~= nil then 
		local drop = {}
		for i = 0, awardObj.drop.Count do 
			table.insert(drop, awardObj.drop[i])
		end
		return drop
	end 	
	return awardObj
end

function m:setRewardData(awardObj, rank)
    if awardObj == nil then
		if rank ~= nil and self.jianliDes ~= nil then 
			self.jianliDes.text =string.gsub(TextMap.GetValue("LocalKey_788"),"{0}",rank-1)
			self.jianliDes.gameObject:SetActive(true)
		end 
        self.txt_honorCoin.text = ""
        self.txt_coin.text = ""
        self.txt_diamond.text = ""
    else
		self.jianliDes.gameObject:SetActive(false)
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

--初始化
function m:create(binding)
    self.binding = binding
    return self
end

return m