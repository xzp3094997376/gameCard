local m = {}

function m:update(data, index, delegate)
	self.txt_rank.text = data.no .. "  " .. data.name .. "  " .. data.gongxun
end

return m