local m = {} 
local canJinglian = true
function m:update(treasure)
    self.treasure = treasure
    print_t(self.treasure.info.skill)
	self.treasure:updateInfo()
    canJinglian = true
	self:ShowCostsInfomation(treasure)
    self._costMoney = 0
	local name = treasure:getHeadSpriteName()
    local atlasName = packTool:getIconByName(name)
    self.t1:setImage(name, atlasName)
    self.t2:setImage(name, atlasName)
    --if self.__itemShow == nil then
    --    self.__itemShow = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame_1.gameObject)
    --end
    --self.__itemShow:CallUpdate({ "treasure", treasure, self.img_frame_1.width, self.img_frame_1.height, true, nil, })
    --self.__itemShow:CallTargetFunction("setTipsBtn",  false )
    --self.txt_name_1.text = treasure.name
	if treasure.power == 0 then
        self.txt_t1_name.text = treasure:getDisplayColorName()
    else
        self.txt_t1_name.text = treasure:getDisplayColorName()
    end
	self.txt_t2_name.text = Tool.getNameColor(treasure.Table.star) .. treasure.name .. " [-][24FC24]+" .. (treasure.power+1) .. "[-]"

    self.old_property.text = treasure:GetTreasureJLProperty(0,false)
    self.new_property.text = treasure:GetTreasureJLProperty(1,true)
    --self.txt_power_current.text = TextMap.GetValue("Text1751")..treasure.power
    --self.txt_power_next.text = (treasure.power+1)
    ClientTool.AddClick(self.btn_jinglian,function()
        if Player.Resource.money >= self._costMoney then
            if canJinglian then
				print("canJinglian")
                Api:treasurePowerUp(treasure.key,function()
					print("treasurePowerUp")
                    m:showEffect(true)
					m:update(self.treasure)
                    self:RefreshView()
                    m:showGodSkillOpen(self.treasure.name, self.treasure.power)
                    print(TextMap.GetValue("Text32"))
                end,function()
                    print(TextMap.GetValue("Text1758"))
                end)
            else
                MessageMrg.show(TextMap.GetValue("Text1757"))
            end
        else
            MessageMrg.show(TextMap.GetValue("Text1"))
        end
    end)
    self.Btn_ShenBinFrom.gameObject:SetActive(false)
    m:judgeShenBinSkill()
end

function m:judgeShenBinSkill()
    local godSkillMenu = Tool:getGodSkillListInfo()
    self.Btn_ShenBinFrom.gameObject:SetActive(false)

    for i = 1, #godSkillMenu do
        local item = godSkillMenu[i]
        if item ~= nil and item.name == self.treasure.name then
            self.Btn_ShenBinFrom.gameObject:SetActive(true)
            break
        end
    end
end

function m:showEffect(ret)
    MusicManager.playByID(46)
	self.effect:SetActive(false)
    self.effect:SetActive(true)
    self.binding:CallAfterTime(2, function()
        self.effect:SetActive(false)
        if ret then isClick = false end 
    end)
end

function m:showGodSkillOpen(name, power)
    local godSkillMenu = Tool:getGodSkillListInfo()
        if godSkillMenu ~= nil then
            for i = 1, #godSkillMenu do
                local item = godSkillMenu[i]
                if item ~= nil and item.name == name then
                    print_t(item)
                    for i = 0, item.unlock.Count do
                        if item.unlock[i] ~= nil and item.unlock[i] == power then
                            local desc = {}
                            local str = TextMap.GetValue("Text_1_2925")..item._skillid[i].name.."[-]"
                            table.insert(desc, str)
                            OperateAlert.getInstance:showToGameObject(desc, self.node)
                            break;
                        end
                    end
                end
            end
        end
end



function m:ShowCostsInfomation(treasure)
	local config =  TableReader:TableRowByUniqueKey("treasurePowerUp", treasure.id, treasure.power + 1)
	if config == nil then return end
	
    local list = RewardMrg.getConsumeTable(config.consume)
    for i = 1, #list do
        local it = list[i]
        local tp = it:getType()
        if tp == "money" then
            self.txt_cost_money.text = it.rwCount
            self._costMoney = it.rwCount
        elseif tp == "item" then
        	if self.__itemAll == nil then
        		self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame_2.gameObject)
    		end
            local scalCount = it.rwCount
            it.rwCount = 1
            self.itemInfo = itemvo:new(tp, 1, it.id)
        	self.__itemAll:CallUpdate({ "itemvo", self.itemInfo, self.img_frame_2.width, self.img_frame_2.height, true, nil, })

            self.txt_name_2.text = Tool.getNameColor(it.star) .. it.name .. "[-]"
            
            local color1 = "[00ff00]"
            if Player.ItemBagIndex[it.id].count < scalCount then
                color1 = "[ff0000]"
                canJinglian = false
            end
            self.txt_count_2.text = color1..Player.ItemBagIndex[it.id].count .. "[-]/" .. scalCount
        elseif tp == "treasure" then
            if self.__treasureAll == nil then
        		self.__treasureAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame_3.gameObject)
    		end
            local scalCount2 = it.rwCount
            if scalCount2 == 0 then
                self.Cost2Cell:SetActive(false)
            else
                self.Cost2Cell:SetActive(true)
                it.rwCount = 1
                self.__treasureAll:CallUpdate({ "treasure", it, self.img_frame_3.width, self.img_frame_3.height, nil, nil})
                self.txt_name_3.text = Tool.getNameColor(it.star) .. it.name .. "[-]"
                local color2 = "[00ff00]"
                if Tool.getTreasureCountByID(it.id,treasure.key) < it.rwCount then
                    color2 = "[ff0000]"
                    canJinglian = false
                end
                self.txt_count_3.text = color2..Tool.getTreasureCountByID(it.id,treasure.key) .. "[-]/" .. scalCount2
            end
           
         
        end
    end
end

function m:onClick(go, name)
    if name == "Btn_ShenBinFrom" then
        UIMrg:pushWindow("Prefabs/moduleFabs/guidao/GodSkillFrom",{
            power = self.treasure.power, data = self.treasure , delegate = self})
    end
end

function m:OnDisable( ... )
    self.effect:SetActive(false)
end

function m:RefreshView()
    local info = Player.Treasure[self.treasure.key]
    local new_data = Treasure:new(self.treasure.id,self.treasure.key)
    self:update(new_data)
end

return m