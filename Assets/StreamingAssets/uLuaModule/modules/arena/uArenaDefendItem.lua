local arenadefenditem = {}
local binding
function arenadefenditem:update(peppleData)
    self.frame.gameObject:SetActive(false)
    if peppleData.isHaveData then
        self.Sprite:SetActive(false)
        if binding == nil then
            binding = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.myPeople)
        end
        binding.gameObject:SetActive(true)
        binding:CallUpdate({ "char", peppleData, self.frame.width, self.frame.height })
        local name = Tool.getNameColor(peppleData.quality)..peppleData:getDisplayName().."[-]"
		self.txt_name.text = name
    else
        if binding ~= nil then
            binding.gameObject:SetActive(false)
        end
        self.Sprite:SetActive(true)
        self.txt_name.text = ""
    end
end

--初始化
function arenadefenditem:create(binding)
    self.binding = binding
    return self
end

return arenadefenditem