local m = {} 
local canDunzao = true
function m:update(lua_data)
	local treasure = lua_data.treasure
	self.delegate = lua_data.delegate
	if treasure.star ~= 5 then return end
	self.treasure = treasure

	if self.__itemShow == nil then
        self.__itemShow = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame_1.gameObject)
    end
    self.__itemShow:CallUpdate({ "treasure", treasure, self.img_frame_1.width, self.img_frame_1.height, true, nil, })
	self.__itemShow:CallTargetFunction("setTipsBtn",  false )

    self.txt_name_1.text = treasure.name
    self.txt_level_1.text = "Lv."..treasure.lv..TextMap.GetValue("Text1751")..treasure.power
    self.heroic_property.text = treasure:GetTreasureBaseProperty(0).."\n"..treasure:GetTreasureJLProperty(0)

    local allexp = treasure:getLevelAllExp()
    self:ShowImmortalityCell(treasure.power,allexp)
    self:ShowCostsInfomation(treasure)
    ClientTool.AddClick(self.btn_duanzao,function()
	    	if canDunzao then
		    	if Player.Resource.gold < self._costMoney then
            		MessageMrg.show(TextMap.GetValue("Text1757"))
            	else
			    	Api:treasureCast(treasure.key,function(result)			    		
			    	self:PlayEffect()	
			    	end,function()
	    			print(TextMap.GetValue("Text1758"))
	    			end)
    			end
		    else
		    	MessageMrg.show(TextMap.GetValue("Text1757"))
	    	end

    end)
end

function m:ShowImmortalityCell(power,allexp)
	local config =  TableReader:TableRowByID("treasureCasting", self.treasure.id)
	if config == nil then return end
	self.nextId = config.drop[0].arg
	immortalityTreasure = Treasure:new(self.nextId)

	if self.__itemNext == nil then
        self.__itemNext = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame_2.gameObject)
    end
    self.__itemNext:CallUpdate({ "treasure", immortalityTreasure, self.img_frame_2.width, self.img_frame_2.height, true, nil, })
    local newValue = self:Summour(allexp,0)

    self.txt_name_2.text = immortalityTreasure.name
    local msg = string.gsub(TextMap.GetValue("LocalKey_829"),"{0}",newValue.up_lv)
    self.txt_level_2.text =string.gsub(msg,"{1}",power)
    self.immortality_property.text = immortalityTreasure:GetTreasureBaseProperty(newValue.up_lv).."\n"..immortalityTreasure:GetTreasureJLProperty(power)


end

function m:Summour(all_exp,count)
	local value = {}
	local expConfig = TableReader:TableRowByUnique("treasureLevelUp","level",(count+1))["t"..self.nextId]
	 
	if expConfig == nil then
		value.up_lv = count
		value.last_exp = 0
	else
		if all_exp >= expConfig then
			value = self:Summour(all_exp - expConfig,count+1)
		else
			value.up_lv = count
			value.last_exp = all_exp	
		end
	end
	return value
end

function m:RefreshView()
	local info = Player.Treasure[self.treasure.key]
	local new_data = Treasure:new(info.id,self.treasure.key)
	local temp = {}
    temp.obj = new_data
	temp.type = 1
    Tool.push("treasure_info", "Prefabs/moduleFabs/TreasureModule/treasure_tips", temp)
    self.delegate.iteminfo = new_data
    self.delegate:ChooseStrength()
end

function m:ShowCostsInfomation(treasure)
	local config =  TableReader:TableRowByID("castingConsume",  treasure.power)
	if config == nil then return end
    local list = RewardMrg.getConsumeTable(config.consume)
    for i = 1, #list do
        local it = list[i]
        local tp = it:getType()
        if tp == "gold" then
            self.txt_cost_gold.text = it.rwCount
            self._costMoney = it.rwCount
        elseif tp == "item" then
        	if self.__itemAll == nil then
        		self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame_cost.gameObject)
    		end
            local scalCount = it.rwCount
            it.rwCount = 1
        	self.__itemAll:CallUpdate({ "char", it, self.img_frame_cost.width, self.img_frame_cost.height, true, nil, })

            self.txt_name_cost.text = it.name
            
            local color1 = "[00ff00]"
            if Player.ItemBagIndex[it.id].count < scalCount then
                color1 = "[ff0000]"
                canDunzao = false
            end
            self.txt_count_cost.text = color1..Player.ItemBagIndex[it.id].count .. "[-]/" .. scalCount     
        end
    end
end

function m:PlayEffect()
	self.zhuzhao:SetActive(false)
	self.zhuzhao:GetComponent("TweenPosition"):ResetToBeginning()
	self.zhuzhao:SetActive(true)
	self:AllMode("mode_1")
	self.binding:CallAfterTime(0.8,function()
		self:AllMode("mode_2")
		self.zhuzhao:GetComponent("TweenPosition"):Play(true)
		self.binding:CallAfterTime(1.3,function()
			self:AllMode("mode_3")
			self.binding:CallAfterTime(0.7,function()
			self:RefreshView()
			self:AllMode("mode_none")
			end)
		end)
	end,2)
end

function m:AllMode(mode)
	self.lizixishou:SetActive(mode == "mode_1")
	self.lizituowei:SetActive(mode == "mode_2")
	self.bao:SetActive(mode == "mode_3")
end

function m:OnDisable( ... )
	self.zhuzhao:SetActive(false)
	self:AllMode("mode_none")
end


return m