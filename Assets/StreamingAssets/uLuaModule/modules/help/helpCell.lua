local helpCell = {}

function helpCell:create(binding)
    self.binding = binding
    return self
end

function helpCell:update(table, index)
    self.openName.text = TextMap.GetValue("Text1053") .. table.open_condition
    self.modulePro.text = TextMap.GetValue("Text1054") .. table.desc
    self.Label.text = table.help_type
end

return helpCell