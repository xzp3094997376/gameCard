--掠夺对手头像icon
local m = {}

function m:update(char)
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.frame.gameObject)
    end
    self.__itemAll.gameObject:SetActive(true)
    self.__itemAll:CallUpdate({ "char", char, self.frame.width, self.frame.height })
end

return m