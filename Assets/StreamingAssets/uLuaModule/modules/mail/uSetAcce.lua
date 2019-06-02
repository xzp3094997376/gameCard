local setValue = {}

function setValue:Start()

end

local infobinding
function setValue:update(data, index, _table, delegate)
    if data ~= nil then
        local isGet = data.isGet
        if self.hasGet ~= nil then
            self.hasGet:SetActive(false)
        end
        BlackGo.setBlack(1, self.go.transform)
        local name = ""
		local star = 1
        local isTip = data.isShowTips
        if isTip == false then
            isTip = nil
        end
        local info = data.v
        if info ~= nil then
            if info.type == "char" or info.type == "pet" or info.type == "yuling" then
                local char = nil 
                if info.type == "char" then 
                    char = Char:new(nil, info.arg)
                elseif info.type == "pet" then 
                    char = Pet:new(nil, info.arg)
                elseif info.type == "yuling" then 
                    char = Yuling:new(info.arg)
				end 
                self.item_kuangzi.gameObject:SetActive(false)
                if infobinding == nil then
                    infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
                end
                name = char.name
				star = char.star
                infobinding:CallUpdate({ "char", char, self.item_kuangzi.width, self.item_kuangzi.height, isTip, nil, true })
                infobinding:CallTargetFunctionWithLuaTable("setDelegate", delegate)
                if data.showName ~= nil then
                    if self.name then
                        if star then 
                            name = Char:getItemColorName(star, name)
                        end 
                        self.name.text = name
                    end
                end
            elseif Tool.typeId(info.type)==false then
                local char = RewardMrg.getDropItem(info)
                self.item_kuangzi.gameObject:SetActive(false)
                if infobinding == nil then
                    infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
                end
                name = char.name
				star = char.star
                infobinding:CallUpdate({ "char", char, self.item_kuangzi.width, self.item_kuangzi.height, isTip, nil, true })
                infobinding:CallTargetFunctionWithLuaTable("setDelegate", delegate)

                if data.showName ~= nil then
                    if self.name then
                        if star then 
                            name = Char:getItemColorName(star, name)
                        end 
                        self.name.text = name
                    end
                end
			else
                local char = RewardMrg.getDropItem(info)
                name = Tool.getNameColor(char.star or char.color or 1) .. char.name .. "[-]"
                star = char.star or char.color or 1
                self.item_kuangzi.gameObject:SetActive(false)
                if infobinding == nil then
                    infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
                end
                if data.showName ~= nil then
                    if self.name then
                        if star then 
                            name = Char:getItemColorName(star, name)
                        end 
                        self.name.text = name
                    end
                end
                infobinding:CallUpdate({ "char", char, self.item_kuangzi.width, self.item_kuangzi.height, isTip, nil, true })
                infobinding:CallTargetFunctionWithLuaTable("setDelegate", delegate)
            end
        end
        if isGet then
            BlackGo.setBlack(0.5, self.go.transform)
            self.hasGet:SetActive(true)
        end
    end
end


return setValue