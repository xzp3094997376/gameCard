local m = {}
local firstUpdate = false
function m:create(binding)
    self.binding = binding
    self.gameObject = self.binding.gameObject
    return self
end

function m:Start()
end

--add for c# modify
function m:update(id1, id2)
  row = TableReader:TableRowByID("magics", id1)
   
  --local jiban = self:getSkillAttr()

    if row == nil then
      self.label.text = ""
    end
    local desc = ""
    desc = string.gsub("[ffff96]" .. row.format .. "[-]", "{0}", "[ffffff] +" .. math.floor(id2 / row.denominator) .. "[-]")
    self.label.text = desc
end

return m