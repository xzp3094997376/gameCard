local page = {}


function page:update(data, index, _table, delegate)
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.frame.gameObject)
--        self.binding:CallAfterTime(0.2, function() ClientTool.AdjustDepth(self.__itemAll.gameObject, self.frame.depth) end)
        self.frame.enabled = false
    end
    if self.has then
        if data.has == true then
            self.has:SetActive(true)
        else
            self.has:SetActive(false)
        end
    end
    local typeInfo = ""
    if data.__tp == "vo" then
        self.__itemAll:CallUpdate({ "itemvo", data, self.frame.width, self.frame.height, true, nil})
        if data.itemType== "item" and self.lb_num~=nil then 
            local color = Tool.getItemColor(data.itemTable.color)
            self.lb_num.text = color.color .. data.itemName .. "[-]"
        elseif self.lb_num~=nil then 
            self.lb_num.text =Tool.getNameColor(data.star or 1) .. data.itemName .. "[-]"
        end 
        self.__itemAll:CallTargetFunctionWithLuaTable("setDelegate", delegate)
        if data.color ~= nil then
           self.lb_num.text = Char:getItemColorName(data.color, data.name)
        end
        return
    elseif data.__tp == "char" or data.getType ~= nil then
        self.__itemAll:CallUpdate({ "char", data, self.frame.width, self.frame.height, true, nil})
        if self.lb_num~=nil then 
            self.lb_num.text =Tool.getNameColor(data.star or 1) .. data.name .. "[-]"
        end 
        self.__itemAll:CallTargetFunctionWithLuaTable("setDelegate", delegate)
        if data.color ~= nil then
           self.lb_num.text = Char:getItemColorName(data.color, data.name)
        end
        return
    end


    local _type = data.type
    local char = RewardMrg.getDropItem(data)
    if self.lb_num~=nil then 
        self.lb_num.text =Tool.getNameColor(char.star or char.color or 1) .. char.name .. "[-]"
    end 
    self.__itemAll:CallUpdate({ "char", char, self.frame.width, self.frame.height, true, nil})
	self.__itemAll:CallTargetFunctionWithLuaTable("setDelegate", delegate)
end

function page:setNum()
    if self.__itemAll ~=nil then 
        self.__itemAll:CallTargetFunctionWithLuaTable("HideNum")
    end 
end

function page:typeResId(_type)
    return Tool.typeId(_type) 
end

function page:onPress(go,name,bPress)
	if (self.delegate == nil or self.delegate.getScrollView == nil) then
		return
	end
  local sv = self.delegate:getScrollView()
	if sv ~= nil then
		sv:Press(bPress);
	end
end

function page:typeId(_type)
    return not Tool.typeId(_type)  
end

return page