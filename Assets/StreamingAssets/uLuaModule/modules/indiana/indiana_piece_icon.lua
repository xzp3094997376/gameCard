--掠夺宝物碎片icon
local m = {}
--type = normal为掠夺主界面的宝物碎片，type = smelt为掠夺界面的宝物碎片
function m:update(data,index,delegate,ret)
    self._treasure = data.treasure
    self.delegate = delegate
    self.real_index = data.real_index
    self.choose = data.select
    self.img_frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.img_frame.gameObject)
    end
    self.__itemAll:CallUpdate({ "treasurePiece", self._treasure, self.img_frame.width, self.img_frame.height, true, nil, })
    self.__itemAll:CallTargetFunction("setTipsBtn",false)
    if ret ==nil then
        self.__itemAll:CallTargetFunction("setFrameEnable",false)
    end 
    self.type = data.type
    if self.type == "normal" then
        self.count.text = self._treasure.count
        if self._treasure.count == 0 then
            self.btn_mark.gameObject:SetActive(true)
        else
            self.btn_mark.gameObject:SetActive(false)
        end
		if self.name ~= nil then 
			self.name.text = ""
		end
    else
        self.count.text = ""
		if self.name ~= nil then 
			self.name.text = self._treasure:getDisplayColorName()
		end
    end
    

    if self.select ~= nil and self.choose ~= nil then
        self.select:SetActive(self.choose)
    end
end

--设置选中效果
function m:setSelect(flag)
    -- body
end

function m:OnDestroy()
    Events.RemoveListener('SelectCallBack')
end

function m:onClick(go,name)
    if self.type == "normal" then
        if name == "btn_mark" then   --弹出掠过对手列表
            Tool.push("indiana_list","Prefabs/moduleFabs/indiana/indiana_list", {treasure_id = self._treasure.id})
        elseif self._treasure.count<=0 then 
            Tool.push("indiana_list","Prefabs/moduleFabs/indiana/indiana_list", {treasure_id = self._treasure.id})
        else                                         --弹出获取途径
            local temp = {}
            temp.obj = self._treasure
            temp._type = "treasurePiece"
            MessageMrg.showTips(temp)
        end
    elseif self.type == "smelt" then
        if self.delegate ~= nil then
            if self.delegate.showMaterial then
                local temp = {}
                temp.treasure = self._treasure
                temp.real_index = self.real_index
                self.delegate:showMaterial(temp)
                Events.Brocast('SelectCallBack', self.real_index)
            end
        end
    else
        print("else======")
    end
end

function m:SelectCallBack(index)
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

function m:PlayEffect()
    if self.effect ~= nil then
        self.effect:SetActive(false)
        self.effect:SetActive(true)
    end
end

function m:setEffect(flag)
   if flag == nil then return end
   self.effect:SetActive(flag)
end

function m:Start()
    Events.AddListener("SelectCallBack", funcs.handler(self, m.SelectCallBack))
end

return m