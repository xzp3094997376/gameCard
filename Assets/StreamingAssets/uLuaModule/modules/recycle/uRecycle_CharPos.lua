local charPos = {}

local sell_type = "hunyu"
--是否有char
local isChar = false

function charPos:update(lua)
    isChar = false
    self.data = lua.data --自己本身的char信息
    self.index = lua.index
    self.num = lua.data.num
    sell_type = lua.sell_type
    self._type = lua.fenjieType
    --self.addImg.gameObject:SetActive(true)
    --  self.index = index
    self.delegate = lua.delegate
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.node.gameObject)
    end
    if self.data.char then --如果有char
        self.char = self.data.char
        local _type = self.char:getType()
        isChar = true
        --如果有char点击就删除--print(self.char)
        self.name.text = self.char:getDisplayName()
        self.__itemAll.gameObject:SetActive(true)
        if _type == "char" then
                self.hero.gameObject:SetActive(true)  
                self.hero:LoadByModelId(self.char.modelid, "idle", function() end, false, 0, 1)
                self.btChoose.gameObject:SetActive(false)
                self.node.gameObject:SetActive(false)     
        elseif _type == "ghost"  then
                self.equip.gameObject:SetActive(true)
                self.equip.Url = self.char:getHead()
                self.btChoose.gameObject:SetActive(false)
                self.node.gameObject:SetActive(false)      
         elseif _type == "charPiece" or _type == "ghostPiece" then
             local item = RewardMrg.getDropItem({type=_type, arg2=self.num, arg=self.char.id})
             self.__itemAll:CallUpdate({ "itemvo", item, self.node.width, self.node.height })
             self.btChoose.gameObject:SetActive(false)
        end
        -- self.binding:Show("txt_info")
        --self.addImg.gameObject:SetActive(false)s
    else
        self.char = nil
        self.name.text = ""
        if self._type == "ghost" then
            self.equip.gameObject:SetActive(false)
        else
            self.hero.gameObject:SetActive(false)
        end
        self.btChoose.gameObject:SetActive(true)
        self.__itemAll.gameObject:SetActive(false)

    end
end


function charPos:onSelect(go)
    local info = self.delegate:getTeam() --获取选中的所有队员
    if self._type == "ghost" then
        if self.delegate.isOpen== false then 
            MessageMrg.show(TextMap.GetValue("Text1380")) 
            return 
        end
        Tool.push("recycle_ghost_rebirth","Prefabs/moduleFabs/recycleModule/recycle_ghost_rebirth",{ teams = info,delegate = self.delegate,tp="ghost",model="FJ"})
    else
        if self.delegate.isOpen== false then 
            MessageMrg.show(TextMap.GetValue("Text1379"))
            return 
        end
        Tool.push("recycle_charList", "Prefabs/moduleFabs/recycleModule/recycle_charList", { teams = info, delegate = self.delegate, model="FJ",tp="char" })   
    end
end

function charPos:Start()
    
end


function charPos:onDeleteItem(go)
    if self.__itemAll ~= nil then
        self.__itemAll.gameObject:SetActive(false)
        self.name.text = ""
        self.btChoose.gameObject:SetActive(true) 
        if self._type == "ghost" then
            self.equip.gameObject:SetActive(false)
        else
            self.hero.gameObject:SetActive(false)
        end
        if self.char ~= nil then
            self.delegate:onDeleteChar(self.char, self.index)
            self.char = nil
            --self.addImg.gameObject:SetActive(true)
        end
    end
end

function charPos:setBtnState(state)
    self.btChoose.isEnabled = state
end

function charPos:getChar(...)
    return self.char
end

function charPos:onClick(go, name)
    isChar = self:getChar()
    if (name == "btChoose" or name == "btn_equip" or name == "btn_hero")  and isChar ~= nil then    --   and isChar then  --如果有char点击就删除
        self:onDeleteItem(go)
        isChar = false
    elseif  (name == "btChoose" or name == "btn_equip" or name == "btn_hero") and isChar == nil then   --没有东西就弹出
        self:onSelect(go)
        isChar = true
    end
end

function charPos:create(binding)
    self.binding = binding
    return self
end

return charPos