--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/23
-- Time: 12:44
-- To change this template use File | Settings | File Templates.
-- 选择材料洗练

local m = {}

function m:update(data)
    self._data = data
    self.index = data.index
    self.delegate = data.delegate
    local atlasName = packTool:getIconByName(data.cur.icon)
    self.item_icon:setImage(data.cur.icon, atlasName)
    if data.cur.type == data.next.type then
        self.txt_num.text = (data.cur.num + data.next.num)
        self.binding:Hide("cost_icon")
        self.binding:Hide("txt_cost")
    else
        self.binding:Show("cost_icon")
        self.binding:Show("txt_cost")
        atlasName = packTool:getIconByName(data.next.icon)
        self.cost_icon:setImage(data.next.icon, atlasName)
        self.txt_cost.text = data.next.num
        self.txt_num.text = data.cur.num
    end
    self.danyao.text = data.type
    if data.times ~= nil then
        print("..........lailelaile")
        self:SelectNum(data.times)
    end
end

function m:onClick()
    self.delegate:selectIndex(self.index)
end

function m:SelectNum(_times)
    if self._data.cur.type == self._data.next.type then
        self.txt_num.text = (self._data.cur.num + self._data.next.num)*_times
    else
        self.txt_cost.text = self._data.next.num*_times
        self.txt_num.text = self._data.cur.num*_times
    end
end

return m

