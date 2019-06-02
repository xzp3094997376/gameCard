--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/21
-- Time: 20:16
-- To change this template use File | Settings | File Templates.
-- 鬼道角色碎片。
local m = {}

function m:update(data)
    self.data = data
    self.star = data.star
    self.frame.enabled = false
    if self.__itemAll == nil then
        self.__itemAll = ClientTool.loadAndGetLuaBindingFromPool("Prefabs/publicPrefabs/itemAll", self.frame.gameObject)
    end
    Tool.SetActive(self.__itemAll, true)
    local count = data._rwCount
    data.rwCount = 1
    self.__itemAll:CallUpdate({ "char", data, self.frame.width, self.frame.height })
    self.binding:Hide("add")
    self.txt_name.text = Tool.getNameColor(data.star) .. data.name .. "[-]"
    local c = data.count
    if c < count then c = Tool.red .. c .. "[-]"
    else
        c = "[00ff00]" .. c .. "[-]"
    end
    self.txt_num.text = c .. "/" .. count
end


-- function m:reset(star,delegate)
-- self.star = star
-- if star == 3 then
--     self.add.spriteName = "guidao_add1"
--     self.frame.spriteName = "item_green"
--     self.bg.spriteName = "tubiao_2"
-- elseif star == 4 then
--     self.add.spriteName = "guidao_add2"
--     self.frame.spriteName = "item_blue"
--     self.bg.spriteName = "tubiao_3"
-- elseif star == 5 then
--     self.add.spriteName = "guidao_add3"
--     self.frame.spriteName = "item_purple"
--     self.bg.spriteName = "tubiao_4"
-- elseif star == 6 then
--     self.add.spriteName = "guidao_add4"
--     self.frame.spriteName = "item_cheng"
--     self.bg.spriteName = "tubiao_4"
-- elseif star == 7 then
--     self.add.spriteName = "guidao_add5"
--     self.frame.spriteName = "item_red"
--     self.bg.spriteName = "tubiao_6"
-- end
-- self.data = nil
-- self.binding:Show("add")
-- self.frame.enabled = true
-- Tool.SetActive(self.__itemAll, false)
-- self._isEmpty = true
-- if self.filter == nil and delegate then
--     self.filter = funcs.handler(delegate,delegate.filter)
-- end
-- end

-- function m:isEmpty()
--     return self._isEmpty
-- end
function m:showDrop()
    --DialogMrg.showPieceDrop(self.data)
    local temp = {}
    temp.obj = self.data
    temp._type = "char"
    MessageMrg.showTips(temp)
end

function m:Start()
    ClientTool.AddClick(self.gameObject, function()
        m:showDrop()
    end)
end

return m

