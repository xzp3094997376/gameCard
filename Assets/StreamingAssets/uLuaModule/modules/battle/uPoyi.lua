local Poyi = {}
function Poyi:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end
function Poyi:Start()
  print("Heti:Start"..self._keyMap["isEditor"])
  if self._keyMap["isEditor"] == 1 then
     self.binding:CallAfterTime(0.1,
          function()
              self:update(109)
          end
          )
  end

end

--add for c# modify
function Poyi:update(id1)
   if id1 ~= nil  and id1 >0 then
        self.hero1:LoadByModelId(id1, "idle", function() end, true, 0, 1)
        self.hero2:LoadByModelId(id1, "idle", function() end, false, 0, 1)
        self.binding:CallAfterTime(0.35,
          function()
              MusicManager.playByID(61)
          end
          )
        local avter = TableReader:TableRowByID("avter", id1)
        if avter.poyi_audio ~= nil and avter.poyi_audio ~= "" and avter.poyi_audio ~= " " and avter.poyi_audio > 0 then
          MusicManager.playByID(avter.poyi_audio)
        end
   end
end

return Poyi