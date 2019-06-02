local M = {}

function M:update(lua_data, index, table)
	local data = lua_data.data
    self.index = index
    --self.labName.text = data.name
    self.item_frame.enabled = false

    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.item_frame.gameObject)
    end

    local _type = data.type
    local char = RewardMrg.getDropItem(data)
    self.labName.text =Tool.getNameColor(char.star or char.color or 1) .. char.name .. "[-]"
    self.__itemAll:CallUpdate({ "char", char, self.item_frame.width, self.item_frame.height, true, nil, true })
    self.__itemAll:CallTargetFunctionWithLuaTable("setTipsBtn",false)
    ClientTool.AddClick(self.btn_Item,function ()
    	lua_data.delegate:SelectMeCb(self.index)
    	UIMrg:popWindow()
    end)
end

function M:play(cb)
    self.binding:PlayTween("ani", 0.3, function()
        if cb then cb() end
    end)
end



return M