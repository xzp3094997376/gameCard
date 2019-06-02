local SkillName = {}
function SkillName:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

--add for c# modify
function SkillName:update(id1)
   if id1 ~= nil  and id1 >0 then
   		local tab = TableReader:TableRowByID("skill", id1)
   		print("tab.show"..tab.show)
   		self.name.text = tab.show

   end
end

return SkillName