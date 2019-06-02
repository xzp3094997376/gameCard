--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/23
-- Time: 15:33
-- To change this template use File | Settings | File Templates.
--
local m = {}

function m:update(data)
    self.effect_node:SetActive(false)
    self.txt_attr.text = data.name
    self.txt_num.text = data.cur .. "/" .. data.max
    local sub = data.max - data.cur
    local arg = data.next
    if sub > 0 and arg > sub then arg = sub end

    local num = arg
    if sub == 0 and num > 0 then
        num = TextMap.GetValue("Text1129")
    elseif num == 0 then
        num = ""
    elseif num > 0 then
        num = m:getNum(num)
    elseif num < 0 then
        num = m:getNum(num)
    end
    self.txt_num_after.text = num
    self.slider.value = data.cur / data.max
    self.down:SetActive(false)
    self.up:SetActive(false)
    self.down:SetActive(data.next < 0)
    self.up:SetActive(data.next > 0)
    self.data = data
    local go = self.txt_num_after.gameObject
    go.transform.localScale = Vector3.one
end

function m:getNum(num)
    if num > 0 then
        return "[00ff00]+ " .. num .. "[-]"
    else
        return "[ff0000]- " .. (-num) .. "[-]"
    end
end

function m:showEffect(arg)
    self.effect_node:SetActive(false)
    self.effect_node:SetActive(true)
    self.txt_num_after.transform.localScale = Vector3(0, 0, 0)
    local sub = self.data.max - self.data.cur
    if arg > sub then arg = sub end

    local num = arg
    if num == 0 then
        num = TextMap.GetValue("Text1129")
    elseif num > 0 then
        num = m:getNum(num)
    elseif num < 0 then
        num = m:getNum(num)
    end

    self.txt_num_after.text = num
    self.down:SetActive(arg < 0)
    self.up:SetActive(arg > 0)
    local go = self.txt_num_after.gameObject
    self.binding:CallAfterTime(0.3, function()
        self.binding:ScaleToGameObject(go, 0.2, Vector3(1, 1, 1))
    end)
end

return m

