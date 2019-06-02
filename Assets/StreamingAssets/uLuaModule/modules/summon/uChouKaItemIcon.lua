--抽卡物品头像显示
local choukaItemIcon = {}

function choukaItemIcon:update(data, index, table)
    self.effectZi:SetActive(false)
    self.effectHuang:SetActive(false)
    self.effectHong:SetActive(false)
    self.char=data
    self.labName.text = self.char:getDisplayName()
    self.item_frame.enabled = false
    self.binding:Hide("hero")
    --if self.__itemAll == nil then
   --     self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item_frame.gameObject)
    --end
    --.__itemAll:CallUpdate({ "char", data, self.item_frame.width, self.item_frame.height })
    --    ClientTool.resetTransform(self.__itemAll.transform)
    if self.eff ~=nil then
        self.eff:SetActive(false)
    end
    if self.char.star and self.char.star >3 and self.Panel then
    	--self.binding:CallAfterTime(0.5,function ()
    		if self.char.star==4 then
    			self.effectZi:SetActive(true)
    		elseif self.char.star==5 then
    			self.effectHuang:SetActive(true)
    		elseif self.char.star==6 then
    			self.effectHong:SetActive(true)
    		end
    	--end)
        --self.binding:CallAfterTime(0.3,function ()
            self.binding:Show("hero")
            self.ani.enabled=true
            self.ani:ResetToBeginning()
            self.hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 0, 1)
        --end)
        self.Panel:SetActive(true)
    else
        self.binding:Show("hero")
        self.ani.enabled=true
        self.ani:ResetToBeginning()
        self.hero:LoadByModelId(self.char.dictid, "idle", function() end, false, 0, 1)
        if self.Panel then
            self.Panel:SetActive(false)
        end
    end
end

function choukaItemIcon:play(cb)
    self.binding:PlayTween("ani", 0.3, function()
        if cb then cb() end
    end)
end

function choukaItemIcon:showInfo()
    if self.char == nil then return end
    local char = self.char
    char.isGo=false
    Tool.push("heroInfo", "Prefabs/moduleFabs/hero/hero_info_two", char)
end

function choukaItemIcon:onClick(go, name)
    print (name)
    if name == "hero_info" then
        if not GuideMrg:isPlaying() then
            self:showInfo()
        end
    end
end

return choukaItemIcon