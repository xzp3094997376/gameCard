local m = {}

local infobinding

function m:update(data)
    local info = data
    self.frame.gameObject:SetActive(false)
    local name = ""
    local num = 0
    local star=1
    self.name.text = ""
	--print("type = " .. info.type)
    if infobinding == nil then
        infobinding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.go)
    end
    
    local char = RewardMrg.getDropItem(info)
    infobinding:CallUpdate({ "char", char, self.frame.width, self.frame.height,true,nil,nil ,nil ,false})
    star = char.star or char.color or 1
    name = Tool.getNameColor(star) .. char.name .. "[-]"
    num = char.rwCount or 0
    if num > 1 then
        self.num.text = toolFun.moneyNumber(num)
    else
        self.num.text = ""
    end
    --  print("afs num" .. num)
    self.name.text = Tool.getNameColor(star) .. name .. "[-]"
end

return m