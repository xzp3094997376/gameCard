
-- 阵容位置
local m = {}

function m:update(lua)
    self.delegate = lua.delegate
    self.data = lua.data
    self.char = lua.data.char
    self.index = lua.index
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item_drop.gameObject)
    end
    if self.char then
        self.__itemAll.gameObject:SetActive(true)
        self.__itemAll:CallUpdate({ "char", self.char, 100, 100 })
        --self.binding:Show("txt_info")
        --self.txt_info.text = TextMap.getText("TXT_FORMATION_POS", { self.data.index })
		self.txt_info.text = self.char:getDisplayName()
        self.txt_full:SetActive(false)
        if lua.type~=nil and lua.type=="teamer" then
            self.img_add:SetActive(false)
        end
        --self.red_point:SetActive(false)
    else
        --if self:isFull() then--阵位已满
            --self.binding:Show("txt_info")
            --self.txt_info.text = TextMap.getText("TXT_FORMATION_POS", { self.data.index })
         --   self.txt_full:SetActive(true)
            --if lua.type~=nil and lua.type=="teamer" then
            --    self.img_add:SetActive(false)
            --end
            --self.red_point:SetActive(false)
        --else
            --self.binding:Show("txt_info")
            --self.txt_info.text = TextMap.getText("TXT_FORMATION_POS", { self.data.index })
        --     self.txt_full:SetActive(false)
            if lua.type~=nil and lua.type=="teamer" then
                self.img_add:SetActive(true)
            end
            --self.red_point:SetActive(true)
        --end
        self.txt_info.text = ""
        self.__itemAll.gameObject:SetActive(false)
    end
	
end

function m:updateItem(itemAll)
    if itemAll then self.__itemAll = itemAll end
end

function m:changeItem(old, new)
    MusicManager.playByID(16)
    self.delegate:changeFormation(tonumber(old), tonumber(new))
end

--function m:isFull()
--    return self.delegate:isFull()
--end

function m:checkRedPoint()
    self.red_point:SetActive(Tool.checkGhostRedPiont(self.index))
end

function m:isCanDrop(ret)
    self.drop_hero.enabled = ret
    if ret == false and self.char ~= nil then
        m:checkRedPoint()
    else
        self.red_point:SetActive(false)
    end
end
function m:onSelect()
    Events.Brocast('select_formation_pos2', self.index, self.char == nil)
end

function m:setRedPoint(ret)
    self.red_point:SetActive(ret)
end

--设置阵位是否解锁
function m:setLock(flag, level,type)
    if flag == nil or self.txt_unlock_lv == nil then return end
    if flag == true then
        self.txt_unlock_lv.gameObject:SetActive(true)
        self.txt_unlock_lv.text =string.gsub(TextMap.GetValue("LocalKey_737"),"{0}",level)
        self.node:SetActive(false)
        if type~=nil and type=="teamer" then
            self.img_add:SetActive(false)
        end
        --self.img_add:SetActive(false)
    else
        self.txt_unlock_lv.gameObject:SetActive(false)
        self.node:SetActive(true)
        if type~=nil and type=="teamer" then
            self.img_add:SetActive(true)
        end
    end
end

function m:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function m:Start()
    local that = self
    ClientTool.AddClick(self.item_drop, function()
        if self.delegate.tp == nil or  self.delegate.tp ~= "gui_formation" then 
            that:onSelect()
        end 
    end)
    --self.binding:Hide("txt_info")
    self.drop_hero = self.item_drop:GetComponent("DragHero")
end

return m