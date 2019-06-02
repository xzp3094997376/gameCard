local m = {}

function m:update(data)
    --self.txt_name.text = data.name
    self.txt_progress.text = data.cur .. "/" .. data.max
    local sub = data.max - data.cur
    local arg = data.next

    self.bar_progress.value = data.cur / data.max
    self.data = data

end

return m

