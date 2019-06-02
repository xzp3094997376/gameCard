--掠夺宝物icon
local m = {}

local infobinding

function m:update(data,index,delegate,ret)
    self._treasure = data.treasure
    self.real_index = data.real_index
    self.choose = data.choose
    self.type = data.type
    self.index = index
    self.delegate = delegate
    self.img_frame.enabled = false
    
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "treasure", self._treasure, self.img_frame.width, self.img_frame.height, true, nil, })
    self.name.text = self._treasure:getDisplayColorName()
    if self.type =="info" then
        self.__itemAll:CallTargetFunction("setTipsBtn",true)
    else
        self.__itemAll:CallTargetFunction("setTipsBtn",false)
    end
    if ret ==nil then 
        self.__itemAll:CallTargetFunction("setFrameEnable",false)
    end
    if self.type == "normal" then
        Events.AddListener("onChoose", funcs.handler(self, m.onChoose))
    end

    if self.select ~= nil and self.choose ~= nil then
        self.select:SetActive(self.choose)
    end
end

function m:onClick(go, name)
    -- if self.delegate ~= nil and self._treasure ~= nil  then
    if self.type == "normal" then
        local temp = {}
        temp.treasure = self._treasure
        temp.real_index = self.real_index
        self.delegate:showMaterial(temp)
        Events.Brocast("onChoose", self.real_index)
    -- elseif self.type == "smelt" then
    --     self.delegate:setMaterial(nil)
    end
end

function m:onChoose(index)
    if self.select ~= nil then
        if self.real_index == index then
            self.select:SetActive(true)
            self.choose = true
        else
            self.choose = false
            self.select:SetActive(false)
        end
    end
end

function m:OnDestroy()
    if self.type == "normal" then
        Events.RemoveListener("onChoose")
    end
end

function m:Start()
   
end

return m