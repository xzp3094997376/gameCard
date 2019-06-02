--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/7/26
-- Time: 17:23
-- To change this template use File | Settings | File Templates.
-- 角色列表项
local m = {}

function m:update(data, index, delegate)
	if data==nil then 
		self.hero_char_items:SetActive(false)
	else
		self.hero_char_items:SetActive(true)
		self.selectCharCell1:CallUpdate({ char = data[1], delegate = delegate, index = index })
		if data[2] then
			self.selectCharCell2:CallUpdate({ char = data[2], delegate = delegate, index = index })
			self.binding:Show("selectCharCell2")
		else
			self.binding:Hide("selectCharCell2")
		end
    end
end

function m:onUpdate()
	self.selectCharCell1:CallTargetFunction("onUpdate")
	self.selectCharCell2:CallTargetFunction("onUpdate")
end

return m
