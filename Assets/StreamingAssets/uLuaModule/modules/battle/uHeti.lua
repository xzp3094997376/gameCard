local Heti = {}
local firstUpdate = false
function Heti:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function Heti:Start()
  print("Heti:Start"..self._keyMap["isEditor"])
  if self._keyMap["isEditor"] == 1 then
     self.binding:CallAfterTime(0.1,
          function()
              self:update(112,231,3,4)
          end
          )
  end

end

--add for c# modify
function Heti:update(id1, id2, id3, id4, id5)
   if id1 ~= nil  and id1 >0 then
        self.hero1:LoadByModelId(id1, "idle", function() end, false, -1, 1)
   end
   if id2 ~= nil  and id2 >0 then
        self.hero2:LoadByModelId(id2, "idle", function() end, false, -1, 1)
   end
   if id3 ~= nil  and id3 >0 then
        self.hero3:LoadByModelId(id3, "idle", function() end, false, -1, 1)
   end
end

return Heti