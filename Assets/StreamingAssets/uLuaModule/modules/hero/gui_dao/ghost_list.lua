--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/1/23
-- Time: 14:23
-- To change this template use File | Settings | File Templates.
-- 鬼道列表
local m = {}


function m:onUpdate(char)
    if self.tab then
        self.tab:CallUpdate({ delegate = self, char = char, index = self.selectIndex })
    end
end

function m:isFull()
    return self.hasEnterCount >= self.max_slot
end

--刷新英雄列表
function m:showHeroList(ret)
    local charsList = {}
    --鬼道
    local empty = { empty = true }
    local ghostSlot = Player.ghostSlot
    self.hasEnterCount = 0
    for i = 0, 5 do
        local slot = ghostSlot[i]
        local id = slot.charid
        if id ~= 0 then
            local char = Char:new(id)
            table.insert(charsList, char)
            self.hasEnterCount = self.hasEnterCount + 1
        else
            table.insert(charsList, empty)
        end
    end
    self.hero_list_bg:refresh(charsList, self, false)
    return charsList
end


function m:update(arg)

    if arg == nil then arg = { 1 } end
    --    self.tab = ClientTool.loadAndGetLuaBinding("Prefabs/moduleFabs/guidao/heroGuiDao", self.binding.gameObject)
end

function m:refresh(ret)
    local charList = m:showHeroList(ret)

    m:onUpdate(charList[self.selectIndex + 1])
end

function m:onEnter()
    if self._exit == true then
        m:refresh(true)
        self._exit = false
    else
        self.tab:CallTargetFunction("updateTab")
    end
end



function m:onExit()
    self._exit = true
    if self.tip then
        self.tip:show("")
    end
end

function m:onCallBack(char, tp)
    local selectIndex = self.selectIndex
    --上阵
    Api:gd_charOn(char.id, selectIndex, function(result)
        m:refresh()
    end)
end

function m:Start()
    self.selectIndex = 0
    self.topMenu = LuaMain:ShowTopMenu()
    self.max_slot = Player.Resource.max_slot
    if self.max_slot > 6 then self.max_slot = 6 end
    m:refresh()
end

return m

