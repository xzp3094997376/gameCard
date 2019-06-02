local level_up_item = {}

function level_up_item:update(data)
    self.before.text = data[1]
    self.after.text = data[2]
    self.attr.text = data[3]
end

function level_up_item:create()
    return self
end

return level_up_item