
local m = {}

function m:update(lua)
	self.skillId = lua.id
	local tb = TableReader:TableRowByID("skill", self.skillId)
	if tb then 
		self.txt_Name.text = "【"..tb.show.."】"
		self.txt_desc.text = tb.desc
	else 
		self.txt_desc.text = ""
	end
	self.bg.height = self.txt_desc.height + 30
end

function m:height()
	return self.bg.height
end	

function m:Start()

end

return m
