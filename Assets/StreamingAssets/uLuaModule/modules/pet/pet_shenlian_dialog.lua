
local m = {}

function m:update(lua)
	self.pet = lua.pet
    self.cur = lua.cur
	self.next = lua.next
	self:onUpdate()
end

function m:onUpdate()
	self.txt_shenlian.text = TextMap.GetValue("Text_1_969") .. self.cur .. TextMap.GetValue("Text_1_970")
	self.txt_shenlian_next.text = TextMap.GetValue("Text_1_969") .. self.next .. TextMap.GetValue("Text_1_970")
	self.txt_shenlian_cur.text = TextMap.GetValue("Text_1_971") .. self.pet.shenlian
	
	local row = TableReader:TableRowByUniqueKey("petShenlian", self.pet.dictid, self.cur)
	self.pos_left:CallUpdate(row)
	
	row = TableReader:TableRowByUniqueKey("petShenlian", self.pet.dictid, self.next)
	self.pos_right:CallUpdate(row)
end 		

function m:Start()

end

function m:onClick(go, name)
    if name == "btnBack" then
        UIMrg:popWindow()
	end
end

return m
