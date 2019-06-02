-- 跨服比武挑战前三名玩家阵容信息
local m = {}

function m:Start(...)
end

function m:update(data)
    if data == nil then return end
    self.data = data
    self:updateGrid(self.data)
end

function m:updateGrid(arr)
    for i = 1, 6 do
        local temp_char = {}
        if arr[i-1] ~= nil then
            temp_char = Char:new(arr[i - 1].id)
            temp_char.isHaveData = true
            temp_char.lv = arr[i - 1].level
            temp_char.star_level = arr[i - 1].star
            temp_char.stage = arr[i - 1].stage
            temp_char.customNameIndex = i - 1
        else
            temp_char.isHaveData = false
        end 
        local binding1 = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/arenaModule/myPeople", self.grid.gameObject)
        binding1:CallUpdate(temp_char)
        binding1 = nil
        temp_char = nil
    end

    self.grid.repositionNow = true
end

function m:onClick(go, name)
    if name == "btn_close" then 
        UIMrg:popWindow()
    end
end

return m