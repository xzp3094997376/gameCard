--
-- Created by IntelliJ IDEA.
-- User: xiyou
-- Date: 2015/3/14
-- Time: 17:10
-- To change this template use File | Settings | File Templates.
-- 排行奖励
local m = {}



function m:update(list)
	local _list = {}
	for i,v in ipairs(list) do
		local temp = v
		temp.delegate=self
		table.insert(_list, temp)
	end
    --ClientTool.UpdateGrid("", self.Grid, _list,self)
    self.scrollview:refresh(_list, self, false, 0)
end

function m:getScrollView()
    return self.view
end

function m:onClick(go, name)
    if name == "btn_close" then
        UIMrg:popWindow()
    end
end

return m

