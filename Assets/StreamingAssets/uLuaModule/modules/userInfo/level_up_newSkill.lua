local level_up_newSkill = {}

function level_up_newSkill:update(data)
    self.skillName.text = data[1]
end

function level_up_newSkill:create()
    return self
end

return level_up_newSkill