--
-- Created by IntelliJ IDEA.
-- User: jixinpeng
-- Date: 2015/8/20
-- Time: 13:43
-- To change this template use File | Settings | File Templates.
-- 

local m = {}

function m:update(data, index, delegate)
    self.cell1:CallUpdate({ server = data[1], delegate = delegate, index = data[1] })
    if data[2] then
        self.cell2:CallUpdate({ server = data[2], delegate = delegate, index = data[2] })
        self.binding:Show("cell2")
    else
        self.binding:Hide("cell2")
    end
	self.binding.gameObject:SetActive(true)
    --if self.grid ~= nil then
    --    self.binding:CallAfterTime(0.1, function()
    --        -- self.contentTable.repositionNow = true
    --        self.grid.transform.localPosition = Vector3(0, 0, 0)
    --    end)
    --end
end


return m

